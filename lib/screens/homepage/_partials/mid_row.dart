import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/screens/homepage/_partials/helpers.dart';
import 'package:tailor_made/utils/mk_money.dart';

class MidRowWidget extends StatelessWidget {
  const MidRowWidget({super.key, required this.userId, required this.stats});

  final StatsModel? stats;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(bottom: MkBorderSide())),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(border: Border(right: MkBorderSide())),
              child: TMGridTile(
                color: Colors.redAccent,
                icon: Icons.attach_money,
                title: 'Payments',
                subTitle: '${MkMoney(stats!.payments.total).formatted} Total',
                onPressed: () => Dependencies.di().paymentsCoordinator.toPayments(userId),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                color: Colors.blueAccent,
                icon: Icons.image,
                title: 'Gallery',
                subTitle: '${stats!.gallery.total} Photos',
                onPressed: () => Dependencies.di().galleryCoordinator.toGallery(userId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
