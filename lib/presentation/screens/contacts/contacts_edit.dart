import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';

import '../../widgets.dart';
import 'widgets/contact_form.dart';

class ContactsEditPage extends StatefulWidget {
  const ContactsEditPage({super.key, required this.contact, required this.userId});

  final ContactModel contact;
  final String userId;

  @override
  State<ContactsEditPage> createState() => _ContactsEditPageState();
}

class _ContactsEditPageState extends State<ContactsEditPage> {
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Edit Contact'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.contacts), onPressed: _handleSelectContact),
        ],
      ),
      body: ContactForm(
        key: _formKey,
        contact: widget.contact,
        onHandleSubmit: _handleSubmit,
        userId: widget.userId,
      ),
    );
  }

  void _handleSelectContact() async {
    final ContactModel contact = widget.contact;
    final Contact? selectedContact = await _contactPicker.selectContact();
    final String? fullName = selectedContact?.fullName;
    if (selectedContact == null || fullName == null) {
      return;
    }
    _formKey.currentState?.updateContact(
      contact.copyWith(
        fullname: fullName,
        phone: selectedContact.phoneNumbers?.firstOrNull,
      ),
    );
  }

  void _handleSubmit(ContactModel contact) async {
    final AppSnackBar snackBar = AppSnackBar.of(context)..loading();

    try {
      await contact.reference?.setData(contact.toJson());

      snackBar.success('Successfully Updated');
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      snackBar.error(error.toString());
    }
  }
}
