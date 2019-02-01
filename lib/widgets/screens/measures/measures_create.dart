import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/actions/measures.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/measures.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/mk_choice_dialog.dart';
import 'package:tailor_made/utils/mk_dispatch_provider.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_snackbar_provider.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/screens/measures/ui/measure_dialog.dart';

class MeasuresCreate extends StatefulWidget {
  const MeasuresCreate({
    Key key,
    this.measures,
    this.groupName,
    this.unitValue,
  }) : super(key: key);

  final List<MeasureModel> measures;
  final String groupName, unitValue;

  @override
  MeasuresCreateState createState() => MeasuresCreateState();
}

class MeasuresCreateState extends State<MeasuresCreate>
    with MkSnackBarProvider, MkDispatchProvider<AppState> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  String groupName, unitValue;
  List<MeasureModel> measures;
  final FocusNode _unitNode = FocusNode();

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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        MeasuresViewModel vm,
      ) {
        final List<Widget> children = [];

        children.add(makeHeader("Group Name"));
        children.add(buildEnterName());

        children.add(makeHeader("Group Unit"));
        children.add(buildEnterUnit());

        if (measures.isNotEmpty) {
          children.add(makeHeader("Group Items"));
          children.add(buildGroupItems(vm));

          children.add(const SizedBox(height: 84.0));
        }

        return Scaffold(
          resizeToAvoidBottomPadding: false,
          key: scaffoldKey,
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: false,
            elevation: 1.0,
            actions: [
              MkClearButton(
                child: const Text("SAVE"),
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
            icon: const Icon(Icons.add_circle_outline),
            backgroundColor: Colors.white,
            foregroundColor: kAccentColor,
            label: const Text("Add Item"),
            onPressed: _handleAddItem,
          ),
        );
      },
    );
  }

  Widget makeHeader(String title, [String trailing = ""]) {
    return Container(
      color: Colors.grey[100].withOpacity(.4),
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: MkTheme.of(context).small,
          ),
          Text(trailing, style: MkTheme.of(context).small),
        ],
      ),
    );
  }

  Widget buildEnterName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        initialValue: groupName,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_unitNode),
        keyboardType: TextInputType.text,
        // TODO
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: const InputDecoration(
          isDense: true,
          hintText: "eg Blouse",
        ),
        validator: (value) => (value.isNotEmpty) ? null : "Please input a name",
        onSaved: (value) => groupName = value.trim(),
      ),
    );
  }

  Widget buildEnterUnit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        focusNode: _unitNode,
        initialValue: unitValue,
        keyboardType: TextInputType.text,
        // TODO
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: const InputDecoration(
          isDense: true,
          hintText: "Unit (eg. In, cm)",
        ),
        validator: (value) =>
            (value.isNotEmpty) ? null : "Please input a value",
        onSaved: (value) => unitValue = value.trim(),
      ),
    );
  }

  Widget buildBody(List<Widget> children) {
    return SafeArea(
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
    return Column(
      children: items.toList(),
    );
  }

  void onTapDeleteItem(MeasuresViewModel vm, MeasureModel measure) async {
    final choice = await mkChoiceDialog(
      context: context,
      title: "",
      message: "Are you sure?",
    );
    if (choice == null || choice == false) {
      return;
    }

    showLoadingSnackBar();

    try {
      dispatchAction(const ToggleMeasuresLoading());
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
      MkNavigate.fadeIn<MeasureModel>(
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Colors.black38,
          body: MeasureDialog(
            measure: MeasureModel(
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
        dispatchAction(const ToggleMeasuresLoading());
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
