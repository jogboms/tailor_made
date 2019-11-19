import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/providers/snack_bar_provider.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/measures/view_model.dart';
import 'package:tailor_made/screens/contacts/_partials/contact_form.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';

class ContactsCreatePage extends StatefulWidget {
  const ContactsCreatePage({Key key}) : super(key: key);

  @override
  _ContactsCreatePageState createState() => _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> with SnackBarProviderMixin {
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();
  ContactModel contact;
  final ContactPicker _contactPicker = ContactPicker();

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    contact = ContactModel((b) => b..userID = Dependencies.di().session.user.getId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MkAppBar(
        title: const Text("Create Contact"),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.contacts), onPressed: _handleSelectContact),
          ViewModelSubscriber<AppState, MeasuresViewModel>(
            converter: (store) => MeasuresViewModel(store),
            builder: (_, __, MeasuresViewModel vm) {
              return IconButton(
                icon: Icon(Icons.content_cut, color: contact.measurements.isEmpty ? kAccentColor : kTitleBaseColor),
                onPressed: () => _handleSelectMeasure(vm),
              );
            },
          ),
        ],
      ),
      body: ContactForm(key: _formKey, contact: contact, onHandleSubmit: _handleSubmit),
    );
  }

  void _handleSelectContact() async {
    final _selectedContact = await _contactPicker.selectContact();

    if (_selectedContact == null) {
      return;
    }

    _formKey.currentState.updateContact(
      contact.rebuild((b) => b
        ..fullname = _selectedContact.fullName
        ..phone = _selectedContact.phoneNumber?.number),
    );
  }

  void _handleSubmit(ContactModel _contact) async {
    if (contact.measurements.isEmpty) {
      showInSnackBar(MkStrings.leavingEmptyMeasures);
      return;
    }

    showLoadingSnackBar();

    try {
      contact = contact.rebuild(
        (b) => b
          ..fullname = _contact.fullname
          ..phone = _contact.phone
          ..imageUrl = _contact.imageUrl
          ..location = _contact.location,
      );

      Dependencies.di().contacts.update(contact, Dependencies.di().session.user.getId()).listen((snap) async {
        closeLoadingSnackBar();
        showInSnackBar("Successfully Added");

        Dependencies.di().contactsCoordinator.toContact(snap);
      });
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }

  void _handleSelectMeasure(MeasuresViewModel vm) async {
    final _contact = await Dependencies.di().contactsCoordinator.toContactMeasure(contact, vm.grouped);

    setState(() {
      contact = contact.rebuild((b) => b..measurements = _contact.measurements.toBuilder());
    });
  }
}
