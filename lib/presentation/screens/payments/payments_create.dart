import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
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
    final L10n l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.createPaymentPageTitle),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // TODO(jogboms): fix currency
                _Header(title: l10n.paymentPageTitle, trailing: l10n.currencyCaption('Naira', '₦')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _controller,
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: l10n.amountPlaceholder,
                    ),
                    validator: (String? value) {
                      if (_controller.numberValue > widget.limit) {
                        return l10n.amountRemainderMessage(AppMoney(widget.limit).formatted);
                      }
                      return (_controller.numberValue > 0) ? null : l10n.inputPriceMessage;
                    },
                    onSaved: (String? value) => _price = _controller.numberValue,
                  ),
                ),
                _Header(title: l10n.additionalNotesLabel),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: 6,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: l10n.additionalNotesPlaceholder,
                    ),
                    onSaved: (String? value) => _notes = value!.trim(),
                    onFieldSubmitted: (String value) => _handleSubmit(l10n),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
                  child: PrimaryButton(
                    onPressed: () => _handleSubmit(l10n),
                    child: Text(l10n.finishCaption),
                  ),
                ),
                const SizedBox(height: 32.0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit(L10n l10n) async {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true;
      AppSnackBar.of(context).info(l10n.fixFormErrors);
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle textStyle = theme.textTheme.bodySmallLight;

    return Container(
      color: colorScheme.outlineVariant.withOpacity(.14),
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title.toUpperCase(), style: textStyle),
          Text(trailing, style: textStyle),
        ],
      ),
    );
  }
}
