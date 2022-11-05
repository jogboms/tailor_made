import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils/route_transitions.dart';

import '../screens/contacts/contact.dart';
import '../screens/contacts/contacts.dart';
import '../screens/contacts/contacts_create.dart';
import '../screens/contacts/contacts_edit.dart';
import '../screens/contacts/widgets/contact_measure.dart';
import '../screens/jobs/widgets/contact_lists.dart';
import 'coordinator_base.dart';

@immutable
class ContactsCoordinator extends CoordinatorBase {
  const ContactsCoordinator(super.navigatorKey);

  void toContact(ContactModel? contact, {bool replace = false}) {
    replace
        ? navigator?.pushReplacement<dynamic, dynamic>(RouteTransitions.slideIn(ContactPage(contact: contact)))
        : navigator?.push<void>(RouteTransitions.slideIn(ContactPage(contact: contact)));
  }

  void toContactEdit(String userId, ContactModel? contact) {
    navigator?.push<void>(RouteTransitions.slideIn(ContactsEditPage(userId: userId, contact: contact)));
  }

  Future<ContactModel?>? toContactMeasure(ContactModel? contact, Map<String, List<MeasureModel>>? grouped) {
    return navigator?.push<ContactModel>(RouteTransitions.slideIn(ContactMeasure(contact: contact, grouped: grouped)));
  }

  void toContacts() {
    navigator?.push<void>(RouteTransitions.slideIn(const ContactsPage()));
  }

  Future<ContactModel?>? toContactsList(List<ContactModel>? contacts) {
    return navigator?.push<ContactModel>(RouteTransitions.fadeIn(ContactLists(contacts: contacts)));
  }

  void toCreateContact(String userId) {
    navigator?.push<void>(RouteTransitions.slideIn(ContactsCreatePage(userId: userId)));
  }
}
