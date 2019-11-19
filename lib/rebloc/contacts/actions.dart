import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/contacts/sort_type.dart';

class InitContactsAction extends Action {
  const InitContactsAction(this.userId);

  final String userId;
}

class SortContacts extends Action {
  const SortContacts(this.payload);

  final SortType payload;
}

class SearchContactAction extends Action {
  const SearchContactAction(this.payload);

  final String payload;
}

class SearchSuccessContactAction extends Action {
  const SearchSuccessContactAction(this.payload);

  final List<ContactModel> payload;
}

class CancelSearchContactAction extends Action {
  const CancelSearchContactAction();
}

class StartSearchContactAction extends Action {
  const StartSearchContactAction();
}
