import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/ui/contact_form.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_strings.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsEditPage extends StatefulWidget {
  final ContactModel contact;

  const ContactsEditPage({
    Key key,
    this.contact,
  }) : super(key: key);

  @override
  _ContactsEditPageState createState() => new _ContactsEditPageState();
}

class _ContactsEditPageState extends State<ContactsEditPage>
    with SnackBarProvider {
  final ContactPicker _contactPicker = new ContactPicker();
  final GlobalKey<ContactFormState> _formKey =
      new GlobalKey<ContactFormState>();

  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Edit Contact",
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.contacts,
              color: kTitleBaseColor,
            ),
            onPressed: _handleSelectContact,
          ),
        ],
      ),
      body: ContactForm(
        key: _formKey,
        contact: widget.contact,
        onHandleSubmit: _handleSubmit,
        onHandleValidate: _handleValidate,
        onHandleUpload: _handleUpload,
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

  void _handleValidate() {
    showInSnackBar(TMStrings.fixErrors);
  }

  void _handleUpload(String message) {
    showInSnackBar(message);
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
