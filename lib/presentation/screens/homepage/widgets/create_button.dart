import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'helpers.dart';

enum _CreateOptions { contacts, jobs }

class CreateButton extends StatefulWidget {
  const CreateButton({super.key, required this.userId, required this.contacts});

  final List<ContactModel> contacts;
  final String userId;

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          useSafeArea: true,
          onPressed: _onTapCreate(widget.contacts),
          shape: const RoundedRectangleBorder(),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.025).animate(controller),
            alignment: FractionalOffset.center,
            child: Text(
              'TAP TO CREATE',
              style: ThemeProvider.of(context)!.body3Medium.copyWith(color: Colors.white, letterSpacing: 1.25),
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback _onTapCreate(List<ContactModel> contacts) {
    return () async {
      final Registry registry = context.registry;
      final _CreateOptions? result = await showDialog<_CreateOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select action', style: ThemeProvider.of(context)!.body3),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, _CreateOptions.contacts),
                child: const TMListTile(color: Colors.orangeAccent, icon: Icons.supervisor_account, title: 'Contact'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, _CreateOptions.jobs),
                child: TMListTile(color: Colors.greenAccent.shade400, icon: Icons.attach_money, title: 'Job'),
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
          registry.get<ContactsCoordinator>().toCreateContact(widget.userId);
          break;
        case _CreateOptions.jobs:
          registry.get<JobsCoordinator>().toCreateJob(widget.userId, contacts);
          break;
      }
    };
  }
}