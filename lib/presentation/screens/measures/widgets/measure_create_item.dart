import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';

import 'measure_dialog.dart';

class MeasureCreateItem extends StatelessWidget {
  const MeasureCreateItem({super.key, required this.groupName, required this.unitValue});

  final MeasureGroup groupName;
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
        measure: DefaultMeasureEntity(
          name: '',
          group: groupName,
          unit: unitValue,
        ),
      ),
    );
  }
}
