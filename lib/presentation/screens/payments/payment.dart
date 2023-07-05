import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key, required this.payment});

  final PaymentEntity payment;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final String price = AppMoney(payment.price).formatted;
    final String? date = AppDate(payment.createdAt, day: 'EEEE', month: 'MMMM').formatted;

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) =>
          ref.watch(selectedContactJobProvider(contactId: payment.contactID, jobId: payment.jobID)).when(
                skipLoadingOnReload: true,
                data: (ContactJobState state) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.work),
                        onPressed: () => context.router.toJob(state.selectedJob),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () => context.router.toContact(state.selectedContact.id),
                      ),
                      if (state.account.hasPremiumEnabled)
                        const IconButton(
                          icon: Icon(Icons.share),
                          onPressed: null,
                        ),
                    ],
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 180.0,
                        width: double.infinity,
                        child: Center(child: Text(price, style: textTheme.displayMedium)),
                      ),
                      if (date != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            date,
                            style: textTheme.labelLarge?.copyWith(fontWeight: AppFontWeight.light),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          payment.notes,
                          style: textTheme.labelLarge?.copyWith(fontWeight: AppFontWeight.light),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                error: ErrorView.new,
                loading: () => child!,
              ),
      child: const Center(child: LoadingSpinner()),
    );
  }
}
