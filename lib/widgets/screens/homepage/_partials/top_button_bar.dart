import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_images.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/rebloc/actions/account.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/utils/mk_child_dialog.dart';
import 'package:tailor_made/utils/mk_choice_dialog.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_close_button.dart';
import 'package:tailor_made/widgets/_partials/mk_dots.dart';
import 'package:tailor_made/widgets/screens/homepage/_partials/helpers.dart';
import 'package:tailor_made/widgets/screens/homepage/_views/notice_dialog.dart';
import 'package:tailor_made/widgets/screens/homepage/_views/review_modal.dart';
import 'package:tailor_made/widgets/screens/homepage/_views/store_name_dialog.dart';

enum AccountOptions {
  logout,
  storename,
}

class TopButtonBar extends StatelessWidget {
  const TopButtonBar({
    Key key,
    @required this.account,
    @required this.shouldSendRating,
    @required this.onLogout,
  }) : super(key: key);

  final AccountModel account;
  final bool shouldSendRating;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);
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
                border: Border.all(
                  color: kPrimaryColor.withOpacity(.5),
                  width: 1.5,
                ),
              ),
              child: GestureDetector(
                onTap: _onTapAccount(context),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    account?.photoURL != null
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                CachedNetworkImageProvider(account.photoURL),
                          )
                        : Icon(
                            Icons.person,
                            color: theme.appBarTitle.color,
                          ),
                    Align(
                      alignment: const Alignment(0.0, 2.25),
                      child: account.hasPremiumEnabled
                          ? const ImageIcon(
                              MkImages.verified,
                              color: kPrimaryColor,
                            )
                          : null,
                    ),
                    Align(
                      alignment: Alignment(
                        1.25,
                        account.hasPremiumEnabled ? -1.25 : 1.25,
                      ),
                      child: _shouldShowIndicator
                          ? const MkDots(color: kAccentColor)
                          : null,
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

  bool get _shouldShowIndicator =>
      !(account?.hasReadNotice ?? false) || shouldSendRating;

  VoidCallback _onTapAccount(BuildContext context) {
    return () async {
      if (shouldSendRating) {
        final _res = await mkShowChildDialog<int>(
          context: context,
          child: const ReviewModal(),
        );

        if (_res != null) {
          StoreProvider.of<AppState>(context).dispatcher(
            OnSendRating(payload: account, rating: _res),
          );
        }
        return;
      }

      if (_shouldShowIndicator) {
        await mkShowChildDialog<dynamic>(
          context: context,
          child: NoticeDialog(
            account: account,
          ),
        );
        StoreProvider.of<AppState>(context).dispatcher(
          OnReadNotice(payload: account),
        );
        return;
      }

      final AccountOptions result = await showDialog<AccountOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'Select action',
              style: MkTheme.of(context).body3,
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, AccountOptions.storename);
                },
                child: const TMListTile(
                  color: kAccentColor,
                  icon: Icons.store,
                  title: "Store",
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, AccountOptions.logout);
                },
                child: TMListTile(
                  color: Colors.grey.shade400,
                  icon: Icons.power_settings_new,
                  title: "Logout",
                ),
              ),
            ],
          );
        },
      );

      switch (result) {
        case AccountOptions.storename:
          final _storeName = await Navigator.push<String>(
            context,
            MkNavigate.fadeIn<String>(
              Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  leading: const MkCloseButton(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.black38,
                body: StoreNameDialog(account: account),
              ),
            ),
          );

          if (_storeName != null && _storeName != account.storeName) {
            await account.reference.updateData(<String, String>{
              "storeName": _storeName,
            });
          }

          break;

        case AccountOptions.logout:
          final response = await mkChoiceDialog(
            context: context,
            message: "You are about to logout.",
          );

          if (response == true) {
            onLogout();
          }
          break;
      }
    };
  }
}
