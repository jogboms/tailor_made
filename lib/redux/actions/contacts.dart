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
