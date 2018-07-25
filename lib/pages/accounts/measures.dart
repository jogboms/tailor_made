import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/pages/accounts/ui/measures_create.dart';
import 'package:tailor_made/pages/accounts/ui/measures_slide_block.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/measures.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';

class AccountMeasuresPage extends StatefulWidget {
  final AccountModel account;

  const AccountMeasuresPage({
    Key key,
    @required this.account,
  }) : super(key: key);

  @override
  AccountMeasuresPageState createState() {
    return new AccountMeasuresPageState();
  }
}

class AccountMeasuresPageState extends State<AccountMeasuresPage>
    with SnackBarProvider {
  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () => showInSnackBar("Long-Press on each block to see more actions"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(
        context,
        title: "Measurements",
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => TMNavigate(
                  context,
                  MeasuresCreate(),
                  fullscreenDialog: true,
                ),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return new StoreConnector<ReduxState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      onInit: (store) => store.dispatch(new InitDataEvents()),
      onDispose: (store) => store.dispatch(new DisposeDataEvents()),
      builder: (BuildContext context, vm) {
        if (vm.isLoading) {
          return Center(
            child: loadingSpinner(),
          );
        }

        final slides = <MeasureSlideBlock>[];

        vm.grouped.forEach((key, data) {
          slides.add(
            MeasureSlideBlock(
              title: key,
              measures: data.toList(),
              parent: this,
            ),
          );
        });

        return new SafeArea(
          top: false,
          child: new SingleChildScrollView(
            child: Column(
              children: slides.toList(),
            ),
          ),
        );
      },
    );
  }
}
