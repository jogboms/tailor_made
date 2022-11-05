import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'state.freezed.dart';

@freezed
class JobsState with _$JobsState {
  const factory JobsState({
    required List<JobModel>? jobs,
    required bool hasSortFn,
    required JobsSortType sortFn,
    required List<JobModel>? searchResults,
    required bool isSearching,
    required StateStatus status,
    required String? error,
  }) = _JobsState;
}
