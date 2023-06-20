part of 'bloc.dart';

@freezed
class JobsAction with _$JobsAction, AppAction {
  const factory JobsAction.init(String userId) = InitJobsAction;
  const factory JobsAction.toggle(JobEntity payload) = ToggleCompleteJob;
  const factory JobsAction.sort(JobsSortType payload) = SortJobs;
  const factory JobsAction.search(String payload) = SearchJobAction;
  const factory JobsAction.searchSuccess(List<JobEntity> payload) = SearchSuccessJobAction;
  const factory JobsAction.searchCancel() = CancelSearchJobAction;
  const factory JobsAction.searchStart() = StartSearchJobAction;
}
