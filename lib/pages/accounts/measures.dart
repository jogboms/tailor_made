import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/accounts/ui/measures_create.dart';
import 'package:tailor_made/pages/accounts/ui/measures_slide_block.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_group_model_by.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';

enum ActionChoice {
  edit,
  delete,
}

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
    return StreamBuilder(
      stream: CloudDb.measurements.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            (snapshot.hasData && snapshot.data.documents == null)) {
          return Center(
            child: loadingSpinner(),
          );
        }

        final measures = List<DocumentSnapshot>.from(snapshot.data.documents)
            .map((DocumentSnapshot doc) => MeasureModel.fromDoc(doc))
            .toList();

        final slides = <MeasureSlideBlock>[];

        groupModelBy<MeasureModel>(measures, "group").forEach((key, data) {
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
