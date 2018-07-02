import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';

class PaymentsListWidget extends StatelessWidget {
  final ContactModel contact;

  PaymentsListWidget({@required this.contact});

  @override
  build(BuildContext context) {
    // return SliverFixedExtentList(
    return SliverList(
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          onTapImage() {
            print("onTapList");
          }

          return Container(
            // padding: EdgeInsets.zero,
            // padding: EdgeInsets.all(20.0),
            color: Colors.grey[100],
            margin: EdgeInsets.only(bottom: 2.0),
            height: 100.0,
            child: new InkResponse(
              onTap: onTapImage,
              radius: 300.0,
              child: Text(""),
            ),
          );
        },
        childCount: 30,
      ),
      // itemExtent: 30.0,
    );
  }
}
