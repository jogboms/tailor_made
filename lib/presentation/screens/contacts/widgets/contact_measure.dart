import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import '../../measures/widgets/measure_create_items.dart';

class ContactMeasure extends StatefulWidget {
  const ContactMeasure({super.key, required this.grouped, required this.contact});

  final Map<String, List<MeasureModel>> grouped;
  final ContactModel contact;

  @override
  State<ContactMeasure> createState() => _ContactMeasureState();
}

class _ContactMeasureState extends State<ContactMeasure> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  late ContactModel _contact = widget.contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Measurements'),
        leading: AppBackButton(
          onPop: _contact.reference != null ? null : () => Navigator.pop<ContactModel>(context, _contact),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove_red_eye, color: kTitleBaseColor),
            onPressed: () => context.registry.get<MeasuresCoordinator>().toMeasures(_contact.measurements),
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
                  measurements: _contact.measurements,
                  onSaved: (Map<String, double>? value) {
                    if (value != null) {
                      _contact = _contact.copyWith(measurements: value);
                    }
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

    final Reference? reference = _contact.reference;
    if (reference == null) {
      Navigator.of(context).pop<ContactModel>(_contact);
      return;
    }

    snackBar.loading();
    try {
      // TODO(Jogboms): find a way to remove this from here
      // During contact creation
      await reference.updateData(_contact.toJson());
      snackBar.success('Successfully Updated');
    } catch (e) {
      snackBar.error(e.toString());
    }
  }
}
