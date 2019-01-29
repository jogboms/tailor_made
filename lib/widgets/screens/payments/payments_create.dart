import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/utils/mk_snackbar_provider.dart';
import 'package:tailor_made/widgets/_partials/full_button.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';

class PaymentsCreatePage extends StatefulWidget {
  const PaymentsCreatePage({
    Key key,
    @required this.limit,
  }) : super(key: key);

  final double limit;

  @override
  _PaymentsCreatePageState createState() => _PaymentsCreatePageState();
}

class _PaymentsCreatePageState extends State<PaymentsCreatePage>
    with MkSnackBarProvider {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  double price = 0.0;
  String notes = "";
  MoneyMaskedTextController controller = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _additionFocusNode = FocusNode();

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _additionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

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
    return Scaffold(
      key: scaffoldKey,
      appBar: MkAppBar(
        title: Text("Create Payment"),
      ),
      body: Theme(
        data: ThemeData(
          hintColor: kHintColor,
          primaryColor: kPrimaryColor,
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: Column(
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
    return Container(
      color: Colors.grey[100].withOpacity(.4),
      margin: const EdgeInsets.only(top: 8.0),
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: mkFontLight(12.0, kTextBaseColor),
          ),
          Text(
            trailing,
            style: mkFontLight(12.0, kTextBaseColor),
          ),
        ],
      ),
    );
  }

  Widget buildEnterAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        focusNode: _amountFocusNode,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: InputDecoration(
          isDense: true,
          hintText: "Enter Amount",
          hintStyle: TextStyle(fontSize: 14.0),
        ),
        validator: (value) {
          if (controller.numberValue > widget.limit) {
            return MkMoney(widget.limit).format +
                " is the remainder on this job.";
          }
          return (controller.numberValue > 0) ? null : "Please input a price";
        },
        onSaved: (value) => price = controller.numberValue,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(_additionFocusNode),
      ),
    );
  }

  Widget buildAdditional() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        focusNode: _additionFocusNode,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        maxLines: 6,
        decoration: InputDecoration(
          isDense: true,
          hintText: "Anything else to remember this payment by?",
          hintStyle: TextStyle(fontSize: 14.0),
        ),
        onSaved: (value) => notes = value.trim(),
        onFieldSubmitted: (value) => _handleSubmit(),
      ),
    );
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar(MkStrings.fixErrors);
    } else {
      form.save();

      Navigator.pop(
        context,
        {"price": price, "notes": notes},
      );
    }
  }
}
