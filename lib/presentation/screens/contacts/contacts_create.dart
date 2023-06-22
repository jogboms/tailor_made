import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:uuid/uuid.dart';

import 'widgets/contact_form.dart';

class ContactsCreatePage extends StatefulWidget {
  const ContactsCreatePage({super.key, required this.userId});

  final String userId;

  @override
  State<ContactsCreatePage> createState() => _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> {
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();
  late final String id = const Uuid().v4();
  late CreateContactData _contact = const CreateContactData(
    fullname: '',
    phone: '',
    location: '',
    imageUrl: null,
  );

  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Create Contact'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.contacts),
            color: context.theme.primaryColor,
            onPressed: _handleSelectContact,
          ),
          ViewModelSubscriber<AppState, MeasuresViewModel>(
            converter: MeasuresViewModel.new,
            builder: (_, __, MeasuresViewModel vm) {
              return IconButton(
                icon: Icon(Icons.content_cut, color: _contact.measurements.isEmpty ? kAccentColor : kTitleBaseColor),
                onPressed: () => _handleSelectMeasure(vm),
              );
            },
          ),
        ],
      ),
      body: ContactForm(
        key: _formKey,
        contact: _contact,
        onHandleSubmit: _handleSubmit,
        userId: widget.userId,
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

  void _handleSubmit(CreateContactData contact) async {
    final AppSnackBar snackBar = AppSnackBar.of(context);
    if (contact.measurements.isEmpty) {
      snackBar.info(AppStrings.leavingEmptyMeasures);
      return;
    }

    final Registry registry = context.registry;
    final Contacts contacts = registry.get();
    final ContactsCoordinator contactsCoordinator = registry.get();
    snackBar.loading();

    try {
      contact = contact.copyWith(
        fullname: contact.fullname,
        phone: contact.phone,
        imageUrl: contact.imageUrl,
        location: contact.location,
      );

      // TODO(Jogboms): move this out of here
      final ContactEntity snap = await contacts.create(widget.userId, contact);
      snackBar.success('Successfully Added');

      contactsCoordinator.toContact(snap, replace: true);
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      snackBar.error(error.toString());
    }
  }

  void _handleSelectMeasure(MeasuresViewModel vm) async {
    final Map<String, double>? result = await context.registry.get<ContactsCoordinator>().toContactMeasure(
          contact: null,
          grouped: vm.grouped,
        );
    if (result == null) {
      return;
    }

    setState(() {
      _contact = _contact.copyWith(measurements: result);
    });
  }
}
