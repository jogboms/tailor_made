import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/pages/contacts/ui/contact_form.dart';
import 'package:tailor_made/pages/contacts/ui/contact_measure.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
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
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Create Contact",
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.content_cut,
              color: kTitleBaseColor,
            ),
            onPressed: () => TMNavigate(
                  context,
                  ContactMeasure(contact: contact),
                ),
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
  }

  void _handleValidate() async {
    showInSnackBar('Please fix the errors in red before submitting.');
  }

  void _handleSubmit(ContactModel contact) async {
    showLoadingSnackBar();

    try {
      final ref = CloudDb.contactsRef.document(contact.id);
      await ref.setData(contact.toMap());

      ref.snapshots().listen((snap) async {
        closeLoadingSnackBar();
        showInSnackBar("Successfully Added");

        final choice = await confirmDialog(
          context: context,
          title: Text("Do you wish to add another?"),
        );
        if (choice == null) {
          return;
        }
        if (choice == false) {
          Navigator.pushReplacement<dynamic, dynamic>(
            context,
            TMNavigate.slideIn<dynamic>(
                ContactPage(contact: ContactModel.fromDoc(snap))),
          );
        } else {
          contact = new ContactModel();
          _formKey.currentState.reset();
        }
      });
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}
