import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/measures/ui/measure_dialog.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/measures.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasuresCreate extends StatefulWidget {
  final List<MeasureModel> measures;
  final String groupName, unitValue;

  const MeasuresCreate({
    Key key,
    this.measures,
    this.groupName,
    this.unitValue,
  }) : super(key: key);

  @override
  MeasuresCreateState createState() => new MeasuresCreateState();
}

class MeasuresCreateState extends State<MeasuresCreate> with SnackBarProvider {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  String groupName, unitValue;
  List<MeasureModel> measures;
  final FocusNode _unitNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    measures = widget.measures ?? <MeasureModel>[];
    groupName = widget.groupName ?? "";
    unitValue = widget.unitValue ?? "";
  }

  @override
  void dispose() {
    _unitNode.dispose();
    super.dispose();
  }

  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return StoreConnector<ReduxState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (BuildContext context, vm) {
        final List<Widget> children = [];

        children.add(makeHeader("Group Name"));
        children.add(buildEnterName());

        children.add(makeHeader("Group Unit"));
        children.add(buildEnterUnit());

        if (measures.isNotEmpty) {
          children.add(makeHeader("Group Items"));
          children.add(buildGroupItems(vm));

          children.add(SizedBox(height: 84.0));
        }

        return Scaffold(
          resizeToAvoidBottomPadding: false,
          key: scaffoldKey,
          backgroundColor: theme.scaffoldColor,
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: false,
            elevation: 1.0,
            actions: [
              FlatButton(
                child: Text("SAVE", style: TextStyle(fontSize: 18.0)),
                onPressed: measures.isEmpty ? null : () => _handleSubmit(vm),
              )
            ],
          ),
          body: Theme(
            data: ThemeData(
              hintColor: kHintColor,
              primaryColor: kPrimaryColor,
            ),
            child: buildBody(children),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            icon: new Icon(Icons.add_circle_outline),
            backgroundColor: Colors.white,
            foregroundColor: kAccentColor,
            label: Text("Add Item"),
            onPressed: _handleAddItem,
          ),
        );
      },
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
        initialValue: groupName,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_unitNode),
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

  Widget buildEnterUnit() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: new TextFormField(
        focusNode: _unitNode,
        initialValue: unitValue,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: new InputDecoration(
          isDense: true,
          hintText: "Unit (eg. In, cm)",
          hintStyle: TextStyle(fontSize: 14.0),
        ),
        validator: (value) =>
            (value.isNotEmpty) ? null : "Please input a value",
        onSaved: (value) => unitValue = value.trim(),
      ),
    );
  }

  Widget buildBody(List<Widget> children) {
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

  Widget buildGroupItems(MeasuresViewModel vm) {
    final items = List.generate(measures.length, (index) {
      final measure = measures[index];
      return ListTile(
        dense: true,
        title: Text(measure.name),
        subtitle: Text(measure.unit),
        trailing: IconButton(
          icon: Icon(
            measure?.reference != null
                ? Icons.delete
                : Icons.remove_circle_outline,
          ),
          iconSize: 20.0,
          onPressed: () {
            if (measure?.reference != null) {
              onTapDeleteItem(vm, measure);
            }
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

  void onTapDeleteItem(MeasuresViewModel vm, MeasureModel measure) async {
    final choice = await confirmDialog(
      context: context,
      content: Text("Are you sure?"),
    );
    if (choice == null || choice == false) {
      return;
    }

    showLoadingSnackBar();

    try {
      vm.toggleLoading();
      await measure.reference.delete();
      closeLoadingSnackBar();
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }

  void _handleAddItem() async {
    if (_isOkForm()) {
      final _measure = await _itemModal();

      if (_measure == null) {
        return;
      }

      setState(() {
        measures = [_measure]..addAll(measures);
      });
    }
  }

  Future<MeasureModel> _itemModal() {
    return Navigator.push<MeasureModel>(
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
              unit: unitValue,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit(MeasuresViewModel vm) async {
    if (_isOkForm()) {
      final WriteBatch batch = CloudDb.instance.batch();

      measures.forEach((measure) {
        if (measure?.reference != null) {
          batch.updateData(
            measure.reference,
            <String, String>{
              "group": groupName,
              "unit": unitValue,
            },
          );
        } else {
          batch.setData(
            CloudDb.measurements.document(measure.id),
            measure.toMap(),
            merge: true,
          );
        }
      });

      showLoadingSnackBar();
      try {
        vm.toggleLoading();
        await batch.commit();

        closeLoadingSnackBar();
        Navigator.pop(context);
      } catch (e) {
        closeLoadingSnackBar();
        showInSnackBar(e.toString());
      }
    }
  }

  bool _isOkForm() {
    final FormState form = _formKey.currentState;
    if (form == null) {
      return false;
    }
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      return false;
    } else {
      form.save();
      return true;
    }
  }
}
