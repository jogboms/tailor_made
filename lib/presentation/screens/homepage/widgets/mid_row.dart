import 'package:flutter/material.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'helpers.dart';

class MidRowWidget extends StatelessWidget {
  const MidRowWidget({super.key, required this.userId, required this.stats});

  final StatsModel? stats;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(bottom: AppBorderSide())),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(border: Border(right: AppBorderSide())),
              child: TMGridTile(
                color: Colors.redAccent,
                icon: Icons.attach_money,
                title: 'Payments',
                subTitle: '${AppMoney(stats!.payments.total).formatted} Total',
                onPressed: () => Dependencies.di().get<PaymentsCoordinator>().toPayments(userId),
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
                onPressed: () => Dependencies.di().get<GalleryCoordinator>().toGallery(userId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
