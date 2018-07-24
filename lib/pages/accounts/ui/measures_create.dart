import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/accounts/ui/measure_dialog.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
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
  String groupName;
  // final _group = new TextEditingController();
  List<MeasureModel> measures = <MeasureModel>[];

  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // _group.l
  }

  // TODO this can still be better written
  void _handleAddItem() async {
    final FormState form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
    } else {
      form.save();

      final _measure = await Navigator.push<MeasureModel>(
        context,
        TMNavigate.fadeIn<MeasureModel>(
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            backgroundColor: Colors.black38,
            body: MeasureDialog(
              measure: new MeasureModel(
                name: "",
                group: groupName,
              ),
            ),
          ),
        ),
      );

      print(_measure);

      if (_measure == null) {
        return;
      }

      setState(() {
        measures = [_measure]..addAll(measures);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    final List<Widget> children = [];

    children.add(makeHeader("Group Name"));
    children.add(buildEnterName());

    if (measures.isNotEmpty) {
      children.add(makeHeader("Group Items"));
      children.add(buildGroupItems());

      children.add(SizedBox(height: 84.0));
    }

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
            icon: Icon(Icons.check),
            onPressed: measures.isEmpty ? null : _handleSubmit,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: new Icon(Icons.add_circle_outline),
        backgroundColor: Colors.white,
        foregroundColor: kAccentColor,
        label: Text("Add Item"),
        onPressed: _handleAddItem,
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
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: new InputDecoration(
          isDense: true,
          hintText: "eg Blouse",
          hintStyle: TextStyle(fontSize: 14.0),
        ),
        validator: (value) => (value.isNotEmpty) ? null : "Please input a name",
        onSaved: (value) => groupName = value.trim(),
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

  Widget buildGroupItems() {
    final items = List.generate(measures.length, (index) {
      final measure = measures[index];
      return ListTile(
        dense: true,
        title: Text(measure.name),
        subtitle: Text(measure.unit),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline),
          iconSize: 20.0,
          onPressed: () {
            setState(() {
              measures = measures..removeAt(index);
            });
          },
        ),
      );
    });
    return new Column(
      children: items.toList(),
    );
  }

  void _handleSubmit() async {
    final WriteBatch batch = CloudDb.instance.batch();

    measures.forEach((measure) {
      batch.setData(
        CloudDb.measurements.document(measure.id),
        measure.toMap(),
        merge: true,
      );
    });

    showLoadingSnackBar();
    try {
      await batch.commit();

      closeLoadingSnackBar();
      Navigator.pop(context);
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}
