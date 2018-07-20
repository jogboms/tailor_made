import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/main.dart';

enum SortType {
  recent,
  jobs,
  pending,
  name,
  reset,
}

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

class SortContacts extends ActionType<SortType> {
  @override
  final String type = ReduxActions.sortContacts;

  SortContacts({SortType payload}) : super(payload: payload);
}

class SearchContactEvent extends ActionType<String> {
  @override
  final String type = ReduxActions.onSearchContactEvent;

  SearchContactEvent({String payload}) : super(payload: payload);
}

class SearchSuccessContactEvent extends ActionType<List<ContactModel>> {
  @override
  final String type = ReduxActions.onSearchSuccessContactEvent;

  SearchSuccessContactEvent({List<ContactModel> payload})
      : super(payload: payload);
}

class CancelSearchContactEvent extends ActionType<String> {
  @override
  final String type = ReduxActions.onCancelSearchContactEvent;

  CancelSearchContactEvent({String payload}) : super(payload: payload);
}

class StartSearchContactEvent extends ActionType<String> {
  @override
  final String type = ReduxActions.onStartSearchContactEvent;

  StartSearchContactEvent({String payload}) : super(payload: payload);
}

class OnDataEvent extends ActionType<List<ContactModel>> {
  @override
  final String type = ReduxActions.onDataEventContact;

  OnDataEvent({List<ContactModel> payload}) : super(payload: payload);
}
