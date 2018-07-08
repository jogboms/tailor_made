import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/gallery.dart';
import 'package:tailor_made/pages/homepage/models/stats.model.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/payments/payments.dart';
import 'package:tailor_made/utils/tm_format_naira.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class BottomRowWidget extends StatelessWidget {
  final StatsModel stats;

  BottomRowWidget({
    Key key,
    @required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                subTitle: "${formatNaira(double.parse(stats.payments.total.toString()))} Total",
                onPressed: () => TMNavigate(context, PaymentsPage(payments: [])),
              ),
            ),
          ),
          new Expanded(
            child: new Container(
              child: TMGridTile(
                color: Colors.blueAccent,
                icon: Icons.image,
                title: "Gallery",
                subTitle: "${stats.gallery.total} Photos",
                onPressed: () => TMNavigate(context, GalleryPage(images: [])),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
