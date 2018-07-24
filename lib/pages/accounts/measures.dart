import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/accounts/ui/measures_create.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/slide_down.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_group_model_by.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

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

        final slides = <SlideDownItem>[];

        groupModelBy<MeasureModel>(measures, "group").forEach((key, data) {
          slides.add(
            new SlideDownItem(
              title: key,
              body: _buildBlock(
                data.toList(),
              ),
              onLongPress: () async {
                final choice = await showChildDialog<ActionChoice>(
                  context: context,
                  child: new SimpleDialog(
                    children: <Widget>[
                      new SimpleDialogOption(
                        onPressed: () =>
                            Navigator.pop(context, ActionChoice.edit),
                        child: Padding(
                          child: Text("Edit"),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                      new SimpleDialogOption(
                        onPressed: () =>
                            Navigator.pop(context, ActionChoice.delete),
                        child: Padding(
                          child: Text("Delete"),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ],
                  ),
                );

                if (choice == null) {
                  return;
                }

                if (choice == ActionChoice.edit) {
                  onTapEditBlock(data);
                } else if (choice == ActionChoice.delete) {
                  onTapDeleteBlock(data);
                }
              },
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

  Widget _buildBlock(List<MeasureModel> list) {
    final children = list.map<Widget>((measure) {
      return ListTile(
        dense: true,
        title: Text(measure.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: kHintColor,
              ),
              iconSize: 20.0,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: kHintColor,
              ),
              iconSize: 20.0,
              onPressed: () => onTapDeleteItem(measure),
            ),
          ],
        ),
      );
    }).toList();

    return Container(
      color: kBorderSideColor.withOpacity(.5),
      child: Column(
        children: children,
      ),
    );
  }

  void onTapEditBlock(List<MeasureModel> measures) async {
    // final choice = await confirmDialog(
    //   context: context,
    //   content: Text("Are you sure?"),
    // );
    // if (choice == null || choice == false) {
    //   return;
    // }

    // final WriteBatch batch = CloudDb.instance.batch();

    // measures.forEach((measure) {
    //   batch.updateData(
    //     CloudDb.measurements.document(measure.id),
    //     measure.toMap(),
    //   );
    // });

    // showLoadingSnackBar();
    // try {
    //   await batch.commit();

    //   closeLoadingSnackBar();
    // } catch (e) {
    //   closeLoadingSnackBar();
    //   showInSnackBar(e.toString());
    // }
  }

  void onTapDeleteBlock(List<MeasureModel> measures) async {
    final choice = await confirmDialog(
      context: context,
      content: Text("Are you sure?"),
    );
    if (choice == null || choice == false) {
      return;
    }

    final WriteBatch batch = CloudDb.instance.batch();

    measures.forEach((measure) {
      batch.delete(
        CloudDb.measurements.document(measure.id),
      );
    });

    showLoadingSnackBar();
    try {
      await batch.commit();

      closeLoadingSnackBar();
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }

  void onTapEditItem(MeasureModel measure) async {
    final choice = await confirmDialog(
      context: context,
      content: Text("Are you sure?"),
    );
    if (choice == null || choice == false) {
      return;
    }

    showLoadingSnackBar();

    try {
      await measure.reference.updateData(<String, String>{
        "name": "",
        "unit": "",
      });
      closeLoadingSnackBar();
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }

  void onTapDeleteItem(MeasureModel measure) async {
    final choice = await confirmDialog(
      context: context,
      content: Text("Are you sure?"),
    );
    if (choice == null || choice == false) {
      return;
    }

    showLoadingSnackBar();

    try {
      await measure.reference.delete();
      closeLoadingSnackBar();
    } catch (e) {
      closeLoadingSnackBar();
      showInSnackBar(e.toString());
    }
  }
}
