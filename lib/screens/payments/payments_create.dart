import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/providers/snack_bar_provider.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_primary_button.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class PaymentsCreatePage extends StatefulWidget {
  const PaymentsCreatePage({
    Key key,
    @required this.limit,
  }) : super(key: key);

  final double limit;

  @override
  _PaymentsCreatePageState createState() => _PaymentsCreatePageState();
}

class _PaymentsCreatePageState extends State<PaymentsCreatePage> with SnackBarProviderMixin {
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

    children.add(const _Header(title: "Payment", trailing: "Naira (₦)"));
    children.add(_buildEnterAmount());

    children.add(const _Header(title: "Additional Notes"));
    children.add(_buildAdditional());

    children.add(
      Padding(
        child: MkPrimaryButton(
          child: const Text("FINISH"),
          onPressed: _handleSubmit,
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
      ),
    );

    children.add(const SizedBox(height: 32.0));

    return Scaffold(
      key: scaffoldKey,
      appBar: const MkAppBar(
        title: Text("Create Payment"),
      ),
      body: SafeArea(
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
    );
  }

  Widget _buildEnterAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        focusNode: _amountFocusNode,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          isDense: true,
          hintText: "Enter Amount",
        ),
        validator: (value) {
          if (controller.numberValue > widget.limit) {
            return MkMoney(widget.limit).formatted + " is the remainder on this job.";
          }
          return (controller.numberValue > 0) ? null : "Please input a price";
        },
        onSaved: (value) => price = controller.numberValue,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_additionFocusNode),
      ),
    );
  }

  Widget _buildAdditional() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        focusNode: _additionFocusNode,
        keyboardType: TextInputType.text,
        maxLines: 6,
        decoration: const InputDecoration(
          isDense: true,
          hintText: "Anything else to remember this payment by?",
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

class _Header extends StatelessWidget {
  const _Header({
    Key key,
    @required this.title,
    this.trailing = "",
  }) : super(key: key);

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100].withOpacity(.4),
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: ThemeProvider.of(context).smallLight,
          ),
          Text(
            trailing,
            style: ThemeProvider.of(context).smallLight,
          ),
        ],
      ),
    );
  }
}
