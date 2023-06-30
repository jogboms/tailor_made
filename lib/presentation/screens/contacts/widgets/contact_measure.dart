import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import '../../measures/widgets/measure_create_items.dart';

class ContactMeasure extends StatefulWidget {
  const ContactMeasure({super.key, required this.grouped, required this.contact});

  final Map<MeasureGroup, List<MeasureEntity>> grouped;
  final ContactEntity? contact;

  @override
  State<ContactMeasure> createState() => _ContactMeasureState();
}

class _ContactMeasureState extends State<ContactMeasure> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, double> _measurements = widget.contact?.measurements ?? <String, double>{};
  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Measurements'),
        leading: AppBackButton(
          onPop: widget.contact != null ? null : () => Navigator.pop<Map<String, double>>(context, _measurements),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () => context.registry.get<MeasuresCoordinator>().toMeasures(_measurements),
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
              children: <Widget>[
                const FormSectionHeader(title: 'Measurements', trailing: 'Inches (In)'),
                MeasureCreateItems(
                  grouped: widget.grouped,
                  measurements: _measurements,
                  onSaved: (Map<String, double>? value) {
                    if (value != null) {
                      _measurements = <String, double>{...value};
                    }
                  },
                  onChanged: (Map<String, double> value) {
                    _measurements = <String, double>{...value};
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 50.0),
                  child: PrimaryButton(onPressed: _handleSubmit, child: const Text('FINISH')),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }
    final AppSnackBar snackBar = AppSnackBar.of(context);
    if (!form.validate()) {
      _autovalidate = true;
      snackBar.info(AppStrings.fixErrors);
      return;
    }

    form.save();

    final ContactEntity? contact = widget.contact;
    if (contact == null) {
      Navigator.of(context).pop<Map<String, double>>(_measurements);
      return;
    }

    snackBar.loading();
    try {
      // TODO(Jogboms): move this out of here
      await context.registry.get<Contacts>().update(
            contact.userID,
            reference: contact.reference,
            measurements: _measurements,
          );
      snackBar.success('Successfully Updated');
    } catch (e) {
      snackBar.error(e.toString());
    }
  }
}
