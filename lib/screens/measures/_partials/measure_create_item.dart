import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/screens/measures/_views/measure_dialog.dart';

class MeasureCreateItem extends StatelessWidget {
  const MeasureCreateItem({Key key, @required this.groupName, @required this.unitValue}) : super(key: key);

  final String groupName;
  final String unitValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          (b) => b
            ..name = ""
            ..group = groupName
            ..unit = unitValue,
        ),
      ),
    );
  }
}
