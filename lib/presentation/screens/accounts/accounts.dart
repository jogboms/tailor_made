import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../utils.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final L10n l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.accountPageTitle),
      ),
      body: const Column(),
    );
  }
}
