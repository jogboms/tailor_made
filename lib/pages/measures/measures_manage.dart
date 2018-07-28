import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/pages/measures/measures_create.dart';
import 'package:tailor_made/pages/measures/ui/measures_slide_block.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/measures.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasuresManagePage extends StatefulWidget {
  final AccountModel account;

  const MeasuresManagePage({
    Key key,
    @required this.account,
  }) : super(key: key);

  @override
  MeasuresManagePageState createState() => new MeasuresManagePageState();
}

class MeasuresManagePageState extends State<MeasuresManagePage>
    with SnackBarProvider {
  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () => showInSnackBar("Long-Press on any group to see more actions."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      appBar: appBar(
        context,
        title: "Measurements",
      ),
      body: _buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: new Icon(Icons.add),
        backgroundColor: kAccentColor,
        foregroundColor: Colors.white,
        label: Text("Add Group"),
        onPressed: () => TMNavigate(
              context,
              MeasuresCreate(),
              fullscreenDialog: true,
            ),
      ),
    );
  }

  Widget _buildBody() {
    return new StoreConnector<ReduxState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (BuildContext context, vm) {
        if (vm.isLoading) {
          return Center(
            child: loadingSpinner(),
          );
        }

        if (vm.measures == null || vm.measures.isEmpty) {
          return Center(
            child: TMEmptyResult(message: "No measurements available"),
          );
        }

        final slides = <Widget>[];

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
              children: slides
                ..add(
                  SizedBox(
                    height: 72.0,
                  ),
                )
                ..toList(),
            ),
          ),
        );
      },
    );
  }
}
