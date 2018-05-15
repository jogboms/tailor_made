import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/ui/avatar_app_bar.dart';
import 'package:tailor_made/ui/back_button.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:flutter/cupertino.dart';
import 'ui/payment_grids.dart';
import 'ui/gallery_grids.dart';

class Measure {
  final String name;
  final int measurement;
  final String unit;

  Measure({this.name, this.measurement, this.unit});
}

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => new _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    ContactModel contact = ContactModel(title: "Joy", pending: 0, image: "https://placeimg.com/640/640/arch");

    final List<Measure> items = <Measure>[
      new Measure(name: "Arm Hole", measurement: 29, unit: "In"),
      new Measure(name: "Shoulder", measurement: 19, unit: "In"),
      new Measure(name: "Burst", measurement: 21, unit: "In"),
      new Measure(name: "Waist", measurement: 34, unit: "In"),
      new Measure(name: "Burst Point", measurement: 12, unit: "In"),
      new Measure(name: "Thigh", measurement: 9, unit: "In"),
      new Measure(name: "Hip", measurement: 19, unit: "In"),
      new Measure(name: "Full Length", measurement: 11, unit: "In"),
      new Measure(name: "Knee Length", measurement: 4, unit: "In"),
    ];

    Widget header = new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 24.0, bottom: 4.0, right: 24.0),
          child: Text(
            "Indian Blouse with Chifon Top and Mexican Trouser",
            style: ralewayLight(20.0, Colors.white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
          child: Text(
            "₦20,000",
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

    Widget list = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((Measure item) => new MeasureItem(item)).toList(),
    );

    Widget appBar = AvatarAppBar(
      tag: contact.image,
      image: NetworkImage(contact.image),
      title: new GestureDetector(
        onTap: () => TMNavigate(context, Contact(contact: contact)),
        child: new Text(
          contact.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ralewayRegular(18.0, Colors.white),
        ),
      ),
      iconColor: Colors.white,
      subtitle: new Text.rich(
        new TextSpan(
          children: [
            new TextSpan(
              text: "Sunday",
              style: new TextStyle(fontWeight: FontWeight.w500),
            ),
            new TextSpan(text: ", 12"),
            new TextSpan(
              text: "nd",
              style: new TextStyle(fontSize: 12.0),
            ),
            new TextSpan(text: " March"),
          ],
        ),
        style: new TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
    );

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(background: header),
              pinned: true,
              titleSpacing: 0.0,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              centerTitle: false,
              backgroundColor: accentColorAlt,
              title: appBar,
            ),
          ];
        },
        body: new SafeArea(
          top: false,
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: list,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GalleryGrids(),
                ),
                // const Divider(height: 1.0),
                new Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: PaymentGrids(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MeasureItem extends StatelessWidget {
  final Measure item;
  MeasureItem(this.item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.grey[100].withOpacity(.5),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Text(item.name, style: ralewayMedium(14.0, titleBaseColor))),
          Text("${item.measurement} ", style: ralewayRegular(16.0, titleBaseColor)),
          Text(item.unit, style: ralewayLight(12.0, titleBaseColor)),
        ],
      ),
    );
  }
}
