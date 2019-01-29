import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/redux/view_models/contact_job.dart';
import 'package:tailor_made/utils/mk_dates.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/screens/contacts/contact.dart';
import 'package:tailor_made/widgets/screens/jobs/job.dart';

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

    return StoreConnector<AppState, ContactJobViewModel>(
      converter: (store) => ContactJobViewModel(store)
        ..contactID = payment.contactID
        ..jobID = payment.jobID,
      builder: (BuildContext context, ContactJobViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black87),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            brightness: Brightness.light,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.work,
                  color: kTitleBaseColor,
                ),
                onPressed: () =>
                    MkNavigate(context, JobPage(job: vm.selectedJob)),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: kTitleBaseColor,
                ),
                onPressed: () => MkNavigate(
                    context, ContactPage(contact: vm.selectedContact)),
              ),
              vm.account.hasPremiumEnabled
                  ? IconButton(
                      icon: Icon(
                        Icons.share,
                        color: kTitleBaseColor,
                      ),
                      // TODO
                      onPressed: null,
                    )
                  : SizedBox(),
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
                  style: mkFontLight(14.0, Colors.black54),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  payment.notes,
                  style: mkFontLight(14.0, Colors.black54),
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
