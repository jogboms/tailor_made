import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.account});

  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 40.0),
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(bottom: AppBorderSide())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text('Hello', style: Theme.of(context).display4Light.copyWith(letterSpacing: 2.5)),
          Text(
            account.storeName.split(' ').first,
            style: const TextStyle(fontSize: 52.0, fontWeight: AppFontWeight.regular, height: 1.15),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          Text(
            AppDate(clock.now(), day: 'EEEE', month: 'MMMM').formatted!,
            style: Theme.of(context).body3.copyWith(height: 1.75),
          ),
        ],
      ),
    );
  }
}
