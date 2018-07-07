import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/pages/jobs/ui/gallery_grids.dart';
import 'package:tailor_made/pages/jobs/ui/measure_lists.dart';
import 'package:tailor_made/pages/jobs/ui/payment_grids.dart';
import 'package:tailor_made/ui/avatar_app_bar.dart';
import 'package:tailor_made/utils/tm_format_date.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class JobPage extends StatefulWidget {
  final JobModel job;

  JobPage({
    Key key,
    this.job,
  }) : super(key: key);

  @override
  JobPageState createState() {
    return new JobPageState();
  }
}

class JobPageState extends State<JobPage> {
  final nairaFormat = new NumberFormat.compactSimpleCurrency(name: "NGN", decimalDigits: 1);
  JobModel job;

  @override
  void initState() {
    job = widget.job;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(background: buildHeader()),
              pinned: true,
              titleSpacing: 0.0,
              elevation: 1.0,
              automaticallyImplyLeading: false,
              centerTitle: false,
              backgroundColor: Colors.grey.shade300,
              title: buildAvatarAppBar(context),
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
                MeasureLists(measurements: job.measurements),
                const SizedBox(height: 4.0),
                GalleryGrids(job: job),
                const SizedBox(height: 4.0),
                PaymentGrids(job: job),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    final _price = nairaFormat.format(job.price ?? 0);
    final textColor = Colors.grey.shade800;

    return new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            job.name,
            style: ralewayLight(18.0, textColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          _price,
          style: ralewayLight(24.0, textColor).copyWith(
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24.0),
        new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: TMBorderSide()),
          ),
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: new Container(
                  decoration: BoxDecoration(
                    border: Border(right: TMBorderSide()),
                  ),
                  child: new Column(
                    children: <Widget>[
                      Text(
                        "PAID",
                        style: ralewayLight(8.0),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.arrow_drop_up, color: Colors.green.shade600, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(
                            // TODO
                            "NGN16.5k",
                            style: ralewayLight(18.0, Colors.black87).copyWith(
                              letterSpacing: 1.25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: new Column(
                  children: <Widget>[
                    Text(
                      "UNPAID",
                      style: ralewayLight(8.0),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.arrow_drop_down, color: Colors.red.shade600, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          // TODO
                          "NGN3.5k",
                          style: ralewayLight(18.0, Colors.black87).copyWith(
                            letterSpacing: 1.25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AvatarAppBar buildAvatarAppBar(BuildContext context) {
    final contact = job.contact;
    // final textColor = Colors.white;
    final textColor = Colors.grey.shade800;

    final date = formatDate(job.createdAt);

    return AvatarAppBar(
      tag: contact.createdAt.toString(),
      imageUrl: contact.imageUrl,
      title: new GestureDetector(
        onTap: () => TMNavigate(context, Contact(contact: contact)),
        child: new Text(
          contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ralewayRegular(16.0, textColor),
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
            job.isComplete ? Icons.check_box : Icons.check_box_outline_blank,
            color: textBaseColor.shade900,
          ),
          onPressed: () {
            try {
              job.reference.updateData({
                "isComplete": !job.isComplete,
              }).then((_) {
                setState(() => job.isComplete = !job.isComplete);
              });
            } catch (e) {}
          },
        )
      ],
    );
  }
}
