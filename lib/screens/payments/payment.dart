import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/contact_job_view_model.dart';
import 'package:tailor_made/utils/mk_dates.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key, required this.payment});

  final PaymentModel? payment;

  @override
  Widget build(BuildContext context) {
    final String price = MkMoney(payment!.price).formatted;

    final String? date = MkDates(payment!.createdAt, day: 'EEEE', month: 'MMMM').formatted;

    return ViewModelSubscriber<AppState, ContactJobViewModel>(
      converter: (AppState store) => ContactJobViewModel(store)
        ..contactID = payment!.contactID
        ..jobID = payment!.jobID,
      builder: (BuildContext context, __, ContactJobViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black87),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.work, color: kTitleBaseColor),
                onPressed: () => Dependencies.di().jobsCoordinator.toJob(vm.selectedJob),
              ),
              IconButton(
                icon: const Icon(Icons.person, color: kTitleBaseColor),
                onPressed: () => Dependencies.di().contactsCoordinator.toContact(vm.selectedContact),
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
                child: Center(child: Text(price, style: mkFontLight(50.0, Colors.black87))),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(date!, style: ThemeProvider.of(context)!.body3Light, textAlign: TextAlign.justify),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(payment!.notes, style: ThemeProvider.of(context)!.body3Light, textAlign: TextAlign.justify),
              ),
            ],
          ),
        );
      },
    );
  }
}
