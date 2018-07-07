import 'package:redux/redux.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/redux/states/jobs.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class JobsViewModel extends ViewModel {
  JobsViewModel(Store<ReduxState> store) : super(store);

  List<JobModel> get jobs {
    return this.store.state.jobs.jobs;
  }

  bool get isLoading => this.store.state.jobs.status == JobsStatus.loading;

  bool get isSuccess => this.store.state.jobs.status == JobsStatus.success;

  bool get isFailure => this.store.state.jobs.status == JobsStatus.failure;
}
