import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/main.dart';

enum SortType {
  recent,
  jobs,
  completed,
  pending,
  name,
  reset,
}

class SortContacts extends ActionType<SortType> {
  SortContacts({
    SortType payload,
  }) : super(payload: payload);
}

class SearchContactEvent extends ActionType<String> {
  SearchContactEvent({
    String payload,
  }) : super(payload: payload);
}

class SearchSuccessContactEvent extends ActionType<List<ContactModel>> {
  SearchSuccessContactEvent({
    List<ContactModel> payload,
  }) : super(payload: payload);
}

class CancelSearchContactEvent extends ActionType<void> {}

class StartSearchContactEvent extends ActionType<void> {}

class OnDataContactEvent extends ActionType<List<ContactModel>> {
  OnDataContactEvent({
    List<ContactModel> payload,
  }) : super(payload: payload);
}
