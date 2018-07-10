import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/contacts.dart';
import 'package:tailor_made/utils/tm_format_date.dart';
import 'package:tailor_made/utils/tm_format_naira.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class PaymentPage extends StatelessWidget {
  final PaymentModel payment;

  PaymentPage({
    Key key,
    @required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _price = formatNaira(payment.price);

    final date = formatDate(payment.createdAt, day: "EEEE", month: "MMMM");

    return new StoreConnector<ReduxState, ContactsViewModel>(
      converter: (store) => ContactsViewModel(store)..contactID = payment.contactID,
      builder: (BuildContext context, ContactsViewModel vm) {
        final contact = vm.selected;
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
                  color: titleBaseColor,
                ),
                // TODO
                onPressed: null,
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: titleBaseColor,
                ),
                onPressed: () => TMNavigate(context, Contact(contact: contact)),
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: titleBaseColor,
                ),
                // TODO
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
                child: Center(
                  child: Text(
                    _price,
                    style: ralewayLight(50.0, Colors.black87),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  date,
                  style: ralewayLight(14.0, Colors.black54),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  payment.notes,
                  style: ralewayLight(14.0, Colors.black54),
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
