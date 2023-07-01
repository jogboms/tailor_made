import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key, required this.payment});

  final PaymentEntity payment;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final String price = AppMoney(payment.price).formatted;
    final String? date = AppDate(payment.createdAt, day: 'EEEE', month: 'MMMM').formatted;

    return ViewModelSubscriber<AppState, ContactJobViewModel>(
      converter: (AppState store) => ContactJobViewModel(
        store,
        contactID: payment.contactID,
        jobID: payment.jobID,
      ),
      builder: (BuildContext context, __, ContactJobViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              if (vm.selectedJob case final JobEntity job)
                IconButton(
                  icon: const Icon(Icons.work),
                  onPressed: () => context.registry.get<JobsCoordinator>().toJob(job),
                ),
              if (vm.selectedContact?.id case final String contactId)
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () => context.registry.get<ContactsCoordinator>().toContact(contactId),
                ),
              if (vm.account!.hasPremiumEnabled)
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
        );
      },
    );
  }
}
