import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/accounts/measures.dart';
import 'package:tailor_made/pages/homepage/home_view_model.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/homepage/ui/notice_dialog.dart';
import 'package:tailor_made/pages/homepage/ui/store_name_dialog.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

enum AccountOptions {
  logout,
  storename,
  measurement,
}

class TopButtonBar extends StatelessWidget {
  final HomeViewModel vm;
  final VoidCallback onLogout;

  const TopButtonBar({
    Key key,
    @required this.vm,
    @required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
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
                        : new Icon(
                            Icons.person,
                            color: theme.appBarColor,
                          ),
                    new Align(
                      alignment: Alignment(1.25, 1.25),
                      child: account?.hasReadNotice ?? false
                          ? null
                          : new Container(
                              width: 15.5,
                              height: 15.5,
                              decoration: new BoxDecoration(
                                color: kAccentColor,
                                border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                  width: 2.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
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

  void Function() _onTapAccount(BuildContext context, HomeViewModel vm) {
    final account = vm.account;
    return () async {
      if (!(account?.hasReadNotice ?? false)) {
        await showChildDialog<dynamic>(
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
          return new SimpleDialog(
            title: const Text('Select action',
                style: const TextStyle(fontSize: 14.0)),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () =>
                    Navigator.pop(context, AccountOptions.storename),
                child: TMListTile(
                  color: kAccentColor,
                  icon: Icons.store,
                  title: "Store",
                ),
              ),
              new SimpleDialogOption(
                onPressed: () =>
                    Navigator.pop(context, AccountOptions.measurement),
                child: TMListTile(
                  color: Colors.blue.shade400,
                  icon: Icons.content_cut,
                  title: "Measurements",
                ),
              ),
              new SimpleDialogOption(
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
            TMNavigate.fadeIn<String>(
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

        case AccountOptions.measurement:
          TMNavigate(context, AccountMeasuresPage(account: account));
          break;

        case AccountOptions.logout:
          final response = await confirmDialog(
              context: context, title: Text("You are about to logout."));

          if (response == true) {
            onLogout();
          }
          break;
      }
    };
  }
}
