import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/contacts/ui/contact_form.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsCreatePage extends StatefulWidget {
  ContactsCreatePage({
    Key key,
  }) : super(key: key);

  @override
  _ContactsCreatePageState createState() => new _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> with SnackBarProvider {
  final GlobalKey<ContactFormState> _formKey = new GlobalKey<ContactFormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  ContactModel contact;

  @override
  void initState() {
    super.initState();
    contact = new ContactModel();
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Create Contact",
      ),
      body: ContactForm(
        key: _formKey,
        contact: contact,
        onHandleSubmit: _handleSubmit,
        scaffoldKey: scaffoldKey,
      ),
    );
  }

  void _handleSubmit(ContactModel contact) async {
    showLoadingSnackBar();

    try {
      await Cloudstore.contacts.add(contact.toMap());
      closeLoadingSnackBar();
      showInSnackBar("Successfully Added");
      _handleSuccess();
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }

  void _handleSuccess() async {
    var choice = await confirmDialog(
      context: context,
      title: Text("Do you wish to add another?"),
    );
    if (choice == null) return;
    if (choice == false) {
      Navigator.pop(context, true);
    } else {
      contact = new ContactModel();
      _formKey.currentState.reset();
    }
  }
}
