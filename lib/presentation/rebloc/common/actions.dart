import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'actions.freezed.dart';

@freezed
class CommonActionData<T> with _$CommonActionData<T>, AppAction {
  const factory CommonActionData.data(T payload) = OnDataAction<T>;
}
