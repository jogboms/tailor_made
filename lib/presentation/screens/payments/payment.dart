import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
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
            iconTheme: const IconThemeData(color: Colors.black87),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              if (vm.selectedJob case final JobModel job)
                IconButton(
                  icon: const Icon(Icons.work, color: kTitleBaseColor),
                  onPressed: () => context.registry.get<JobsCoordinator>().toJob(job),
                ),
              if (vm.selectedContact case final ContactModel contact)
                IconButton(
                  icon: const Icon(Icons.person, color: kTitleBaseColor),
                  onPressed: () => context.registry.get<ContactsCoordinator>().toContact(contact),
                ),
              if (vm.account!.hasPremiumEnabled)
                const IconButton(
                  icon: Icon(Icons.share, color: kTitleBaseColor),
                  onPressed: null,
                ),
            ],
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 180.0,
                width: double.infinity,
                child: Center(child: Text(price, style: appFontLight(50.0, Colors.black87))),
              ),
              if (date != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(date, style: ThemeProvider.of(context)!.body3Light, textAlign: TextAlign.justify),
                ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(payment.notes, style: ThemeProvider.of(context)!.body3Light, textAlign: TextAlign.justify),
              ),
            ],
          ),
        );
      },
    );
  }
}
