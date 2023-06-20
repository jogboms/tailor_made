import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class MeasuresCreate extends StatefulWidget {
  const MeasuresCreate({super.key, this.measures, this.groupName, this.unitValue});

  final List<MeasureModel>? measures;
  final String? groupName, unitValue;

  @override
  State<MeasuresCreate> createState() => _MeasuresCreateState();
}

class _MeasuresCreateState extends State<MeasuresCreate> with DispatchProvider<AppState> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  String? groupName, unitValue;
  late List<MeasureModel> measures;

  @override
  void initState() {
    super.initState();
    measures = widget.measures ?? <MeasureModel>[];
    groupName = widget.groupName ?? '';
    unitValue = widget.unitValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, MeasuresViewModel>(
      converter: MeasuresViewModel.new,
      builder: (BuildContext context, _, MeasuresViewModel vm) {
        final List<Widget> children = <Widget>[];

        children.add(const FormSectionHeader(title: 'Group Name'));
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: TextFormField(
              initialValue: groupName,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'eg Blouse',
              ),
              validator: (String? value) => (value!.isNotEmpty) ? null : 'Please input a name',
              onSaved: (String? value) => groupName = value!.trim(),
            ),
          ),
        );

        children.add(const FormSectionHeader(title: 'Group Unit'));
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: TextFormField(
              initialValue: unitValue,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Unit (eg. In, cm)',
              ),
              validator: (String? value) => (value!.isNotEmpty) ? null : 'Please input a value',
              onSaved: (String? value) => unitValue = value!.trim(),
            ),
          ),
        );

        if (measures.isNotEmpty) {
          children.add(const FormSectionHeader(title: 'Group Items'));
          children.add(
            _GroupItems(
              measures: measures,
              onPressed: (MeasureModel measure) => _onTapDeleteItem(vm, measure),
            ),
          );

          children.add(const SizedBox(height: 84.0));
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: const Text(''),
            leading: const AppCloseButton(),
            actions: <Widget>[
              AppClearButton(
                color: Colors.black,
                onPressed: measures.isEmpty ? null : () => _handleSubmit(vm),
                child: const Text('SAVE'),
              )
            ],
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add_circle_outline),
            backgroundColor: Colors.white,
            foregroundColor: kAccentColor,
            label: const Text('Add Item'),
            onPressed: _handleAddItem,
          ),
        );
      },
    );
  }

  void _onTapDeleteItem(MeasuresViewModel vm, MeasureModel measure) async {
    final AppSnackBar snackBar = AppSnackBar.of(context);
    final bool? choice = await showChoiceDialog(context: context, message: 'Are you sure?');
    if (choice == null || choice == false) {
      return;
    }
    final Reference? reference = measure.reference;
    if (reference == null) {
      _removeFromLocal(measure.id);
      return;
    }

    snackBar.loading();
    try {
      dispatchAction(const ToggleMeasuresLoading());
      await reference.delete();
      _removeFromLocal(measure.id);
      snackBar.hide();
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      snackBar.error(error.toString());
    }
  }

  void _handleAddItem() async {
    if (_isOkForm()) {
      final MeasureModel? measure =
          await context.registry.get<MeasuresCoordinator>().toCreateMeasureItem(groupName, unitValue);

      if (measure == null) {
        return;
      }

      setState(() {
        measures = <MeasureModel>[measure, ...measures];
      });
    }
  }

  void _handleSubmit(MeasuresViewModel vm) async {
    if (_isOkForm()) {
      final AppSnackBar snackBar = AppSnackBar.of(context)..loading();

      try {
        final NavigatorState navigator = Navigator.of(context);
        dispatchAction(const ToggleMeasuresLoading());
        // TODO(Jogboms): move this out of here
        await context.registry.get<Measures>().create(measures, vm.userId, groupName: groupName, unitValue: unitValue);
        snackBar.hide();
        navigator.pop();
      } catch (e) {
        snackBar.error(e.toString());
      }
    }
  }

  bool _isOkForm() {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return false;
    }

    if (!form.validate()) {
      _autovalidate = true;
      return false;
    }

    form.save();
    return true;
  }

  void _removeFromLocal(String id) {
    setState(() {
      measures = measures..removeWhere((_) => _.id == id);
    });
  }
}

class _GroupItems extends StatelessWidget {
  const _GroupItems({required this.measures, required this.onPressed});

  final List<MeasureModel>? measures;
  final ValueSetter<MeasureModel> onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (MeasureModel measure in measures!)
          ListTile(
            dense: true,
            title: Text(measure.name),
            subtitle: Text(measure.unit),
            trailing: IconButton(
              icon: Icon(measure.reference != null ? Icons.delete : Icons.remove_circle_outline),
              iconSize: 20.0,
              onPressed: () => onPressed(measure),
            ),
          )
      ],
    );
  }
}