import 'package:flutter/material.dart';
import 'package:tailor_made/coordinator/coordinator_base.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/screens/contacts/_views/contact_measure.dart';
import 'package:tailor_made/screens/contacts/contact.dart';
import 'package:tailor_made/screens/contacts/contacts.dart';
import 'package:tailor_made/screens/contacts/contacts_create.dart';
import 'package:tailor_made/screens/contacts/contacts_edit.dart';
import 'package:tailor_made/screens/jobs/_partials/contact_lists.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

@immutable
class ContactsCoordinator extends CoordinatorBase {
  const ContactsCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toContact(ContactModel contact, {bool replace = false}) {
    replace
        ? navigator?.pushReplacement<dynamic, dynamic>(MkNavigate.slideIn(ContactPage(contact: contact)))
        : navigator?.push<void>(MkNavigate.slideIn(ContactPage(contact: contact)));
  }

  void toContactEdit(ContactModel contact) {
    navigator?.push<void>(MkNavigate.slideIn(ContactsEditPage(contact: contact)));
  }

  Future<ContactModel> toContactMeasure(ContactModel contact, Map<String, List<MeasureModel>> grouped) {
    return navigator?.push<ContactModel>(MkNavigate.slideIn(ContactMeasure(contact: contact, grouped: grouped)));
  }

  void toContacts() {
    navigator?.push<void>(MkNavigate.slideIn(const ContactsPage()));
  }

  Future<ContactModel> toContactsList(List<ContactModel> contacts) {
    return navigator?.push<ContactModel>(MkNavigate.fadeIn(ContactLists(contacts: contacts)));
  }

  void toCreateContact() {
    navigator?.push<void>(MkNavigate.slideIn(const ContactsCreatePage()));
  }
}
