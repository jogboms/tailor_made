import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

class MeasureDialog extends StatefulWidget {
  const MeasureDialog({super.key, required this.measure});

  final MeasureModel measure;

  @override
  State<MeasureDialog> createState() => _MeasureDialogState();
}

class _MeasureDialogState extends State<MeasureDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  late MeasureModel _measure = widget.measure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 32.0),
                const Center(
                  child: CircleAvatar(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    radius: 36.0,
                    child: Icon(Icons.content_cut, size: 50.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onSaved: (String? value) => _measure = _measure.copyWith(name: value!.trim()),
                  decoration: const InputDecoration(labelText: 'Name (eg. Length)'),
                  validator: InputValidator.tryAlpha(),
                ),
                const SizedBox(height: 4.0),
                TextFormField(
                  initialValue: widget.measure.unit,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(labelText: 'Unit (eg. In, cm)'),
                  validator: InputValidator.tryAlpha(),
                  onFieldSubmitted: (String value) => _onSaved(),
                  onSaved: (String? value) => _measure = _measure.copyWith(unit: value!.trim()),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    AppClearButton(
                      onPressed: () => Navigator.pop(context),
                      color: Colors.grey,
                      child: const Text('CANCEL'),
                    ),
                    const SizedBox(width: 16.0),
                    AppClearButton(onPressed: _onSaved, child: const Text('DONE')),
                    const SizedBox(width: 16.0),
                  ],
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSaved() {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true;
      // widget.onHandleValidate();
    } else {
      form.save();
      Navigator.pop<MeasureModel>(context, _measure);
    }
  }
}
