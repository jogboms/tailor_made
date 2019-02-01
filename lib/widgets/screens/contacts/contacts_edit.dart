import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/utils/mk_snackbar_provider.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/screens/contacts/_partials/contact_form.dart';

class ContactsEditPage extends StatefulWidget {
  const ContactsEditPage({
    Key key,
    this.contact,
  }) : super(key: key);

  final ContactModel contact;

  @override
  _ContactsEditPageState createState() => _ContactsEditPageState();
}

class _ContactsEditPageState extends State<ContactsEditPage>
    with MkSnackBarProvider {
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
          IconButton(
            icon: const Icon(Icons.contacts),
            onPressed: _handleSelectContact,
          ),
        ],
      ),
      body: ContactForm(
        key: _formKey,
        contact: widget.contact,
        onHandleSubmit: _handleSubmit,
      ),
    );
  }

  void _handleSelectContact() async {
    final _selectedContact = await _contactPicker.selectContact();
    _formKey.currentState.updateContact(
      widget.contact.copyWith(
        fullname: _selectedContact.fullName,
        phone: _selectedContact.phoneNumber.number,
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
