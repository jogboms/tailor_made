import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/jobs/ui/measure_create_items.dart';
import 'package:tailor_made/pages/jobs/ui/measures.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/full_button.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactMeasure extends StatefulWidget {
  final ContactModel contact;

  ContactMeasure({
    Key key,
    @required this.contact,
  }) : super(key: key);

  @override
  _ContactMeasureState createState() => new _ContactMeasureState();
}

class _ContactMeasureState extends State<ContactMeasure> with SnackBarProvider {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    List<Widget> children = [];

    children.add(makeHeader("Measurements", "Inches (In)"));
    children.add(MeasureCreateItems(widget.contact.measurements));

    children.add(
      Padding(
        child: FullButton(
          child: Text(
            "FINISH",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _handleSubmit,
        ),
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 50.0),
      ),
    );

    children.add(SizedBox(height: 32.0));

    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Measurements",
        actions: [
          IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: kTitleBaseColor,
            ),
            onPressed: () => TMNavigate(
                  context,
                  MeasuresPage(measurements: widget.contact.measurements),
                  fullscreenDialog: true,
                ),
          )
        ],
      ),
      body: new SafeArea(
        top: false,
        child: new SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget makeHeader(String title, [String trailing = ""]) {
    return new Container(
      color: Colors.grey[100].withOpacity(.4),
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      alignment: AlignmentDirectional.centerStart,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title.toUpperCase(), style: ralewayLight(12.0, kTextBaseColor.shade800)),
          Text(trailing, style: ralewayLight(12.0, kTextBaseColor.shade800)),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showLoadingSnackBar();

      try {
        // During contact creation
        if (widget.contact.reference != null) {
          await widget.contact.reference.updateData(widget.contact.toMap());
        }
        closeLoadingSnackBar();
        showInSnackBar("Successfully Updated");
      } catch (e) {
        closeLoadingSnackBar();
        showInSnackBar(e.toString());
      }
    }
  }
}
