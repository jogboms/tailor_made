import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/measures.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_snackbar_provider.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/measures/measures_create.dart';
import 'package:tailor_made/widgets/screens/measures/ui/measures_slide_block.dart';

class MeasuresManagePage extends StatefulWidget {
  const MeasuresManagePage({
    Key key,
    @required this.account,
  }) : super(key: key);

  final AccountModel account;

  @override
  MeasuresManagePageState createState() => MeasuresManagePageState();
}

class MeasuresManagePageState extends State<MeasuresManagePage>
    with MkSnackBarProvider {
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () => showInSnackBar("Long-Press on any group to see more actions."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      appBar: const MkAppBar(
        title: const Text("Measurements"),
      ),
      body: _buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        backgroundColor: kAccentColor,
        foregroundColor: Colors.white,
        label: const Text("Add Group"),
        onPressed: () {
          MkNavigate(
            context,
            const MeasuresCreate(),
            fullscreenDialog: true,
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return ViewModelSubscriber<AppState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        MeasuresViewModel vm,
      ) {
        if (vm.isLoading) {
          return Center(
            child: const MkLoadingSpinner(),
          );
        }

        if (vm.model == null || vm.model.isEmpty) {
          return Center(
            child: const EmptyResultView(message: "No measurements available"),
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

        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: slides
                ..add(const SizedBox(height: 72.0))
                ..toList(),
            ),
          ),
        );
      },
    );
  }
}
