import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import '../../measures/widgets/measure_create_items.dart';
import '../providers/contact_provider.dart';

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
    final L10n l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.measurementsPageTitle),
        leading: AppBackButton(
          onPop: widget.contact != null ? null : () => Navigator.pop<Map<String, double>>(context, _measurements),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () => context.router.toMeasures(_measurements),
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
                FormSectionHeader(title: l10n.measurementsPageTitle, trailing: l10n.measurementLabel),
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
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, _) => Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 50.0),
                    child: PrimaryButton(
                      onPressed: () => _handleSubmit(l10n, ref.read(contactProvider)),
                      child: Text(l10n.finishCaption),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit(L10n l10n, ContactProvider contactProvider) async {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }
    final AppSnackBar snackBar = AppSnackBar.of(context);
    if (!form.validate()) {
      _autovalidate = true;
      snackBar.info(l10n.fixFormErrors);
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
      await contactProvider.modifyMeasurements(reference: contact.reference, measurements: _measurements);
      snackBar.success(l10n.successfullyUpdatedMessage);
    } catch (e) {
      snackBar.error(e.toString());
    }
  }
}
