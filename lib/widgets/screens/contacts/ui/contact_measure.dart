import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_snackbar_provider.dart';
import 'package:tailor_made/widgets/_partials/full_button.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';
import 'package:tailor_made/widgets/screens/measures/measures.dart';
import 'package:tailor_made/widgets/screens/measures/ui/measure_create_items.dart';

class ContactMeasure extends StatefulWidget {
  const ContactMeasure({
    Key key,
    @required this.grouped,
    @required this.contact,
  }) : super(key: key);

  final Map<String, List<MeasureModel>> grouped;
  final ContactModel contact;

  @override
  _ContactMeasureState createState() => _ContactMeasureState();
}

class _ContactMeasureState extends State<ContactMeasure>
    with MkSnackBarProvider {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  ContactModel contact;

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    contact = widget.contact.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    children.add(makeHeader("Measurements", "Inches (In)"));
    children.add(MeasureCreateItems(
      grouped: widget.grouped,
      measurements: contact.measurements,
    ));

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

    return Scaffold(
      key: scaffoldKey,
      appBar: MkAppBar(
        title: Text("Measurements"),
        leading: MkBackButton(
          onPop: contact?.reference != null
              ? null
              : () => Navigator.pop<ContactModel>(context, contact),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: kTitleBaseColor,
            ),
            onPressed: () => MkNavigate(
                  context,
                  MeasuresPage(
                    measurements: contact.measurements,
                  ),
                  fullscreenDialog: true,
                ),
          )
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: Column(
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
    return Container(
      color: Colors.grey[100].withOpacity(.4),
      margin: const EdgeInsets.only(top: 8.0),
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: mkFontLight(12.0, kTextBaseColor),
          ),
          Text(
            trailing,
            style: mkFontLight(12.0, kTextBaseColor),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar(MkStrings.fixErrors);
    } else {
      form.save();
      showLoadingSnackBar();

      try {
        // TODO find a way to remove this from here
        // During contact creation
        if (contact.reference != null) {
          await contact.reference.updateData(contact.toMap());
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
