import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class MeasuresCreate extends StatefulWidget {
  const MeasuresCreate({super.key, this.measures, this.groupName, this.unitValue});

  final List<BaseMeasureEntity>? measures;
  final MeasureGroup? groupName;
  final String? unitValue;

  @override
  State<MeasuresCreate> createState() => _MeasuresCreateState();
}

class _MeasuresCreateState extends State<MeasuresCreate> with StoreDispatchMixin<AppState> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  late MeasureGroup _groupName = widget.groupName ?? MeasureGroup.empty;
  late String? _unitValue = widget.unitValue ?? '';
  late List<BaseMeasureEntity> _measures = widget.measures ?? <BaseMeasureEntity>[];

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
              initialValue: _groupName.displayName,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'eg Blouse',
              ),
              validator: (String? value) => (value!.isNotEmpty) ? null : 'Please input a name',
              onSaved: (String? value) => _groupName = MeasureGroup.valueOf(value!.trim()),
            ),
          ),
        );

        children.add(const FormSectionHeader(title: 'Group Unit'));
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: TextFormField(
              initialValue: _unitValue,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Unit (eg. In, cm)',
              ),
              validator: (String? value) => (value!.isNotEmpty) ? null : 'Please input a value',
              onSaved: (String? value) => _unitValue = value!.trim(),
            ),
          ),
        );

        if (_measures.isNotEmpty) {
          children.add(const FormSectionHeader(title: 'Group Items'));
          children.add(
            _GroupItems(
              measures: _measures,
              onPressed: (BaseMeasureEntity measure) => _onTapDeleteItem(vm, measure),
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
                onPressed: _measures.isEmpty ? null : () => _handleSubmit(vm),
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

  void _onTapDeleteItem(MeasuresViewModel vm, BaseMeasureEntity measure) async {
    final Registry registry = context.registry;
    final AppSnackBar snackBar = AppSnackBar.of(context);
    final bool? choice = await showChoiceDialog(context: context, message: 'Are you sure?');
    if (choice == null || choice == false) {
      return;
    }
    if (measure is DefaultMeasureEntity) {
      _removeFromLocal(measure.localKey);
      return;
    } else if (measure is MeasureEntity) {
      snackBar.loading();
      try {
        dispatchAction(const ToggleMeasuresLoading());
        await registry.get<Measures>().deleteOne(measure.reference);
        _removeFromLocal(measure.localKey);
        snackBar.hide();
      } catch (error, stackTrace) {
        AppLog.e(error, stackTrace);
        snackBar.error(error.toString());
      }
    }
  }

  void _handleAddItem() async {
    if (_isOkForm()) {
      final DefaultMeasureEntity? measure = await context.registry.get<MeasuresCoordinator>().toCreateMeasureItem(
            groupName: _groupName,
            unitValue: _unitValue,
          );

      if (measure == null) {
        return;
      }

      setState(() {
        _measures = <BaseMeasureEntity>[measure, ..._measures];
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
        await context.registry
            .get<Measures>()
            .create(_measures, vm.userId, groupName: _groupName, unitValue: _unitValue);
        snackBar.hide();
        navigator.pop();
      } catch (error, stackTrace) {
        AppLog.e(error, stackTrace);
        snackBar.error(error.toString());
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

  void _removeFromLocal(String localKey) {
    setState(() {
      _measures = _measures..removeWhere((_) => _.localKey == localKey);
    });
  }
}

class _GroupItems extends StatelessWidget {
  const _GroupItems({required this.measures, required this.onPressed});

  final List<BaseMeasureEntity> measures;
  final ValueSetter<BaseMeasureEntity> onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (BaseMeasureEntity measure in measures)
          ListTile(
            dense: true,
            title: Text(measure.name),
            subtitle: Text(measure.unit),
            trailing: IconButton(
              icon: Icon(measure is MeasureEntity ? Icons.delete : Icons.remove_circle_outline),
              iconSize: 20.0,
              onPressed: () => onPressed(measure),
            ),
          )
      ],
    );
  }
}

extension on BaseMeasureEntity {
  String get localKey => '$name-$group';
}
