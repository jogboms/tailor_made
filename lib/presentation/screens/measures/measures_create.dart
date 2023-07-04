import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import 'providers/measurement_provider.dart';

class MeasuresCreate extends StatefulWidget {
  const MeasuresCreate({super.key, this.measures, this.groupName, this.unitValue});

  final List<BaseMeasureEntity>? measures;
  final MeasureGroup? groupName;
  final String? unitValue;

  @override
  State<MeasuresCreate> createState() => _MeasuresCreateState();
}

class _MeasuresCreateState extends State<MeasuresCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  late MeasureGroup _groupName = widget.groupName ?? MeasureGroup.empty;
  late String _unitValue = widget.unitValue ?? '';
  late List<BaseMeasureEntity> _measures = widget.measures ?? <BaseMeasureEntity>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: const Text(''),
        leading: const AppCloseButton(),
        actions: <Widget>[
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) => AppClearButton(
              onPressed: _measures.isEmpty ? null : () => _handleSubmit(ref.read(measurementProvider)),
              child: const Text('SAVE'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const FormSectionHeader(title: 'Group Name'),
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
                  const FormSectionHeader(title: 'Group Unit'),
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
                  if (_measures.isNotEmpty) ...<Widget>[
                    const FormSectionHeader(title: 'Group Items'),
                    _GroupItems(
                      measures: _measures,
                      onPressed: (BaseMeasureEntity value) => _onTapDeleteItem(ref.read(measurementProvider), value),
                    ),
                    const SizedBox(height: 84.0)
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Add Item'),
        onPressed: _handleAddItem,
      ),
    );
  }

  void _onTapDeleteItem(MeasurementProvider measurementProvider, BaseMeasureEntity measure) async {
    final AppSnackBar snackBar = AppSnackBar.of(context);
    final bool? choice = await showChoiceDialog(context: context, message: 'Are you sure?');
    if (choice == null || choice == false) {
      return;
    }

    switch (measure) {
      case DefaultMeasureEntity():
        _removeFromLocal(measure.localKey);
      case MeasureEntity():
        snackBar.loading();
        try {
          await measurementProvider.deleteItem(reference: measure.reference);
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
      final DefaultMeasureEntity? measure = await context.router.toCreateMeasureItem(
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

  void _handleSubmit(MeasurementProvider measurementProvider) async {
    if (_isOkForm()) {
      final AppSnackBar snackBar = AppSnackBar.of(context)..loading();

      try {
        final NavigatorState navigator = Navigator.of(context);
        await measurementProvider.create(
          measures: _measures,
          group: _groupName,
          unit: _unitValue,
        );
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
