import 'package:equatable/equatable.dart';
import 'package:tailor_made/rebloc/states/jobs.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class JobsViewModel extends Equatable {
  JobsViewModel(AppState state)
      : model = state.jobs.jobs,
        isLoading = state.jobs.status == JobsStatus.loading,
        hasError = state.jobs.status == JobsStatus.failure,
        error = state.jobs.error,
        super(<AppState>[state]);

  final dynamic model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
