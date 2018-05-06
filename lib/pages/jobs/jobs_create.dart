import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'ui/slide_down.dart';

class JobsCreatePage extends StatefulWidget {
  @override
  _JobsCreatePageState createState() => new _JobsCreatePageState();
}

class _JobsCreatePageState extends State<JobsCreatePage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<Widget> children = [
      //   Container(
      //     color: Colors.blueAccent,
      //     height: 100.0,
      //     width: 100.0,
      //   ),
    ];

    Widget makeHeader(String title, [String trailing = ""]) {
      return new Container(
        color: Colors.grey[100].withOpacity(.4),
        margin: const EdgeInsets.only(top: 8.0),
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
        alignment: AlignmentDirectional.centerStart,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title.toUpperCase(), style: ralewayLight(12.0, textBaseColor.shade800)),
            Text(trailing, style: ralewayLight(12.0, textBaseColor.shade800)),
          ],
        ),
      );
    }

    // children.add(makeHeader("Metadata"));
    children.add(
      Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        // margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Clarion Igwe", style: theme.mediumTextStyle),
                Text("32 Jobs", style: theme.smallTextStyle),
              ],
            )
          ],
        ),
      ),
    );

    children.add(makeHeader("Style Name"));
    children.add(
      new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: new TextField(
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 22.0, color: Colors.black),
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 8.0),
            hintText: "Enter Name",
            hintStyle: TextStyle(fontSize: 12.0),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: borderSideColor,
                width: 0.0,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ),
    );

    children.add(makeHeader("Measurements", "Inches (In)"));
    children..addAll(JobCreateItem.getList());

    children.add(makeHeader("Payment", "Naira (₦)"));
    children.add(
      new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: new TextField(
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 22.0, color: Colors.black),
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 8.0),
            hintText: "Enter Amount",
            hintStyle: TextStyle(fontSize: 12.0),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: borderSideColor,
                width: 0.0,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ),
    );

    children.add(makeHeader("Additional Notes"));
    children.add(
      new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: new TextField(
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 22.0, color: Colors.black),
          maxLines: 6,
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 8.0),
            hintText: "Fabric color, size, special requirements...",
            hintStyle: TextStyle(fontSize: 12.0),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: borderSideColor,
                width: 0.0,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ),
    );

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "",
        actions: [
          FlatButton(
            child: Text("SAVE"),
            onPressed: () {},
          ),
        ],
      ),
      body: new SafeArea(
        top: false,
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

class JobCreateItem extends StatelessWidget {
  final List<String> list;

  JobCreateItem(this.list);

  static getList() {
    return [
      new SlideDownItem(
        title: "Blouse",
        body: new JobCreateItem([
          "Arm Hole",
          "Shoulder",
          "Burst",
          "Burst Point",
          "Shoulder - Burst Point",
          "Shoulder - Under Burst",
          "Shoulder - Waist",
        ]),
        // isExpanded: true,
      ),
      new SlideDownItem(
        title: "Trouser",
        body: new JobCreateItem([
          "Length",
          "Waist",
          "Crouch",
          "Thigh",
          "Body Rise",
          "Width",
          "Hip",
        ]),
      ),
      new SlideDownItem(
        title: "Skirts",
        body: new JobCreateItem([
          "Full Length",
          "Short Length",
          "Knee Length",
          "Hip",
        ]),
      ),
      new SlideDownItem(
        title: "Gown",
        body: new JobCreateItem([
          "Waist",
          "Long Length",
          "Short Length",
          "Knee Length",
        ]),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int length = list.length;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderSideColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: list.map((String title) {
          int index = list.indexOf(title);
          return new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final removeBorder = (length % 2 != 0 && (index == length - 1)) || (length % 2 == 0 && (index == length - 1 || index == length - 2));
              return new Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: borderSideColor,
                      width: 1.0,
                      style: removeBorder ? BorderStyle.none : BorderStyle.solid,
                    ),
                  ),
                ),
                width: constraints.maxWidth / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: TextStyle(fontSize: 12.0)),
                    // Text("29", style: TextStyle(fontSize: 24.0)),
                    new TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "Enter Value",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
