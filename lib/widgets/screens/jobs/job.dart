import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/jobs.dart';
import 'package:tailor_made/utils/mk_choice_dialog.dart';
import 'package:tailor_made/utils/mk_dates.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_snackbar_provider.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/avatar_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/screens/contacts/contact.dart';
import 'package:tailor_made/widgets/screens/jobs/_partials/gallery_grids.dart';
import 'package:tailor_made/widgets/screens/jobs/_partials/payment_grids.dart';
import 'package:tailor_made/widgets/screens/measures/measures.dart';

class JobPage extends StatefulWidget {
  const JobPage({
    Key key,
    @required this.job,
  }) : super(key: key);

  final JobModel job;

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> with MkSnackBarProvider {
  JobModel job;

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    job = widget.job;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    return ViewModelSubscriber<AppState, JobsViewModel>(
      converter: (store) => JobsViewModel(store)..jobID = widget.job.id,
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        JobsViewModel vm,
      ) {
        // in the case of newly created jobs
        job = vm.selected ?? widget.job;
        if (vm.isLoading) {
          return Center(
            child: const MkLoadingSpinner(),
          );
        }
        return Scaffold(
          key: scaffoldKey,
          body: NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 250.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _Header(job: job),
                  ),
                  pinned: true,
                  titleSpacing: 0.0,
                  brightness: Brightness.light,
                  elevation: 1.0,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  backgroundColor: Colors.white,
                  // backgroundColor: Colors.grey.shade300,
                  title: _AvatarAppBar(job: job, contact: vm.selectedContact),
                ),
              ];
            },
            body: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            "DUE DATE",
                            style: theme.small.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        MkClearButton(
                          child: Text(
                            "EXTEND DATE",
                            style: theme.smallBtn,
                          ),
                          onPressed: job.isComplete ? null : _onSaveDate,
                        ),
                        const SizedBox(width: 16.0),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        MkDates(
                          job.dueAt,
                          day: "EEEE",
                          month: "MMMM",
                          year: "yyyy",
                        ).format,
                        style: theme.body3Medium,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    GalleryGrids(job: job),
                    const SizedBox(height: 4.0),
                    PaymentGrids(job: job),
                    const SizedBox(height: 32.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        job.notes,
                        style: theme.body3Light,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 48.0),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            icon: Icon(
              job.isComplete ? Icons.undo : Icons.check,
            ),
            backgroundColor: job.isComplete ? Colors.white : kAccentColor,
            foregroundColor: job.isComplete ? kAccentColor : Colors.white,
            label: Text(job.isComplete ? "Undo Completed" : "Mark Completed"),
            onPressed: onTapComplete,
          ),
        );
      },
    );
  }

  void onTapComplete() async {
    final choice = await mkChoiceDialog(
      context: context,
      message: "Are you sure?",
    );
    if (choice == null || choice == false) {
      return;
    }

    showLoadingSnackBar();

    try {
      await job.reference.updateData(<String, bool>{
        "isComplete": !job.isComplete,
      });
      closeLoadingSnackBar();
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }

  void _onSaveDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: job.dueAt,
      firstDate: job.dueAt.isAfter(DateTime.now()) ? DateTime.now() : job.dueAt,
      lastDate: DateTime(2101),
    );
    if (picked == null || picked == job.dueAt) {
      return;
    }
    final choice = await mkChoiceDialog(
      context: context,
      message: "Are you sure?",
    );
    if (choice == null || choice == false) {
      return;
    }

    showLoadingSnackBar();

    try {
      await job.reference.updateData(<String, String>{
        "dueAt": picked.toString(),
      });
      closeLoadingSnackBar();
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key key,
    @required this.job,
  }) : super(key: key);

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.grey.shade800;
    final theme = MkTheme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            job.name,
            style: theme.title.copyWith(color: textColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          MkMoney(job.price).format,
          style: theme.display2Semi.copyWith(
            color: textColor,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24.0),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: const Border(
              top: const MkBorderSide(),
              bottom: const MkBorderSide(),
            ),
          ),
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PaidBox(job: job),
              _UnpaidBox(job: job),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarAppBar extends StatelessWidget {
  const _AvatarAppBar({
    Key key,
    @required this.job,
    @required this.contact,
  }) : super(key: key);

  final JobModel job;
  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    // final textColor = Colors.white;
    final textColor = Colors.grey.shade800;

    final date = MkDates(job.createdAt).format;
    final theme = MkTheme.of(context);

    return AvatarAppBar(
      tag: contact.createdAt.toString(),
      imageUrl: contact.imageUrl,
      title: GestureDetector(
        onTap: () {
          MkNavigate(context, ContactPage(contact: contact));
        },
        child: Text(
          contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.title,
        ),
      ),
      iconColor: textColor,
      subtitle: Text(
        date,
        style: theme.small.copyWith(
          color: textColor,
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.content_cut,
          ),
          onPressed: () {
            MkNavigate(
              context,
              MeasuresPage(measurements: job.measurements),
              fullscreenDialog: true,
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.check,
            color: job.isComplete ? kPrimaryColor : kTextBaseColor,
          ),
          onPressed: null,
        ),
      ],
    );
  }
}

class _PaidBox extends StatelessWidget {
  const _PaidBox({
    Key key,
    @required this.job,
  }) : super(key: key);

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final theme = MkTheme.of(context);

    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          border: const Border(right: const MkBorderSide()),
        ),
        child: Column(
          children: <Widget>[
            Text(
              "PAID",
              style: theme.xxsmall,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.arrow_drop_up,
                  color: Colors.green.shade600,
                  size: 16.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  MkMoney(job.completedPayment).format,
                  style: theme.title.copyWith(
                    letterSpacing: 1.25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UnpaidBox extends StatelessWidget {
  const _UnpaidBox({
    Key key,
    @required this.job,
  }) : super(key: key);

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final theme = MkTheme.of(context);
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            "UNPAID",
            style: theme.xxsmall,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.arrow_drop_down,
                color: Colors.red.shade600,
                size: 16.0,
              ),
              const SizedBox(width: 4.0),
              Text(
                MkMoney(job.pendingPayment).format,
                style: theme.title.copyWith(
                  letterSpacing: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
