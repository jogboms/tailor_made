import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/ui/contact_form.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsEditPage extends StatefulWidget {
  final ContactModel contact;

  ContactsEditPage({
    Key key,
    this.contact,
  }) : super(key: key);

  @override
  _ContactsEditPageState createState() => new _ContactsEditPageState();
}

class _ContactsEditPageState extends State<ContactsEditPage> with SnackBarProvider {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  ContactModel contact;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Edit Contact",
      ),
      body: ContactForm(
        contact: contact,
        onHandleSubmit: _handleSubmit,
        scaffoldKey: scaffoldKey,
      ),
    );
  }

  void _handleSubmit(ContactModel contact) async {
    showLoadingSnackBar();

    try {
      await contact.toMap();
      closeLoadingSnackBar();
      showInSnackBar("Successfully Updated");
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}
