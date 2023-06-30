import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/payments_list.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key, this.payments = const <PaymentEntity>[], required this.userId});

  final List<PaymentEntity> payments;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Payments'),
                if (payments.isNotEmpty)
                  Text(
                    '${payments.length} Tickets',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
              ],
            ),
            automaticallyImplyLeading: false,
            leading: const AppBackButton(),
            centerTitle: false,
            floating: true,
          ),
          Builder(
            builder: (BuildContext context) {
              if (payments.isNotEmpty) {
                return _Content(payments: payments);
              }

              return StreamBuilder<List<PaymentEntity>>(
                // TODO(Jogboms): move this out of here
                stream: context.registry.get<Payments>().fetchAll(userId),
                builder: (_, AsyncSnapshot<List<PaymentEntity>> snapshot) {
                  final List<PaymentEntity>? data = snapshot.data;
                  if (data == null) {
                    return const SliverFillRemaining(child: LoadingSpinner());
                  }
                  return _Content(payments: data);
                },
              );
            },
          )
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.payments});

  final List<PaymentEntity> payments;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyResultView(message: 'No payments available'),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 16.0),
      sliver: PaymentList(payments: payments),
    );
  }
}
