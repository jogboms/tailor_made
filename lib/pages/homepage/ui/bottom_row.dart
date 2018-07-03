import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/gallery.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/payments/payments.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class BottomRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void onTapPayments() {
      TMNavigate(context, PaymentsPage());
    }

    void onTapGallery() {
      TMNavigate(context, GalleryPage());
    }

    return new Container(
      height: 120.0,
      decoration: new BoxDecoration(
        border: new Border(bottom: TMBorderSide()),
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border(
                  right: TMBorderSide(),
                ),
              ),
              child: TMGridTile(
                color: Colors.redAccent,
                icon: Icons.attach_money,
                title: "Payments",
                subTitle: "26 Received",
                onPressed: onTapPayments,
              ),
            ),
          ),
          new Expanded(
            child: new Container(
              child: TMGridTile(
                color: Colors.blueAccent,
                icon: Icons.image,
                title: "Gallery",
                subTitle: "206 Photos",
                onPressed: onTapGallery,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
