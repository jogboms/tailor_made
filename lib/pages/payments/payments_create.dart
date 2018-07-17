import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/full_button.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class PaymentsCreatePage extends StatefulWidget {
  PaymentsCreatePage({Key key}) : super(key: key);

  @override
  _PaymentsCreatePageState createState() => new _PaymentsCreatePageState();
}

class _PaymentsCreatePageState extends State<PaymentsCreatePage> with SnackBarProvider {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  double price = 0.0;
  String notes = "";
  MoneyMaskedTextController controller = new MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    List<Widget> children = [];

    children.add(makeHeader("Payment", "Naira (₦)"));
    children.add(buildEnterAmount());

    children.add(makeHeader("Additional Notes"));
    children.add(buildAdditional());

    children.add(
      Padding(
        child: FullButton(
          child: Text(
            "FINISH",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _handleSubmit,
        ),
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 50.0),
      ),
    );

    children.add(SizedBox(height: 32.0));
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Create Payment",
      ),
      body: Theme(
        data: ThemeData(
          hintColor: kBorderSideColor,
          primaryColor: kPrimaryColor,
        ),
        child: new SafeArea(
          top: false,
          child: new SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeHeader(String title, [String trailing = ""]) {
    return new Container(
      color: Colors.grey[100].withOpacity(.4),
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      alignment: AlignmentDirectional.centerStart,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title.toUpperCase(), style: ralewayLight(12.0, kTextBaseColor.shade800)),
          Text(trailing, style: ralewayLight(12.0, kTextBaseColor.shade800)),
        ],
      ),
    );
  }

  Widget buildEnterAmount() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: new TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: new InputDecoration(
          isDense: true,
          hintText: "Enter Amount",
          hintStyle: TextStyle(fontSize: 14.0),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: kBorderSideColor,
              width: 0.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        validator: (value) => (controller.numberValue > 0) ? null : "Please input a price",
        onSaved: (value) => price = controller.numberValue,
      ),
    );
  }

  Widget buildAdditional() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: new TextFormField(
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        maxLines: 6,
        decoration: new InputDecoration(
          isDense: true,
          hintText: "Anything else to remember this payment by?",
          hintStyle: TextStyle(fontSize: 14.0),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: kBorderSideColor,
              width: 0.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        onSaved: (value) => notes = value.trim(),
      ),
    );
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();

      Navigator.pop(
        context,
        {"price": price, "notes": notes},
      );
    }
  }
}
