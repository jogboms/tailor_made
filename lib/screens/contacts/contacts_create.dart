// import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/providers/snack_bar_provider.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/measures/view_model.dart';
import 'package:tailor_made/screens/contacts/_partials/contact_form.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';

class ContactsCreatePage extends StatefulWidget {
  const ContactsCreatePage({super.key, required this.userId});

  final String userId;

  @override
  State<ContactsCreatePage> createState() => _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> with SnackBarProviderMixin {
  final GlobalKey<ContactFormState> _formKey = GlobalKey<ContactFormState>();
  ContactModel? contact;
  // TODO(Jogboms): Handle
  // final ContactPicker _contactPicker = ContactPicker();

  @override
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    contact = ContactModel((ContactModelBuilder b) => b..userID = widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MkAppBar(
        title: const Text('Create Contact'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.contacts), onPressed: _handleSelectContact),
          ViewModelSubscriber<AppState, MeasuresViewModel>(
            converter: MeasuresViewModel.new,
            builder: (_, __, MeasuresViewModel vm) {
              return IconButton(
                icon: Icon(Icons.content_cut, color: contact!.measurements!.isEmpty ? kAccentColor : kTitleBaseColor),
                onPressed: () => _handleSelectMeasure(vm),
              );
            },
          ),
        ],
      ),
      body: ContactForm(key: _formKey, contact: contact, onHandleSubmit: _handleSubmit, userId: widget.userId),
    );
  }

  void _handleSelectContact() async {
    // TODO(Jogboms): Handle
    // final selectedContact = await _contactPicker.selectContact();
    //
    // if (selectedContact == null) {
    //   return;
    // }
    //
    // _formKey.currentState.updateContact(
    //   contact.rebuild(
    //     (b) => b
    //       ..fullname = selectedContact.fullName
    //       ..phone = selectedContact.phoneNumber?.number,
    //   ),
    // );
  }

  void _handleSubmit(ContactModel contact) async {
    if (contact.measurements!.isEmpty) {
      showInSnackBar(MkStrings.leavingEmptyMeasures);
      return;
    }

    showLoadingSnackBar();

    try {
      contact = contact.rebuild(
        (ContactModelBuilder b) => b
          ..fullname = contact.fullname
          ..phone = contact.phone
          ..imageUrl = contact.imageUrl
          ..location = contact.location,
      );

      // TODO(Jogboms): move this out of here
      Dependencies.di().contacts.update(contact, widget.userId).listen((ContactModel snap) async {
        closeLoadingSnackBar();
        showInSnackBar('Successfully Added');

        Dependencies.di().contactsCoordinator.toContact(snap);
      });
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }

  void _handleSelectMeasure(MeasuresViewModel vm) async {
    // TODO(Jogboms): Handle
    // final contact = await Dependencies.di().contactsCoordinator.toContactMeasure(contact, vm.grouped);
    //
    // setState(() {
    //   contact = contact.rebuild((b) => b..measurements = contact.measurements.toBuilder());
    // });
  }
}
