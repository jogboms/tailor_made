import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:uuid/uuid.dart';

import 'measure_dialog.dart';

class MeasureCreateItem extends StatelessWidget {
  const MeasureCreateItem({super.key, required this.groupName, required this.unitValue});

  final String? groupName;
  final String? unitValue;

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
          id: const Uuid().v4(),
          name: '',
          group: groupName ?? '',
          unit: unitValue ?? '',
          createdAt: DateTime.now(),
        ),
      ),
    );
  }
}
