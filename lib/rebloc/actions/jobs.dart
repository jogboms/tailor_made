import 'package:rebloc/rebloc.dart';

class JobsAsyncLoadingAction extends Action {
  const JobsAsyncLoadingAction();
}

class JobsAsyncSuccessAction extends JobsUpdateAction {
  const JobsAsyncSuccessAction(List<dynamic> jobs) : super(jobs);
}

class JobsAsyncFailureAction extends Action {
  const JobsAsyncFailureAction(this.error);

  final String error;
}

class JobsAsyncInitAction extends Action {
  const JobsAsyncInitAction();
}

class JobsUpdateAction extends Action {
  const JobsUpdateAction(this.jobs);

  final List<dynamic> jobs;
}
