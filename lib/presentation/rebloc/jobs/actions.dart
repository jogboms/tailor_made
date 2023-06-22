part of 'bloc.dart';

@freezed
class JobsAction with _$JobsAction, AppAction {
  const factory JobsAction.init(String userId) = _InitJobsAction;
  const factory JobsAction.toggle(JobEntity payload) = _ToggleCompleteJob;
  const factory JobsAction.sort(JobsSortType payload) = _SortJobs;
  const factory JobsAction.search(String payload) = _SearchJobAction;
  const factory JobsAction.searchSuccess(List<JobEntity> payload) = _SearchSuccessJobAction;
  const factory JobsAction.searchCancel() = _CancelSearchJobAction;
  const factory JobsAction.searchStart() = _StartSearchJobAction;
}
