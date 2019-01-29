import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/redux/view_models/measures.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_snackbar_provider.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/screens/contacts/contact.dart';
import 'package:tailor_made/widgets/screens/contacts/ui/contact_form.dart';
import 'package:tailor_made/widgets/screens/contacts/ui/contact_measure.dart';

class ContactsCreatePage extends StatefulWidget {
  const ContactsCreatePage({
    Key key,
  }) : super(key: key);

  @override
  _ContactsCreatePageState createState() => _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage>
    with MkSnackBarProvider {
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();
  ContactModel contact;
  final ContactPicker _contactPicker = ContactPicker();

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    contact = ContactModel();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (BuildContext context, vm) {
        return Scaffold(
          key: scaffoldKey,
          appBar: MkAppBar(
            title: Text("Create Contact"),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.contacts,
                  color: kTitleBaseColor,
                ),
                onPressed: _handleSelectContact,
              ),
              IconButton(
                icon: Icon(
                  Icons.content_cut,
                  color: contact.measurements.isEmpty
                      ? kAccentColor
                      : kTitleBaseColor,
                ),
                onPressed: () => _handleSelectMeasure(vm),
              ),
            ],
          ),
          body: ContactForm(
            key: _formKey,
            contact: contact,
            onHandleSubmit: _handleSubmit,
            onHandleValidate: _handleValidate,
            onHandleUpload: _handleUpload,
          ),
        );
      },
    );
  }

  void _handleSelectContact() async {
    final _selectedContact = await _contactPicker.selectContact();

    if (_selectedContact == null) {
      return;
    }

    _formKey.currentState.updateContact(contact.copyWith(
      fullname: _selectedContact.fullName,
      phone: _selectedContact.phoneNumber?.number,
    ));
  }

  void _handleValidate() {
    showInSnackBar(MkStrings.fixErrors);
  }

  void _handleUpload(String message) {
    showInSnackBar(message);
  }

  void _handleSubmit(ContactModel _contact) async {
    if (contact.measurements.isEmpty) {
      showInSnackBar(MkStrings.leavingEmptyMeasures);
      return;
    }

    showLoadingSnackBar();

    try {
      contact = contact.copyWith(
        fullname: _contact.fullname,
        phone: _contact.phone,
        imageUrl: _contact.imageUrl,
        location: _contact.location,
      );

      final ref = CloudDb.contactsRef.document(contact.id);
      await ref.setData(contact.toMap());

      ref.snapshots().listen((snap) async {
        closeLoadingSnackBar();
        showInSnackBar("Successfully Added");

        Navigator.pushReplacement<dynamic, dynamic>(
          context,
          MkNavigate.slideIn<String>(
            ContactPage(contact: ContactModel.fromDoc(snap)),
          ),
        );
      });
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }

  void _handleSelectMeasure(MeasuresViewModel vm) async {
    final _contact = await Navigator.push<ContactModel>(
      context,
      MkNavigate.fadeIn(ContactMeasure(
        contact: contact,
        grouped: vm.grouped,
      )),
    );

    setState(() {
      contact = contact.copyWith(
        measurements: _contact.measurements,
      );
    });
  }
}
