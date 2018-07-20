import 'package:flutter/material.dart';
import 'package:tailor_made/ui/full_button.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasuresCreate extends StatefulWidget {
  const MeasuresCreate({
    Key key,
  }) : super(key: key);

  @override
  MeasuresCreateState createState() => new MeasuresCreateState();
}

class MeasuresCreateState extends State<MeasuresCreate> with SnackBarProvider {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  String group_name;
  final List<dynamic> measures = <dynamic>[];

  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    final List<Widget> children = [];

    children.add(makeHeader("Group Name"));
    children.add(buildEnterName());

    children.add(
      Padding(
        child: FullButton(
          child: Text(
            "FINISH",
            style: TextStyle(color: Colors.white),
          ),
          // onPressed: _handleSubmit,
          onPressed: measures.isEmpty ? null : _handleSubmit,
        ),
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 50.0),
      ),
    );

    children.add(SizedBox(height: 32.0));

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldColor,
      appBar: AppBar(
        title: Text("Add Group", style: theme.appBarStyle),
        brightness: Brightness.light,
        centerTitle: false,
        elevation: 1.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: Theme(
        data: ThemeData(
          hintColor: kHintColor,
          primaryColor: kPrimaryColor,
        ),
        child: buildBody(theme, children),
      ),
    );
  }

  Widget makeHeader(String title, [String trailing = ""]) {
    return new Container(
      color: Colors.grey[100].withOpacity(.4),
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      alignment: AlignmentDirectional.centerStart,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: ralewayLight(12.0, kTextBaseColor.shade800),
          ),
          Text(trailing, style: ralewayLight(12.0, kTextBaseColor.shade800)),
        ],
      ),
    );
  }

  Widget buildEnterName() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: new TextFormField(
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: new InputDecoration(
          isDense: true,
          hintText: "Enter Group Name",
          hintStyle: TextStyle(fontSize: 14.0),
        ),
        validator: (value) => (value.isNotEmpty) ? null : "Please input a name",
        onSaved: (value) => group_name = value.trim(),
      ),
    );
  }

  Widget buildBody(TMTheme theme, List<Widget> children) {
    return new SafeArea(
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
    );
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) {
      return;
    }

    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showLoadingSnackBar();
      try {} catch (e) {
        closeLoadingSnackBar();
        showInSnackBar(e.toString());
      }
    }
  }
}
