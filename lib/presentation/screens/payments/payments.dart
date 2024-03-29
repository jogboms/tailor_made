import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'providers/payments_provider.dart';
import 'widgets/payments_list.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key, this.payments = const <PaymentEntity>[], required this.userId});

  final List<PaymentEntity> payments;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final L10n l10n = context.l10n;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(l10n.paymentsPageTitle),
                if (payments.isNotEmpty)
                  Text(
                    l10n.ticketsCaption(payments.length),
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

              return Consumer(
                builder: (_, WidgetRef ref, Widget? child) => ref.watch(paymentsProvider).when(
                      skipLoadingOnReload: true,
                      data: (List<PaymentEntity> data) => _Content(payments: data),
                      error: (Object error, StackTrace stackTrace) => SliverFillRemaining(
                        child: ErrorView(error, stackTrace),
                      ),
                      loading: () => child!,
                    ),
                child: const SliverFillRemaining(child: LoadingSpinner()),
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
      return SliverFillRemaining(
        child: EmptyResultView(message: context.l10n.noPaymentsAvailableMessage),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 16.0),
      sliver: PaymentList(payments: payments),
    );
  }
}
