import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import 'helpers.dart';

class MidRowWidget extends StatelessWidget {
  const MidRowWidget({super.key, required this.userId, required this.stats});

  final StatsEntity stats;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border(bottom: Divider.createBorderSide(context))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(border: Border(right: Divider.createBorderSide(context))),
              child: TMGridTile(
                color: Colors.redAccent,
                icon: Icons.attach_money,
                title: 'Payments',
                subTitle: '${AppMoney(stats.payments.total).formatted} Total',
                onPressed: () => context.router.toPayments(userId),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                color: Colors.blueAccent,
                icon: Icons.image,
                title: 'Gallery',
                subTitle: '${stats.gallery.total.toInt()} Photos',
                onPressed: () => context.router.toGallery(userId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
