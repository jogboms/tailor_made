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
  final ContactModelBuilder contact;

  @override
  _ContactMeasureState createState() => _ContactMeasureState();
}

class _ContactMeasureState extends State<ContactMeasure> with SnackBarProviderMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
//  ContactModelBuilder contact;

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // TODO: look into this
//    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MkAppBar(
        title: const Text("Measurements"),
        leading: MkBackButton(
          // TODO: investigate this
          onPop: widget.contact?.build()?.reference != null
              ? null
              : () => Navigator.pop<ContactModel>(context, widget.contact.build()),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye, color: kTitleBaseColor),
            onPressed: () => Dependencies.di().measuresCoordinator.toMeasures(widget.contact.measurements.build()),
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
                  measurements: widget.contact.measurements,
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
      final _contact = widget.contact.build();
      // During contact creation
      if (_contact.reference != null) {
        await _contact.reference.updateData(_contact.toMap());
      }
      closeLoadingSnackBar();
      showInSnackBar("Successfully Updated");
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}
