import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:flutter/cupertino.dart';
import 'ui/payment_grids.dart';
import 'ui/gallery_grids.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => new _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    Widget header = Container(
      color: Colors.grey[200],
      height: 250.0,
    );

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Job",
      ),
      body: new SafeArea(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Expanded(child: header),
            new Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GalleryGrids(),
            ),
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
