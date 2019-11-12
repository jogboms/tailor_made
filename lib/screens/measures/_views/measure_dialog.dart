import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/utils/mk_validators.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';

class MeasureDialog extends StatefulWidget {
  const MeasureDialog({
    Key key,
    @required this.measure,
  }) : super(key: key);

  final MeasureModel measure;

  @override
  _MeasureDialogState createState() => _MeasureDialogState();
}

class _MeasureDialogState extends State<MeasureDialog> {
  final FocusNode _unitNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  MeasureModelBuilder measure;

  @override
  void initState() {
    super.initState();
    measure = widget.measure.toBuilder();
  }

  @override
  void dispose() {
    _unitNode.dispose();
    super.dispose();
  }

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
            autovalidate: _autovalidate,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 32.0),
                Center(
                  child: CircleAvatar(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    child: const Icon(
                      Icons.content_cut,
                      size: 50.0,
                    ),
                    radius: 36.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_unitNode),
                  onSaved: (value) => measure.name = value.trim(),
                  decoration: const InputDecoration(
                    labelText: "Name (eg. Length)",
                  ),
                  validator: MkValidate.tryAlpha(),
                ),
                const SizedBox(height: 4.0),
                TextFormField(
                  initialValue: widget.measure.unit,
                  focusNode: _unitNode,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: "Unit (eg. In, cm)",
                  ),
                  validator: MkValidate.tryAlpha(),
                  onFieldSubmitted: (value) => _onSaved(),
                  onSaved: (value) => measure.unit = value.trim(),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MkClearButton(
                      onPressed: () => Navigator.pop(context),
                      color: Colors.grey,
                      child: const Text("CANCEL"),
                    ),
                    const SizedBox(width: 16.0),
                    MkClearButton(
                      onPressed: _onSaved,
                      child: const Text("DONE"),
                    ),
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
    final FormState form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      // widget.onHandleValidate();
    } else {
      form.save();
      Navigator.pop<MeasureModel>(context, measure.build());
    }
  }
}
