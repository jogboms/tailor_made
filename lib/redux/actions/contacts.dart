import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/redux/actions/main.dart';

class InitContact extends ActionType {
  final String type = ReduxActions.initContacts;
  final List<ContactModel> payload;

  InitContact({this.payload});
}

class AddContact extends ActionType {
  final String type = ReduxActions.addContact;
  final ContactModel payload;

  AddContact({this.payload});
}

class RemoveContact extends ActionType {
  final String type = ReduxActions.removeContact;
  final ContactModel payload;

  RemoveContact({this.payload});
}

class OnDataEvent extends ActionType {
  final String type = ReduxActions.onDataEventContact;
  final List<ContactModel> payload;

  OnDataEvent({this.payload});
}
