import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:tailor_made/presentation/constants.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../theme.dart';

class PaymentsCreatePage extends StatefulWidget {
  const PaymentsCreatePage({
    super.key,
    required this.limit,
  });

  final double limit;

  @override
  State<PaymentsCreatePage> createState() => _PaymentsCreatePageState();
}

class _PaymentsCreatePageState extends State<PaymentsCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  double _price = 0.0;
  String _notes = '';
  final MoneyMaskedTextController _controller = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    children.add(const _Header(title: 'Payment', trailing: 'Naira (₦)'));
    children.add(_buildEnterAmount());

    children.add(const _Header(title: 'Additional Notes'));
    children.add(_buildAdditional());

    children.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        child: PrimaryButton(
          onPressed: _handleSubmit,
          child: const Text('FINISH'),
        ),
      ),
    );

    children.add(const SizedBox(height: 32.0));

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Create Payment'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
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
        controller: _controller,
        textInputAction: TextInputAction.next,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          isDense: true,
          hintText: 'Enter Amount',
        ),
        validator: (String? value) {
          if (_controller.numberValue > widget.limit) {
            return '${AppMoney(widget.limit).formatted} is the remainder on this job.';
          }
          return (_controller.numberValue > 0) ? null : 'Please input a price';
        },
        onSaved: (String? value) => _price = _controller.numberValue,
      ),
    );
  }

  Widget _buildAdditional() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        maxLines: 6,
        decoration: const InputDecoration(
          isDense: true,
          hintText: 'Anything else to remember this payment by?',
        ),
        onSaved: (String? value) => _notes = value!.trim(),
        onFieldSubmitted: (String value) => _handleSubmit(),
      ),
    );
  }

  void _handleSubmit() async {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true;
      AppSnackBar.of(context).info(AppStrings.fixErrors);
    } else {
      form.save();

      Navigator.pop(
        context,
        (price: _price, notes: _notes),
      );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    this.trailing = '',
  });

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100]!.withOpacity(.4),
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
