import 'package:flutter/material.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/constants.dart';
import 'package:tailor_made/presentation/providers.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../measures/widgets/measure_create_items.dart';

class ContactMeasure extends StatefulWidget {
  const ContactMeasure({super.key, required this.grouped, required this.contact});

  final Map<String, List<MeasureModel>>? grouped;
  final ContactModel? contact;

  @override
  State<ContactMeasure> createState() => _ContactMeasureState();
}

class _ContactMeasureState extends State<ContactMeasure> with SnackBarProviderMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  late ContactModel contact;

  @override
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // TODO(Jogboms): look into this
    contact = widget.contact!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: const Text('Measurements'),
        leading: AppBackButton(
          onPop: contact.reference != null ? null : () => Navigator.pop<ContactModel>(context, contact),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove_red_eye, color: kTitleBaseColor),
            onPressed: () => Dependencies.di().measuresCoordinator.toMeasures(contact.measurements),
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
                  measurements: contact.measurements,
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
    if (!form.validate()) {
      _autovalidate = true;
      showInSnackBar(AppStrings.fixErrors);
      return;
    }

    form.save();
    showLoadingSnackBar();

    try {
      // TODO(Jogboms): find a way to remove this from here
      // During contact creation
      await contact.reference?.updateData(contact.toJson());
      closeLoadingSnackBar();
      showInSnackBar('Successfully Updated');
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}
