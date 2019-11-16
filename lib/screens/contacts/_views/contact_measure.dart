import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/providers/snack_bar_provider.dart';
import 'package:tailor_made/screens/measures/_partials/measure_create_items.dart';
import 'package:tailor_made/widgets/_partials/form_section_header.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';
import 'package:tailor_made/widgets/_partials/mk_primary_button.dart';

class ContactMeasure extends StatefulWidget {
  const ContactMeasure({Key key, @required this.grouped, @required this.contact}) : super(key: key);

  final Map<String, List<MeasureModel>> grouped;
  final ContactModel contact;

  @override
  _ContactMeasureState createState() => _ContactMeasureState();
}

class _ContactMeasureState extends State<ContactMeasure> with SnackBarProviderMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  ContactModel contact;

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // TODO: look into this
    contact = widget.contact.rebuild((b) => b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MkAppBar(
        title: const Text("Measurements"),
        leading: MkBackButton(
          onPop: contact?.reference != null ? null : () => Navigator.pop<ContactModel>(context, contact),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye, color: kTitleBaseColor),
            onPressed: () => Dependencies.di().measuresCoordinator.toMeasures(contact.measurements.toMap()),
          )
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FormSectionHeader(title: "Measurements", trailing: "Inches (In)"),
                MeasureCreateItems(
                  grouped: widget.grouped,
                  measurements: contact.measurements.toMap(),
                ),
                Padding(
                  child: MkPrimaryButton(child: const Text("FINISH"), onPressed: _handleSubmit),
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 50.0),
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
    final FormState form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true;
      showInSnackBar(MkStrings.fixErrors);
      return;
    }

    form.save();
    showLoadingSnackBar();

    try {
      // TODO: find a way to remove this from here
      // During contact creation
      if (contact.reference != null) {
        await contact.reference.updateData(contact.toMap());
      }
      closeLoadingSnackBar();
      showInSnackBar("Successfully Updated");
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}
