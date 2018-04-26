import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:tailor_made/utils/tm_navigate.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => new _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<Widget> paymentList = List.generate(
      10,
      (int index) {
        return new Container(
          width: 100.0,
          margin: EdgeInsets.only(right: 8.0),
          child: new Material(
            borderRadius: BorderRadius.circular(5.0),
            color: accentColor.withOpacity(.8),
            child: new InkWell(
              onTap: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "15", style: ralewayLight(25.0, Colors.white)),
                          TextSpan(text: "\n"),
                          TextSpan(text: "MAY, 2018", style: ralewayMedium(10.0, Colors.white)),
                        ],
                      ),
                    ),
                    Text(
                      "\$15,000",
                      style: ralewayBold(20.0, Colors.white).copyWith(
                        height: 1.25,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).toList();

    List<Widget> imagesList = List.generate(
      10,
      (int index) {
        return new Container(
          width: 100.0,
          margin: EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new NetworkImage("https://placeimg.com/640/640/nature"),
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: new Material(
            color: Colors.transparent,
            child: new InkWell(
              onTap: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
            ),
          ),
        );
      },
    ).toList();

    Widget payments = new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Payments", style: theme.titleStyle),
            ),
            FlatButton(
              padding: const EdgeInsets.all(8.0),
              child: Text("SHOW ALL"),
              onPressed: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
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
            ]..addAll(paymentList),
          ),
        ),
      ],
    );

    Widget gallery = new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Gallery", style: theme.titleStyle),
            ),
            FlatButton(
              padding: const EdgeInsets.all(8.0),
              child: Text("SHOW ALL"),
              onPressed: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
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
      body: new SafeArea(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Expanded(child: header),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: gallery,
            ),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: payments,
            ),
          ],
        ),
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Blank Page",
      ),
      body: Container(),
    );
  }
}
