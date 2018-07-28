import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/pages/jobs/ui/gallery_grids.dart';
import 'package:tailor_made/pages/jobs/ui/payment_grids.dart';
import 'package:tailor_made/pages/measures/measures.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/jobs.dart';
import 'package:tailor_made/ui/avatar_app_bar.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_format_date.dart';
import 'package:tailor_made/utils/tm_format_naira.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class JobPage extends StatefulWidget {
  final JobModel job;

  const JobPage({
    Key key,
    @required this.job,
  }) : super(key: key);

  @override
  JobPageState createState() {
    return new JobPageState();
  }
}

class JobPageState extends State<JobPage> with SnackBarProvider {
  JobModel job;

  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    job = widget.job;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return StoreConnector<ReduxState, JobsViewModel>(
      converter: (store) => JobsViewModel(store)..jobID = widget.job.id,
      builder: (BuildContext context, vm) {
        // in the case of newly created jobs
        job = vm.selected ?? widget.job;
        if (vm.isLoading) {
          return Center(
            child: loadingSpinner(),
          );
        }
        return new Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.scaffoldColor,
          body: new NestedScrollView(
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
            body: new SafeArea(
              top: false,
              child: new SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            "DUE DATE",
                            style: ralewayRegular(12.0, Colors.black87),
                          ),
                        ),
                        CupertinoButton(
                          child: Text(
                            "EXTEND DATE",
                            style: ralewayRegular(11.0, Colors.black),
                          ),
                          onPressed: job.isComplete ? null : _onSaveDate,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        formatDate(job.dueAt,
                            day: "EEEE", month: "MMMM", year: "yyyy"),
                        style: ralewayRegular(16.0, Colors.black),
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
                        style: ralewayLight(14.0, Colors.black87),
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
            icon: new Icon(
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

    return new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            job.name,
            style: ralewayRegular(18.0, textColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          formatNaira(job.price),
          style: ralewayRegular(24.0, textColor).copyWith(
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24.0),
        new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: TMBorderSide(), bottom: TMBorderSide()),
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
      child: new Column(
        children: <Widget>[
          Text(
            "UNPAID",
            style: ralewayRegular(8.0),
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
                formatNaira(job.pendingPayment),
                style: ralewayRegular(18.0, Colors.black87).copyWith(
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
      child: new Container(
        decoration: BoxDecoration(
          border: Border(right: TMBorderSide()),
        ),
        child: new Column(
          children: <Widget>[
            Text(
              "PAID",
              style: ralewayRegular(8.0),
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
                  formatNaira(job.completedPayment),
                  style: ralewayRegular(18.0, Colors.black87).copyWith(
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

    final date = formatDate(job.createdAt);

    return AvatarAppBar(
      tag: contact.createdAt.toString(),
      imageUrl: contact.imageUrl,
      title: new GestureDetector(
        onTap: () => TMNavigate(context, ContactPage(contact: contact)),
        child: new Text(
          contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ralewayBold(18.0, kTitleBaseColor),
        ),
      ),
      iconColor: textColor,
      subtitle: new Text(
        date,
        style: new TextStyle(
          color: textColor,
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: new Icon(
            Icons.content_cut,
          ),
          onPressed: () => TMNavigate(
                context,
                MeasuresPage(measurements: job.measurements),
                fullscreenDialog: true,
              ),
        ),
        IconButton(
          icon: new Icon(
            Icons.check,
            color: job.isComplete ? kPrimaryColor : kTextBaseColor.shade400,
          ),
          onPressed: null,
        ),
      ],
    );
  }

  void onTapComplete() async {
    final choice = await confirmDialog(
      context: context,
      content: Text("Are you sure?"),
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
      firstDate: job.dueAt.isAfter(new DateTime.now())
          ? new DateTime.now()
          : job.dueAt,
      lastDate: new DateTime(2101),
    );
    if (picked == null || picked == job.dueAt) {
      return;
    }
    final choice = await confirmDialog(
      context: context,
      content: Text("Are you sure?"),
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
