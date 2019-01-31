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
import 'package:tailor_made/widgets/_partials/avatar_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/screens/contacts/contact.dart';
import 'package:tailor_made/widgets/screens/jobs/ui/gallery_grids.dart';
import 'package:tailor_made/widgets/screens/jobs/ui/payment_grids.dart';
import 'package:tailor_made/widgets/screens/measures/measures.dart';

class JobPage extends StatefulWidget {
  const JobPage({
    Key key,
    @required this.job,
  }) : super(key: key);

  final JobModel job;

  @override
  JobPageState createState() {
    return JobPageState();
  }
}

class JobPageState extends State<JobPage> with MkSnackBarProvider {
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
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 250.0,
                  flexibleSpace: FlexibleSpaceBar(background: buildHeader()),
                  pinned: true,
                  titleSpacing: 0.0,
                  brightness: Brightness.light,
                  elevation: 1.0,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  backgroundColor: Colors.white,
                  // backgroundColor: Colors.grey.shade300,
                  title: buildAvatarAppBar(context, vm.selectedContact),
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
                            style: mkFontRegular(12.0, Colors.black87),
                          ),
                        ),
                        CupertinoButton(
                          child: Text(
                            "EXTEND DATE",
                            style: mkFontRegular(11.0, Colors.black),
                          ),
                          onPressed: job.isComplete ? null : _onSaveDate,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        MkDates(job.dueAt,
                                day: "EEEE", month: "MMMM", year: "yyyy")
                            .format,
                        style: mkFontRegular(16.0, Colors.black),
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
                        style: mkFontLight(14.0, Colors.black87),
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

  Widget buildHeader() {
    final textColor = Colors.grey.shade800;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            job.name,
            style: mkFontRegular(18.0, textColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          MkMoney(job.price).format,
          style: mkFontRegular(24.0, textColor).copyWith(
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: MkBorderSide(), bottom: MkBorderSide()),
          ),
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaidBox(),
              _buildUnpaidBox(),
            ],
          ),
        ),
      ],
    );
  }

  Expanded _buildUnpaidBox() {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            "UNPAID",
            style: mkFontRegular(8.0),
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
                style: mkFontRegular(18.0, Colors.black87).copyWith(
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

  Expanded _buildPaidBox() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: MkBorderSide()),
        ),
        child: Column(
          children: <Widget>[
            Text(
              "PAID",
              style: mkFontRegular(8.0),
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
                  style: mkFontRegular(18.0, Colors.black87).copyWith(
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

  Widget buildAvatarAppBar(BuildContext context, ContactModel contact) {
    // final textColor = Colors.white;
    final textColor = Colors.grey.shade800;

    final date = MkDates(job.createdAt).format;

    return AvatarAppBar(
      tag: contact.createdAt.toString(),
      imageUrl: contact.imageUrl,
      title: GestureDetector(
        onTap: () => MkNavigate(context, ContactPage(contact: contact)),
        child: Text(
          contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: mkFontBold(18.0, kTitleBaseColor),
        ),
      ),
      iconColor: textColor,
      subtitle: Text(
        date,
        style: TextStyle(
          color: textColor,
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.content_cut,
          ),
          onPressed: () => MkNavigate(
                context,
                MeasuresPage(measurements: job.measurements),
                fullscreenDialog: true,
              ),
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

  void onTapComplete() async {
    final choice = await mkChoiceDialog(
      context: context,
      title: "",
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
      title: "",
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
