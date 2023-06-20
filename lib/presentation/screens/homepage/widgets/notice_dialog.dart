import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/theme.dart';

class NoticeDialog extends StatelessWidget {
  const NoticeDialog({super.key, required this.account});

  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    final TextStyle textTheme = ThemeProvider.of(context)!.subhead1;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 32.0),
              const CircleAvatar(
                backgroundColor: kAccentColor,
                foregroundColor: Colors.white,
                radius: 24.0,
                child: Icon(Icons.notifications_none, size: 36.0),
              ),
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  account.notice,
                  style: textTheme.copyWith(color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }
}
