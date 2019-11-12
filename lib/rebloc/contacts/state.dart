import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/contacts/sort_type.dart';

part 'state.g.dart';

abstract class ContactsState implements Built<ContactsState, ContactsStateBuilder> {
  factory ContactsState([ContactsState updates(ContactsStateBuilder b)]) = _$ContactsState;

  factory ContactsState.initialState() => _$ContactsState(
        (ContactsStateBuilder b) => b
          ..contacts = null
          ..status = StateStatus.loading
          ..hasSortFn = true
          ..sortFn = SortType.names
          ..searchResults = null
          ..isSearching = false
          ..message = ''
          ..error = null,
      );

  ContactsState._();

  @nullable
  BuiltList<ContactModel> get contacts;

  StateStatus get status;

  String get message;

  bool get hasSortFn;

  SortType get sortFn;

  @nullable
  BuiltList<ContactModel> get searchResults;

  bool get isSearching;

  @nullable
  String get error;

  static Serializer<ContactsState> get serializer => _$contactsStateSerializer;
}
