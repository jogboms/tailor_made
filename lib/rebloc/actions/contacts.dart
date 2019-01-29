import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/contact.dart';

enum SortType {
  recent,
  jobs,
  completed,
  pending,
  name,
  reset,
}

class SortContacts extends Action {
  const SortContacts({
    @required this.payload,
  });

  final SortType payload;
}

class SearchContactEvent extends Action {
  const SearchContactEvent({
    @required this.payload,
  });

  final String payload;
}

class SearchSuccessContactEvent extends Action {
  const SearchSuccessContactEvent({
    @required this.payload,
  });

  final List<ContactModel> payload;
}

class CancelSearchContactEvent extends Action {
  const CancelSearchContactEvent();
}

class StartSearchContactEvent extends Action {
  const StartSearchContactEvent();
}

class OnDataContactEvent extends Action {
  const OnDataContactEvent({
    @required this.payload,
  });

  final List<ContactModel> payload;
}
