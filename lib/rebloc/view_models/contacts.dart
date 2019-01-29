import 'package:equatable/equatable.dart';
import 'package:tailor_made/rebloc/states/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class ContactsViewModel extends Equatable {
  ContactsViewModel(AppState state)
      : model = state.contacts.contacts,
        isLoading = state.contacts.status == ContactsStatus.loading,
        hasError = state.contacts.status == ContactsStatus.failure,
        error = state.contacts.error,
        super(<AppState>[state]);

  final dynamic model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
