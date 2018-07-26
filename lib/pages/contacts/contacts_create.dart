import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/pages/contacts/ui/contact_form.dart';
import 'package:tailor_made/pages/contacts/ui/contact_measure.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/measures.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsCreatePage extends StatefulWidget {
  const ContactsCreatePage({
    Key key,
  }) : super(key: key);

  @override
  _ContactsCreatePageState createState() => new _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage>
    with SnackBarProvider {
  final GlobalKey<ContactFormState> _formKey =
      new GlobalKey<ContactFormState>();
  ContactModel contact;
  final ContactPicker _contactPicker = new ContactPicker();

  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    contact = new ContactModel();
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return StoreConnector<ReduxState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (BuildContext context, vm) {
        return new Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.scaffoldColor,
          appBar: appBar(
            context,
            title: "Create Contact",
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

  void _handleValidate() async {
    showInSnackBar('Please fix the errors in red before submitting.');
  }

  void _handleSubmit(ContactModel _contact) async {
    if (contact.measurements.isEmpty) {
      showInSnackBar("Leaving Measurements empty? Click on Scissors button.");
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
          TMNavigate.slideIn<String>(
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
      TMNavigate.fadeIn(ContactMeasure(
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
