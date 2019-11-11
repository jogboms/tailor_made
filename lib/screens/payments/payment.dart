import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/contact_job_view_model.dart';
import 'package:tailor_made/screens/contacts/contact.dart';
import 'package:tailor_made/screens/jobs/job.dart';
import 'package:tailor_made/utils/mk_dates.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({
    Key key,
    @required this.payment,
  }) : super(key: key);

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final _price = MkMoney(payment.price).format;

    final date = MkDates(payment.createdAt, day: "EEEE", month: "MMMM").format;

    return ViewModelSubscriber<AppState, ContactJobViewModel>(
      converter: (store) => ContactJobViewModel(store)
        ..contactID = payment.contactID
        ..jobID = payment.jobID,
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        ContactJobViewModel vm,
      ) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black87),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            brightness: Brightness.light,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.work,
                  color: kTitleBaseColor,
                ),
                onPressed: () {
                  MkNavigate(context, JobPage(job: vm.selectedJob));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: kTitleBaseColor,
                ),
                onPressed: () {
                  MkNavigate(
                    context,
                    ContactPage(contact: vm.selectedContact),
                  );
                },
              ),
              vm.account.hasPremiumEnabled
                  ? IconButton(
                      icon: const Icon(
                        Icons.share,
                        color: kTitleBaseColor,
                      ),
                      // TODO
                      onPressed: null,
                    )
                  : const SizedBox(),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 180.0,
                width: double.infinity,
                child: Center(
                  child: Text(
                    _price,
                    style: mkFontLight(50.0, Colors.black87),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  date,
                  style: ThemeProvider.of(context).body3Light,
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  payment.notes,
                  style: ThemeProvider.of(context).body3Light,
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
