import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/accounts/ui/measures_create.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_navigate.dart';

class AccountMeasuresPage extends StatelessWidget {
  final AccountModel account;

  const AccountMeasuresPage({
    Key key,
    @required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return Scaffold(
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

        final list = List<DocumentSnapshot>.from(snapshot.data.documents)
            .map((DocumentSnapshot doc) => MeasureModel.fromDoc(doc))
            .toList();

        //
        return SizedBox();
      },
    );
  }

  Widget _comingSoon(TextStyle textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SpinKitFadingCube(
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 48.0),
          Text(
            "COMING SOON",
            style: textTheme.copyWith(
                color: Colors.black87, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.0),
        ],
      ),
    );
  }
}
