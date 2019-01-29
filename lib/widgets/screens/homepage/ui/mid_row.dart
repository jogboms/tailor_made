import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/screens/gallery/gallery.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/helpers.dart';
import 'package:tailor_made/widgets/screens/payments/payments.dart';

class MidRowWidget extends StatelessWidget {
  const MidRowWidget({
    Key key,
    @required this.height,
    @required this.stats,
  }) : super(key: key);

  final StatsModel stats;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border(bottom: MkBorderSide()),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: MkBorderSide(),
                ),
              ),
              child: TMGridTile(
                color: Colors.redAccent,
                icon: Icons.attach_money,
                title: "Payments",
                subTitle: "${MkMoney(stats.payments.total).format} Total",
                onPressed: () => MkNavigate(context, PaymentsPage()),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: TMGridTile(
                color: Colors.blueAccent,
                icon: Icons.image,
                title: "Gallery",
                subTitle: "${stats.gallery.total} Photos",
                onPressed: () => MkNavigate(context, GalleryPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
