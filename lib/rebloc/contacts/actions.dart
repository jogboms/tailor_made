import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/contact.dart';

enum SortType { recent, jobs, completed, pending, name, reset }

class InitContactsAction extends Action {
  const InitContactsAction();
}

class SortContacts extends Action {
  const SortContacts({@required this.payload});

  final SortType payload;
}

class SearchContactAction extends Action {
  const SearchContactAction({@required this.payload});

  final String payload;
}

class SearchSuccessContactAction extends Action {
  const SearchSuccessContactAction({@required this.payload});

  final List<ContactModel> payload;
}

class CancelSearchContactAction extends Action {
  const CancelSearchContactAction();
}

class StartSearchContactAction extends Action {
  const StartSearchContactAction();
}

class OnDataContactAction extends Action {
  const OnDataContactAction({@required this.payload});

  final List<ContactModel> payload;
}
