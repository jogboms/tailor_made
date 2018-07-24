import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/utils/tm_validators.dart';

class MeasureDialog extends StatefulWidget {
  final MeasureModel measure;

  const MeasureDialog({
    Key key,
    @required this.measure,
  }) : super(key: key);

  @override
  MeasureDialogState createState() => new MeasureDialogState();
}

class MeasureDialogState extends State<MeasureDialog> {
  final FocusNode _unitNode = new FocusNode();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  MeasureModel measure;

  @override
  void initState() {
    super.initState();
    measure = widget.measure;
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
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Theme(
            data: ThemeData(
              hintColor: kHintColor,
              primaryColor: kPrimaryColor,
            ),
            child: new Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 32.0),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      child: Icon(
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
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_unitNode),
                    onSaved: (value) => widget.measure.name = value,
                    decoration: InputDecoration(
                      labelText: "Name (eg. Length)",
                    ),
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                    validator: validateAlpha(),
                  ),
                  SizedBox(height: 4.0),
                  TextFormField(
                    focusNode: _unitNode,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: "Unit (eg. In, cm)",
                    ),
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                    validator: validateAlpha(),
                    onFieldSubmitted: (value) => _onSaved(),
                    onSaved: (value) => widget.measure.unit = value,
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
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
      Navigator.pop<MeasureModel>(context, measure);
    }
  }
}
