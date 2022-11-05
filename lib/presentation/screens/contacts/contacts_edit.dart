import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/providers.dart';
import 'package:tailor_made/presentation/widgets.dart';

import 'widgets/contact_form.dart';

class ContactsEditPage extends StatefulWidget {
  const ContactsEditPage({super.key, this.contact, required this.userId});

  final ContactModel? contact;
  final String userId;

  @override
  State<ContactsEditPage> createState() => _ContactsEditPageState();
}

class _ContactsEditPageState extends State<ContactsEditPage> with SnackBarProviderMixin {
  // TODO(Jogboms): Handle
  // final ContactPicker _contactPicker = ContactPicker();
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();

  @override
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: const Text('Edit Contact'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.contacts), onPressed: _handleSelectContact),
        ],
      ),
      body: ContactForm(key: _formKey, contact: widget.contact, onHandleSubmit: _handleSubmit, userId: widget.userId),
    );
  }

  void _handleSelectContact() async {
    // TODO(Jogboms): Handle
    // final selectedContact = await _contactPicker.selectContact();
    // _formKey.currentState.updateContact(
    //   widget.contact.rebuild(
    //     (b) => b
    //       ..fullname = selectedContact.fullName
    //       ..phone = selectedContact.phoneNumber.number,
    //   ),
    // );
  }

  void _handleSubmit(ContactModel contact) async {
    showLoadingSnackBar();

    try {
      await contact.reference?.setData(contact.toJson());
      closeLoadingSnackBar();
      showInSnackBar('Successfully Updated');
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}
