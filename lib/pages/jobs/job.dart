import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_theme.dart';
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
    final _theme = Theme.of(context);

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

    Widget header = Container(
      // color: Colors.grey[200],
      child: new SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Text("Indian Blouse", style: _theme.textTheme.headline),
            ),
            // const Divider(height: 1.0),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((Measure item) {
                  return new Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    margin: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Text(item.name, style: ralewayMedium(14.0))),
                        Text("${item.measurement} ", style: ralewayBold(16.0)),
                        Text(item.unit, style: ralewayLight(12.0)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(context, elevation: 0.0),
      body: new SafeArea(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Expanded(child: header),
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
    );
  }
}
