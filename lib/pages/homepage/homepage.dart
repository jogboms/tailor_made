import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/pages/homepage/home_view_model.dart';
import 'package:tailor_made/pages/homepage/ui/bottom_row.dart';
import 'package:tailor_made/pages/homepage/ui/header.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/homepage/ui/stats.dart';
import 'package:tailor_made/pages/homepage/ui/store_name_dialog.dart';
import 'package:tailor_made/pages/homepage/ui/top_row.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/pages/splash/splash.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/ui/full_button.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_colors.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_images.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

enum AccountOptions {
  logout,
  storename,
}

enum CreateOptions {
  clients,
  jobs,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 1200))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: .5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: TMImages.pattern,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          new StoreConnector<ReduxState, HomeViewModel>(
            converter: (store) => HomeViewModel(store),
            onInit: (store) => store.dispatch(new InitDataEvents()),
            onDispose: (store) => store.dispatch(new DisposeDataEvents()),
            builder: (context, vm) {
              if (vm.isLoading) {
                return Center(
                  child: loadingSpinner(),
                );
              }

              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new SafeArea(
                    top: false,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(child: HeaderWidget(account: vm.account)),
                        StatsWidget(stats: vm.stats),
                        TopRowWidget(stats: vm.stats),
                        BottomRowWidget(stats: vm.stats),
                        _buildCreateBtn(vm.contacts),
                      ],
                    ),
                  ),
                  _buildBtnBar(theme, vm.account),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  _buildBtnBar(TMTheme theme, AccountModel account) {
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: SizedBox.fromSize(
          size: Size.square(56.0),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(1.5),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kAccentColor.withOpacity(.5), width: 1.5),
            ),
            child: GestureDetector(
              onTap: onTapAccount(account),
              child: account?.photoURL != null
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(account.photoURL),
                    )
                  : new Icon(
                      Icons.person,
                      color: theme.appBarColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateBtn(List<ContactModel> contacts) {
    return FullButton(
      onPressed: onTapCreate(contacts),
      shape: RoundedRectangleBorder(),
      child: ScaleTransition(
        scale: new Tween(begin: 0.95, end: 1.025).animate(controller),
        alignment: FractionalOffset.center,
        child: new Text(
          "TAP TO CREATE",
          style: ralewayBold(14.0, TMColors.white).copyWith(letterSpacing: 1.25),
        ),
      ),
    );
  }

  onTapAccount(AccountModel account) {
    return () async {
      AccountOptions result = await showDialog<AccountOptions>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('Select action', style: const TextStyle(fontSize: 14.0)),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(context, AccountOptions.storename),
                child: TMListTile(
                  color: kAccentColor,
                  icon: Icons.store,
                  title: "Store",
                ),
              ),
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(context, AccountOptions.logout),
                child: TMListTile(
                  color: Colors.redAccent.shade400,
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
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                backgroundColor: Colors.black38,
                body: StoreNameDialog(account: account),
              ),
            ),
          );

          if (_storeName != null && _storeName != account.storeName) {
            await account.reference.updateData({
              "storeName": _storeName,
            });
          }

          break;
        case AccountOptions.logout:
          final response = await confirmDialog(context: context, title: Text("You are about to logout."));

          if (response == true) {
            await Auth.signOutWithGoogle();
            Navigator.pushReplacement(
              context,
              TMNavigate.fadeIn(
                new SplashPage(isColdStart: false),
              ),
            );
          }
          break;
      }
    };
  }

  onTapCreate(List<ContactModel> contacts) {
    return () async {
      CreateOptions result = await showDialog<CreateOptions>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('Select action', style: const TextStyle(fontSize: 14.0)),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(context, CreateOptions.clients),
                child: TMListTile(
                  color: Colors.orangeAccent,
                  icon: Icons.supervisor_account,
                  title: "Clients",
                ),
              ),
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(context, CreateOptions.jobs),
                child: TMListTile(
                  color: Colors.greenAccent.shade400,
                  icon: Icons.attach_money,
                  title: "Job",
                ),
              ),
            ],
          );
        },
      );
      switch (result) {
        case CreateOptions.clients:
          TMNavigate(context, ContactsCreatePage());
          break;
        case CreateOptions.jobs:
          TMNavigate(context, JobsCreatePage(contacts: contacts));
          break;
      }
    };
  }
}
