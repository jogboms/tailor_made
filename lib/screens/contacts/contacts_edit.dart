import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/providers/snack_bar_provider.dart';
import 'package:tailor_made/screens/contacts/_partials/contact_form.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';

class ContactsEditPage extends StatefulWidget {
  const ContactsEditPage({Key key, this.contact}) : super(key: key);

  final ContactModel contact;

  @override
  _ContactsEditPageState createState() => _ContactsEditPageState();
}

class _ContactsEditPageState extends State<ContactsEditPage> with SnackBarProviderMixin {
  final ContactPicker _contactPicker = ContactPicker();
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MkAppBar(
        title: const Text("Edit Contact"),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.contacts), onPressed: _handleSelectContact),
        ],
      ),
      body: ContactForm(key: _formKey, contact: widget.contact, onHandleSubmit: _handleSubmit),
    );
  }

  void _handleSelectContact() async {
    final _selectedContact = await _contactPicker.selectContact();
    _formKey.currentState.updateContact(
      widget.contact.rebuild(
        (b) => b
          ..fullname = _selectedContact.fullName
          ..phone = _selectedContact.phoneNumber.number,
      ),
    );
  }

  void _handleSubmit(ContactModel contact) async {
    showLoadingSnackBar();

    try {
      await contact.reference.setData(contact.toMap());
      closeLoadingSnackBar();
      showInSnackBar("Successfully Updated");
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}
