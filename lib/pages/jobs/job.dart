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
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

var nairaFormat = new NumberFormat.currency(symbol: "");

class JobPage extends StatelessWidget {
  final JobModel job;

  JobPage({
    Key key,
    this.job,
  }) : super(key: key);

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

    return new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 24.0, bottom: 4.0, right: 24.0),
          child: Text(
            job.name,
            style: ralewayLight(20.0, Colors.white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
          child: Text(
            "NGN$_price",
            style: ralewayLight(35.0, Colors.white).copyWith(
              letterSpacing: 1.25,
            ),
            textAlign: TextAlign.center,
          ),
        ),
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
                      Text(
                        // TODO
                        "₦16,500",
                        style: ralewayMedium(18.0, Colors.green.shade600).copyWith(
                          letterSpacing: 1.25,
                        ),
                        textAlign: TextAlign.center,
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
                    Text(
                      // TODO
                      "₦3,500",
                      style: ralewayMedium(18.0, Colors.red.shade600).copyWith(
                        letterSpacing: 1.25,
                      ),
                      textAlign: TextAlign.center,
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
    final _date = job.createdAt;
    final contact = job.contact;

    var suffix = "th";
    var digit = _date.day % 10;
    if ((digit > 0 && digit < 4) && (_date.day < 11 || _date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    final date = new DateFormat("EEE, d'$suffix' MMMM").format(job.createdAt);

    return AvatarAppBar(
      tag: contact.createdAt.toString(),
      image: NetworkImage(contact.imageUrl),
      title: new GestureDetector(
        onTap: () => TMNavigate(context, Contact(contact: contact)),
        child: new Text(
          contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ralewayRegular(20.0, Colors.white),
        ),
      ),
      iconColor: Colors.white,
      subtitle: new Text(
        date,
        style: new TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
