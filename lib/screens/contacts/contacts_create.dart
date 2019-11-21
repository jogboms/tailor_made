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
  const ContactsCreatePage({Key key, @required this.userId}) : super(key: key);

  final String userId;

  @override
  _ContactsCreatePageState createState() => _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> with SnackBarProviderMixin {
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();
  ContactModelBuilder contact;
  final ContactPicker _contactPicker = ContactPicker();

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    contact = ContactModel((b) => b..userID = widget.userId).toBuilder();
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
      body: ContactForm(key: _formKey, contact: contact, onHandleSubmit: _handleSubmit, userId: widget.userId),
    );
  }

  void _handleSelectContact() async {
    final _selectedContact = await _contactPicker.selectContact();

    if (_selectedContact == null) {
      return;
    }

    // TODO: investigate this
    final _contact = contact
      ..update((b) => b
        ..fullname = _selectedContact.fullName
        ..phone = _selectedContact.phoneNumber?.number);
    _formKey.currentState.updateContact(_contact.build());
  }

  void _handleSubmit(ContactModel _contact) async {
    if (contact.measurements.isEmpty) {
      showInSnackBar(MkStrings.leavingEmptyMeasures);
      return;
    }

    showLoadingSnackBar();

    try {
      contact = contact
        ..update(
          (b) => b
            ..fullname = _contact.fullname
            ..phone = _contact.phone
            ..imageUrl = _contact.imageUrl
            ..location = _contact.location,
        );

      // TODO: move this out of here
      Dependencies.di().contacts.update(contact.build(), widget.userId).listen((snap) async {
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
      contact = contact..update((b) => b..measurements = _contact.measurements.toBuilder());
    });
  }
}
