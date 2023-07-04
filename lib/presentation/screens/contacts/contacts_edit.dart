import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';

import '../../widgets.dart';
import 'providers/contact_provider.dart';
import 'widgets/contact_form.dart';

class ContactsEditPage extends StatefulWidget {
  const ContactsEditPage({super.key, required this.contact});

  final ContactEntity contact;

  @override
  State<ContactsEditPage> createState() => _ContactsEditPageState();
}

class _ContactsEditPageState extends State<ContactsEditPage> {
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();
  late final CreateContactData _contact = CreateContactData(
    fullname: widget.contact.fullname,
    phone: widget.contact.phone,
    location: widget.contact.location,
    imageUrl: widget.contact.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Edit Contact'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.contacts), onPressed: _handleSelectContact),
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, _) => ContactForm(
          key: _formKey,
          contact: _contact,
          onHandleSubmit: (CreateContactData contact) => _handleSubmit(ref.read(contactProvider), contact),
        ),
      ),
    );
  }

  void _handleSelectContact() async {
    final Contact? selectedContact = await _contactPicker.selectContact();
    final String? fullName = selectedContact?.fullName;
    final String? phoneNumber = selectedContact?.phoneNumbers?.firstOrNull;
    if (selectedContact == null || fullName == null || phoneNumber == null) {
      return;
    }

    _formKey.currentState?.updateContact(
      _contact.copyWith(
        fullname: fullName,
        phone: phoneNumber,
      ),
    );
  }

  void _handleSubmit(ContactProvider contactProvider, CreateContactData contact) async {
    final AppSnackBar snackBar = AppSnackBar.of(context)..loading();

    try {
      await contactProvider.update(reference: widget.contact.reference, contact: contact);
      snackBar.success('Successfully Updated');
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      snackBar.error(error.toString());
    }
  }
}
