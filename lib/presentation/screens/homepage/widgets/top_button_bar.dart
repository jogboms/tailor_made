import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import '../widgets/notice_dialog.dart';
import '../widgets/review_modal.dart';
import 'helpers.dart';

enum AccountOptions { logout, storename }

class TopButtonBar extends StatelessWidget {
  const TopButtonBar({
    super.key,
    required this.account,
    required this.shouldSendRating,
    required this.onLogout,
  });

  final AccountModel? account;
  final bool shouldSendRating;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider? theme = ThemeProvider.of(context);
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
                border: Border.all(color: kPrimaryColor.withOpacity(.5), width: 1.5),
              ),
              child: GestureDetector(
                onTap: _onTapAccount(context),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    if (account?.photoURL != null)
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: CachedNetworkImageProvider(account!.photoURL),
                      )
                    else
                      Icon(Icons.person, color: theme!.appBarTitle.color),
                    Align(
                      alignment: const Alignment(0.0, 2.25),
                      child:
                          account!.hasPremiumEnabled ? const ImageIcon(AppImages.verified, color: kPrimaryColor) : null,
                    ),
                    Align(
                      alignment: Alignment(1.25, account!.hasPremiumEnabled ? -1.25 : 1.25),
                      child: _shouldShowIndicator ? const Dots(color: kAccentColor) : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _shouldShowIndicator => !(account?.hasReadNotice ?? false) || shouldSendRating;

  VoidCallback _onTapAccount(BuildContext context) {
    return () async {
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      if (shouldSendRating) {
        final int? rating = await showChildDialog<int>(context: context, child: const ReviewModal());

        if (rating != null) {
          store.dispatch(OnSendRating(account, rating));
        }
        return;
      }

      if (_shouldShowIndicator) {
        await showChildDialog<dynamic>(context: context, child: NoticeDialog(account: account));
        store.dispatch(OnReadNotice(account));
        return;
      }

      final AccountOptions? result = await showDialog<AccountOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select action', style: ThemeProvider.of(context)!.body3),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, AccountOptions.storename);
                },
                child: const TMListTile(color: kAccentColor, icon: Icons.store, title: 'Store'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, AccountOptions.logout);
                },
                child: TMListTile(color: Colors.grey.shade400, icon: Icons.power_settings_new, title: 'Logout'),
              ),
            ],
          );
        },
      );

      if (result == null) {
        return;
      }

      switch (result) {
        case AccountOptions.storename:
          final String? storeName = await context.registry.get<SharedCoordinator>().toStoreNameDialog(account);

          if (storeName != null && storeName != account!.storeName) {
            await account!.reference?.updateData(<String, String>{'storeName': storeName});
          }

          break;

        case AccountOptions.logout:
          final bool? response = await showChoiceDialog(context: context, message: 'You are about to logout.');

          if (response == true) {
            onLogout();
          }
          break;
      }
    };
  }
}
