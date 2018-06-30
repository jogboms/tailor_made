import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/avatar_app_bar.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'ui/slide_down.dart';

class JobsCreatePage extends StatefulWidget {
  final ContactModel contact;

  JobsCreatePage({this.contact});

  @override
  _JobsCreatePageState createState() => new _JobsCreatePageState();
}

class _JobsCreatePageState extends State<JobsCreatePage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<Widget> children = [];

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

    if (widget.contact != null) {
      children.add(makeHeader("Style Name"));
      children.add(
        new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: new TextField(
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: new InputDecoration(
              isDense: true,
              hintText: "Enter Name",
              hintStyle: TextStyle(fontSize: 12.0),
              // border: InputBorder.none,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: borderSideColor,
                  width: 1.0,
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
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: new InputDecoration(
              isDense: true,
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
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            maxLines: 6,
            decoration: new InputDecoration(
              isDense: true,
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

      children.add(
        Padding(
          child: RaisedButton(
            color: accentColor,
            child: Text(
              "FINISH",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 50.0),
        ),
      );
    }

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: widget.contact != null
          ? AvatarAppBar(
              tag: widget.contact.imageUrl,
              image: NetworkImage(widget.contact.imageUrl),
              title: new Text(
                widget.contact.fullname,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ralewayRegular(18.0, theme.appBarColor),
              ),
              subtitle: Text("${widget.contact.totalJobs} Jobs", style: theme.smallTextStyle),
              actions: widget.contact != null
                  ? [
                      IconButton(
                        // icon: Icon(Icons.add_a_photo),
                        icon: Icon(Icons.add_photo_alternate),
                        onPressed: () {},
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.check),
                      //   onPressed: () {},
                      // ),
                      // FlatButton(
                      //   child: Text("SAVE"),
                      //   onPressed: () {},
                      // ),
                    ]
                  : null,
            )
          : appBar(context),
      body: widget.contact != null
          ? new SafeArea(
              top: false,
              child: new SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            )
          : new Center(
              child: FlatButton(
                onPressed: () {},
                child: Text("SELECT A CLIENT"),
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
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: borderSideColor,
                      width: 1.0,
                      style: removeBorder ? BorderStyle.none : BorderStyle.solid,
                    ),
                    right: BorderSide(
                      color: borderSideColor,
                      width: 1.0,
                      style: index % 2 == 0 ? BorderStyle.solid : BorderStyle.none,
                    ),
                  ),
                ),
                width: constraints.maxWidth / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: TextStyle(fontSize: 12.0)),
                    new TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
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
