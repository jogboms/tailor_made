import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/widgets.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Account'),
      ),
      body: Column(),
    );
  }
}
