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
    final L10n l10n = context.l10n;

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
                title: l10n.paymentPageTitle,
                subTitle: l10n.paymentsCaption(AppMoney(stats.payments.total).formatted),
                onPressed: () => context.router.toPayments(userId),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                color: Colors.blueAccent,
                icon: Icons.image,
                title: l10n.galleryPageTitle,
                subTitle: l10n.photosCaption(stats.gallery.total.toInt()),
                onPressed: () => context.router.toGallery(userId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
