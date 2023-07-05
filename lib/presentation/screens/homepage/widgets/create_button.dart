import 'package:flutter/material.dart';
import 'package:tailor_made/presentation.dart';

import '../../../routing.dart';
import 'helpers.dart';

enum _CreateOptions { contacts, jobs }

class CreateButton extends StatefulWidget {
  const CreateButton({super.key});

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = context.l10n;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          useSafeArea: true,
          onPressed: _onTapCreate,
          shape: const RoundedRectangleBorder(),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.025).animate(_controller),
            alignment: FractionalOffset.center,
            child: Text(
              l10n.tapToCreateCaption,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.25),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapCreate() async {
    final AppRouter router = context.router;
    final _CreateOptions? result = await showDialog<_CreateOptions>(
      context: context,
      builder: (BuildContext context) {
        final L10n l10n = context.l10n;

        return SimpleDialog(
          title: Text(l10n.selectActionTitle, style: Theme.of(context).textTheme.labelLarge),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, _CreateOptions.contacts),
              child: TMListTile(
                color: Colors.orangeAccent,
                icon: Icons.supervisor_account,
                title: l10n.contactPageTitle,
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, _CreateOptions.jobs),
              child: TMListTile(
                color: Colors.greenAccent.shade400,
                icon: Icons.attach_money,
                title: l10n.jobPageTitle,
              ),
            ),
          ],
        );
      },
    );

    if (result == null) {
      return;
    }

    switch (result) {
      case _CreateOptions.contacts:
        router.toCreateContact();
        break;
      case _CreateOptions.jobs:
        router.toCreateJob(null);
        break;
    }
  }
}
