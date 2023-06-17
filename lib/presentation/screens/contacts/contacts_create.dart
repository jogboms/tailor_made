import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/contact_form.dart';

class ContactsCreatePage extends StatefulWidget {
  const ContactsCreatePage({super.key, required this.userId});

  final String userId;

  @override
  State<ContactsCreatePage> createState() => _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> {
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();
  late ContactModel contact;

  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  @override
  void initState() {
    super.initState();
    contact = ContactModel.fromDefaults(userID: widget.userId);
  }

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
                icon: Icon(Icons.content_cut, color: contact.measurements.isEmpty ? kAccentColor : kTitleBaseColor),
                onPressed: () => _handleSelectMeasure(vm),
              );
            },
          ),
        ],
      ),
      body: ContactForm(
        key: _formKey,
        contact: contact,
        onHandleSubmit: _handleSubmit,
        userId: widget.userId,
      ),
    );
  }

  void _handleSelectContact() async {
    final Contact? selectedContact = await _contactPicker.selectContact();
    final String? fullName = selectedContact?.fullName;

    if (selectedContact == null || fullName == null) {
      return;
    }

    _formKey.currentState?.updateContact(
      contact.copyWith(
        fullname: fullName,
        phone: selectedContact.phoneNumbers?.first,
      ),
    );
  }

  void _handleSubmit(ContactModel contact) async {
    final AppSnackBar snackBar = AppSnackBar.of(context);
    if (contact.measurements.isEmpty) {
      snackBar.info(AppStrings.leavingEmptyMeasures);
      return;
    }

    final Contacts contacts = context.registry.get();
    final ContactsCoordinator contactsCoordinator = context.registry.get();
    snackBar.loading();

    try {
      contact = contact.copyWith(
        fullname: contact.fullname,
        phone: contact.phone,
        imageUrl: contact.imageUrl,
        location: contact.location,
      );

      // TODO(Jogboms): move this out of here
      contacts.update(contact, widget.userId).listen((ContactModel snap) async {
        snackBar.success('Successfully Added');

        contactsCoordinator.toContact(snap);
      });
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      snackBar.error(error.toString());
    }
  }

  void _handleSelectMeasure(MeasuresViewModel vm) async {
    final ContactModel? result = await context.registry.get<ContactsCoordinator>().toContactMeasure(
          contact,
          vm.grouped ?? <String, List<MeasureModel>>{},
        );
    if (result == null) {
      return;
    }

    setState(() {
      contact = contact.copyWith(measurements: result.measurements);
    });
  }
}
