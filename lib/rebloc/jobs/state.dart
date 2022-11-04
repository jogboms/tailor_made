import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/jobs/sort_type.dart';

part 'state.g.dart';

abstract class JobsState implements Built<JobsState, JobsStateBuilder> {
  factory JobsState([void Function(JobsStateBuilder b) updates]) = _$JobsState;

  factory JobsState.initialState() => _$JobsState(
        (JobsStateBuilder b) => b
          ..jobs = null
          ..status = StateStatus.loading
          ..hasSortFn = true
          ..sortFn = SortType.active
          ..searchResults = null
          ..isSearching = false
          ..error = null,
      );

  JobsState._();

  BuiltList<JobModel>? get jobs;

  bool get hasSortFn;

  SortType get sortFn;

  BuiltList<JobModel>? get searchResults;

  bool get isSearching;

  StateStatus get status;

  String? get error;

  static Serializer<JobsState> get serializer => _$jobsStateSerializer;
}
