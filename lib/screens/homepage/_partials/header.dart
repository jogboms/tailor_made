import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/utils/mk_dates.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.account});

  final AccountModel? account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 40.0),
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(bottom: MkBorderSide())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text('Hello', style: ThemeProvider.of(context)!.display4Light.copyWith(letterSpacing: 2.5)),
          Text(
            account!.storeName.split(' ').first,
            style: const TextStyle(fontSize: 52.0, fontWeight: MkStyle.regular, height: 1.15),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          Text(
            MkDates(DateTime.now(), day: 'EEEE', month: 'MMMM').formatted!,
            style: ThemeProvider.of(context)!.body3.copyWith(height: 1.75),
          ),
        ],
      ),
    );
  }
}
