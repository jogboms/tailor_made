import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import '../widgets/notice_dialog.dart';
import '../widgets/review_modal.dart';
import 'helpers.dart';

enum AccountOptions { logout, storeName }

class TopButtonBar extends StatelessWidget {
  const TopButtonBar({
    super.key,
    required this.account,
    required this.shouldSendRating,
    required this.onLogout,
  });

  final AccountEntity account;
  final bool shouldSendRating;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox.fromSize(
            size: const Size.square(48.0),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary.withOpacity(.5), width: 1.5),
              ),
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, _) => GestureDetector(
                  onTap: _onTapAccount(
                    context,
                    accountNotifier: ref.read(accountNotifierProvider.notifier),
                    authStateNotifier: ref.read(authStateNotifierProvider.notifier),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (account.photoURL case final String photoUrl)
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(photoUrl),
                        )
                      else
                        const Icon(Icons.person),
                      Align(
                        alignment: const Alignment(0.0, 2.25),
                        child: account.hasPremiumEnabled
                            ? ImageIcon(AppImages.verified, color: colorScheme.primary) //
                            : null,
                      ),
                      Align(
                        alignment: Alignment(1.25, account.hasPremiumEnabled ? -1.25 : 1.25),
                        child: _shouldShowIndicator ? Dots(color: colorScheme.secondary) : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _shouldShowIndicator => !account.hasReadNotice || shouldSendRating;

  VoidCallback _onTapAccount(
    BuildContext context, {
    required AccountNotifier accountNotifier,
    required AuthStateNotifier authStateNotifier,
  }) {
    final L10n l10n = context.l10n;
    final AppRouter router = context.router;

    return () async {
      if (shouldSendRating) {
        final int? rating = await showChildDialog<int>(context: context, child: const ReviewModal());

        if (rating != null) {
          accountNotifier.sendRating(rating);
        }
        return;
      }

      if (_shouldShowIndicator) {
        await showChildDialog<dynamic>(context: context, child: NoticeDialog(account: account));
        accountNotifier.readNotice();
        return;
      }

      final AccountOptions? result = await showDialog<AccountOptions>(
        context: context,
        builder: (BuildContext context) {
          final ColorScheme colorScheme = Theme.of(context).colorScheme;

          return SimpleDialog(
            title: Text(l10n.selectActionTitle, style: Theme.of(context).textTheme.labelLarge),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, AccountOptions.storeName),
                child: TMListTile(color: colorScheme.secondary, icon: Icons.store, title: l10n.storeLabel),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, AccountOptions.logout),
                child: TMListTile(
                  color: colorScheme.outlineVariant,
                  icon: Icons.power_settings_new,
                  title: l10n.logoutLabel,
                ),
              ),
            ],
          );
        },
      );

      if (result == null) {
        return;
      }

      switch (result) {
        case AccountOptions.storeName:
          final String? storeName = await router.toStoreNameDialog(account);

          if (storeName != null && storeName != account.storeName) {
            accountNotifier.updateStoreName(storeName);
          }

          break;

        case AccountOptions.logout:
          if (context.mounted) {
            final bool? response = await showChoiceDialog(context: context, message: l10n.logoutConfirmationMessage);

            if (response == true) {
              authStateNotifier.signOut();
              onLogout();
            }
          }
          break;
      }
    };
  }
}
