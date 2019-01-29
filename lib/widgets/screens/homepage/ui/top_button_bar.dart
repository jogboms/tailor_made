import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_images.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_child_dialog.dart';
import 'package:tailor_made/utils/mk_choice_dialog.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/screens/homepage/home_view_model.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/helpers.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/notice_dialog.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/review_modal.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/store_name_dialog.dart';

enum AccountOptions {
  logout,
  storename,
}

class TopButtonBar extends StatelessWidget {
  const TopButtonBar({
    Key key,
    @required this.vm,
    @required this.onLogout,
  }) : super(key: key);

  final HomeViewModel vm;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);
    final account = vm.account;
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox.fromSize(
            size: Size.square(48.0),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: kPrimaryColor.withOpacity(.5), width: 1.5),
              ),
              child: GestureDetector(
                onTap: _onTapAccount(context, vm),
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
                      alignment: Alignment(0.0, 2.25),
                      child: vm.account.hasPremiumEnabled
                          ? ImageIcon(
                              MkImages.verified,
                              color: kPrimaryColor,
                            )
                          : null,
                    ),
                    Align(
                      alignment: Alignment(
                        1.25,
                        vm.account.hasPremiumEnabled ? -1.25 : 1.25,
                      ),
                      child: _shouldShowIndicator(vm)
                          ? Container(
                              width: 15.5,
                              height: 15.5,
                              decoration: BoxDecoration(
                                color: kAccentColor,
                                border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                  width: 2.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                            )
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

  bool _shouldShowIndicator(HomeViewModel vm) {
    return !(vm.account?.hasReadNotice ?? false) || vm.shouldSendRating;
  }

  void Function() _onTapAccount(BuildContext context, HomeViewModel vm) {
    final account = vm.account;
    return () async {
      if (vm.shouldSendRating) {
        final _res = await mkShowChildDialog<int>(
          context: context,
          child: ReviewModal(),
        );

        if (_res != null) {
          vm.onSendRating(_res);
        }
        return;
      }

      if (_shouldShowIndicator(vm)) {
        await mkShowChildDialog<dynamic>(
          context: context,
          child: NoticeDialog(
            account: account,
          ),
        );
        vm.onReadNotice();
        return;
      }

      final AccountOptions result = await showDialog<AccountOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select action',
                style: const TextStyle(fontSize: 14.0)),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () =>
                    Navigator.pop(context, AccountOptions.storename),
                child: TMListTile(
                  color: kAccentColor,
                  icon: Icons.store,
                  title: "Store",
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, AccountOptions.logout),
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
                  leading: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
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
            title: "",
          );

          if (response == true) {
            onLogout();
          }
          break;
      }
    };
  }
}
