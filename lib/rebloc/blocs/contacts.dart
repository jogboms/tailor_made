import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/actions/contacts.dart';
import 'package:tailor_made/rebloc/states/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class ContactsBloc extends SimpleBloc<AppState> {
  @override
  AppState reducer(AppState state, Action action) {
    final _contacts = state.contacts;

    if (action is ContactsUpdateAction) {
      return state.copyWith(
        contacts: _contacts.copyWith(
          contacts: action.contacts,
          status: ContactsStatus.success,
        ),
      );
    }

    return state;
  }
}
