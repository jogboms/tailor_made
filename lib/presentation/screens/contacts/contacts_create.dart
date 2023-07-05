import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import '../../routing.dart';
import 'providers/contact_provider.dart';
import 'widgets/contact_form.dart';

class ContactsCreatePage extends StatefulWidget {
  const ContactsCreatePage({super.key});

  @override
  State<ContactsCreatePage> createState() => _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> {
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();
  late CreateContactData _contact = const CreateContactData(
    fullname: '',
    phone: '',
    location: '',
    imageUrl: null,
  );

  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final L10n l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.createContactPageTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.contacts),
            color: context.theme.primaryColor,
            onPressed: _handleSelectContact,
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) => ref.watch(measurementsProvider).when(
                  skipLoadingOnReload: true,
                  data: (MeasurementsState state) => IconButton(
                    icon: Icon(
                      Icons.content_cut,
                      color: _contact.measurements.isEmpty ? colorScheme.secondary : null,
                    ),
                    onPressed: () => _handleSelectMeasure(state.grouped),
                  ),
                  error: ErrorView.new,
                  loading: () => child!,
                ),
            child: const Center(child: LoadingSpinner()),
          ),
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, _) => ContactForm(
          key: _formKey,
          contact: _contact,
          onHandleSubmit: (CreateContactData contact) => _handleSubmit(l10n, ref.read(contactProvider), contact),
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

  void _handleSubmit(L10n l10n, ContactProvider contactProvider, CreateContactData contact) async {
    final AppSnackBar snackBar = AppSnackBar.of(context);
    if (contact.measurements.isEmpty) {
      snackBar.info(l10n.emptyMeasuresFormError);
      return;
    }

    snackBar.loading();

    final AppRouter router = context.router;
    try {
      contact = contact.copyWith(
        fullname: contact.fullname,
        phone: contact.phone,
        imageUrl: contact.imageUrl,
        location: contact.location,
      );
      final ContactEntity result = await contactProvider.create(contact: contact);
      snackBar.success(l10n.successfullyAddedMessage);
      router.toContact(result.id, replace: true);
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      snackBar.error(error.toString());
    }
  }

  void _handleSelectMeasure(Map<MeasureGroup, List<MeasureEntity>> grouped) async {
    final Map<String, double>? result = await context.router.toContactMeasure(
      contact: null,
      grouped: grouped,
    );
    if (result == null) {
      return;
    }

    setState(() {
      _contact = _contact.copyWith(measurements: result);
    });
  }
}
