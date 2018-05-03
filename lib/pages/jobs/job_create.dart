import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'ui/slide_down.dart';

class JobCreate extends StatefulWidget {
  @override
  _JobCreateState createState() => new _JobCreateState();
}

class _JobCreateState extends State<JobCreate> {
  @override
  Widget build(BuildContext context) {
    final int length = 1;

    List<SlideDownItem> items = [
      new SlideDownItem(
        title: "Blouse",
        body: Container(
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
            children: List.generate(length, (int index) {
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
                        Text("Arm Hole", style: TextStyle(fontSize: 12.0)),
                        Text("29", style: TextStyle(fontSize: 24.0)),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        isExpanded: true,
      ),
    ];

    return new Container();
  }
}
