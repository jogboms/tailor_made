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
import 'package:tailor_made/pages/templates/access_denied.dart';
import 'package:tailor_made/pages/templates/rate_limit.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/ui/full_button.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_images.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_phone.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const double _kBottomBarHeight = 46.0;

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

              if (vm.isDisabled) {
                return AccessDeniedPage(
                  onSendMail: () {
                    email('Unwarranted%20Account%20Suspension%20%23${vm.account.uid}');
                  },
                );
              }

              if (vm.isWarning && vm.hasSkipedPremium == false) {
                return RateLimitPage(
                  onSignUp: () {
                    vm.onPremiumSignUp();
                  },
                  onSkipedPremium: () {
                    vm.onSkipedPremium();
                  },
                );
              }

              return LayoutBuilder(
                builder: (context, constraint) {
                  final bool isLandscape = constraint.maxWidth > constraint.maxHeight;
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      new SafeArea(
                        top: false,
                        child: SingleChildScrollView(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ConstrainedBox(
                                constraints: BoxConstraints.expand(
                                  // Somehow, i mathematically came up w/ these numbers & they made sense :)
                                  height: (isLandscape ? (constraint.maxHeight / 1.0) : (constraint.maxHeight / 1.89)) - _kBottomBarHeight,
                                ),
                                child: HeaderWidget(account: vm.account),
                              ),
                              StatsWidget(stats: vm.stats),
                              TopRowWidget(stats: vm.stats),
                              BottomRowWidget(stats: vm.stats),
                              SizedBox(height: _kBottomBarHeight),
                            ],
                          ),
                        ),
                      ),
                      _buildCreateBtn(vm.contacts),
                      _buildTopBtnBar(theme, vm.account),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBtnBar(TMTheme theme, AccountModel account) {
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
                border: Border.all(color: kPrimaryColor.withOpacity(.5), width: 1.5),
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
      ),
    );
  }

  Widget _buildCreateBtn(List<ContactModel> contacts) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: SizedBox(
          height: _kBottomBarHeight,
          child: FullButton(
            onPressed: onTapCreate(contacts),
            shape: RoundedRectangleBorder(),
            child: ScaleTransition(
              scale: new Tween(begin: 0.95, end: 1.025).animate(controller),
              alignment: FractionalOffset.center,
              child: new Text(
                "TAP TO CREATE",
                style: ralewayBold(14.0, Colors.white).copyWith(letterSpacing: 1.25),
              ),
            ),
          ),
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
