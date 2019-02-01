import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/payments/_partials/payments_list.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({
    Key key,
    this.payments,
  }) : super(key: key);

  final List<PaymentModel> payments;

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  List<PaymentModel> payments;

  @override
  void initState() {
    payments = widget.payments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Payments", style: theme.appBarTitle),
                payments != null
                    ? Text(
                        "${payments.length} Tickets",
                        style: MkTheme.of(context).xsmall,
                      )
                    : const SizedBox(),
              ],
            ),
            backgroundColor: kAppBarBackgroundColor,
            automaticallyImplyLeading: false,
            leading: const MkBackButton(),
            forceElevated: true,
            brightness: Brightness.light,
            elevation: 1.0,
            centerTitle: false,
            floating: true,
          ),
          Builder(builder: (context) {
            if (payments == null) {
              return StreamBuilder(
                stream: CloudDb.payments.snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const SliverFillRemaining(
                      child: const MkLoadingSpinner(),
                    );
                  }
                  payments = snapshot.data.documents
                      .map((item) => PaymentModel.fromJson(item.data))
                      .toList();
                  return _Content(payments: payments);
                },
              );
            }
            return _Content(payments: payments);
          })
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key key,
    @required this.payments,
  }) : super(key: key);

  final List<PaymentModel> payments;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const SliverFillRemaining(
        child: const EmptyResultView(message: "No payments available"),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 3.0,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      sliver: PaymentList(payments: payments),
    );
  }
}
