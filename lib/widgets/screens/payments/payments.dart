import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/services/payments.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/payments/_partials/payments_list.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({
    Key key,
    this.payments,
  }) : super(key: key);

  final List<PaymentModel> payments;

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
                stream: Payments.fetchAll(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<PaymentModel>> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const SliverFillRemaining(
                      child: const MkLoadingSpinner(),
                    );
                  }
                  return _Content(payments: snapshot.data);
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
        bottom: 16.0,
      ),
      sliver: PaymentList(payments: payments),
    );
  }
}
