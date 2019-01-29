import 'package:rebloc/rebloc.dart';

class ContactsInitAction extends Action {
  const ContactsInitAction();
}

class ContactsUpdateAction extends Action {
  const ContactsUpdateAction(this.contacts);

  final dynamic contacts;
}
