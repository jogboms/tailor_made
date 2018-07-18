import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/main.dart';

class InitContact extends ActionType<List<ContactModel>> {
  @override
  final String type = ReduxActions.initContacts;

  InitContact({List<ContactModel> payload}) : super(payload: payload);
}

class AddContact extends ActionType<ContactModel> {
  @override
  final String type = ReduxActions.addContact;

  AddContact({ContactModel payload}) : super(payload: payload);
}

class RemoveContact extends ActionType<ContactModel> {
  @override
  final String type = ReduxActions.removeContact;

  RemoveContact({ContactModel payload}) : super(payload: payload);
}

class OnDataEvent extends ActionType<List<ContactModel>> {
  @override
  final String type = ReduxActions.onDataEventContact;

  OnDataEvent({List<ContactModel> payload}) : super(payload: payload);
}
