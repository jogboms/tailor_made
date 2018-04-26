import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => new _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<Widget> imagesList = List.generate(
      10,
      (int index) {
        return new Container(
          width: 100.0,
          margin: EdgeInsets.only(right: 8.0),
          child: new Material(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey[200],
            child: new InkWell(
              onTap: () {},
            ),
          ),
        );
      },
    ).toList();

    Widget gallery = new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Gallery", style: ralewayMedium(20.0, titleBaseColor)),
            ),
            FlatButton(
              padding: const EdgeInsets.all(8.0),
              child: Text("SHOW ALL"),
              onPressed: () {},
            ),
          ],
        ),
        new Container(
          padding: const EdgeInsets.all(8.0),
          height: 120.0,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: [
              new Container(
                width: 100.0,
                margin: EdgeInsets.only(right: 8.0),
                child: new Material(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey[100],
                  child: new InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 30.0,
                      color: textBaseColor.withOpacity(.35),
                    ),
                  ),
                ),
              )
            ]..addAll(imagesList),
          ),
        ),
      ],
    );

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
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          header,
          new Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: gallery,
          ),
        ],
      ),
    );
  }
}
