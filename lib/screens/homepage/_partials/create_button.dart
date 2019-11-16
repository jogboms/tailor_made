import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/screens/homepage/_partials/helpers.dart';
import 'package:tailor_made/widgets/_partials/mk_primary_button.dart';
import 'package:tailor_made/widgets/dependencies.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

enum _CreateOptions { contacts, jobs }

class CreateButton extends StatefulWidget {
  const CreateButton({Key key, @required this.contacts}) : super(key: key);

  final List<ContactModel> contacts;

  @override
  _CreateButtonState createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> with SingleTickerProviderStateMixin {
  AnimationController controller;

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
        child: MkPrimaryButton(
          useSafeArea: true,
          onPressed: _onTapCreate(widget.contacts),
          shape: const RoundedRectangleBorder(),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.025).animate(controller),
            alignment: FractionalOffset.center,
            child: Text(
              "TAP TO CREATE",
              style: ThemeProvider.of(context).body3Medium.copyWith(color: Colors.white, letterSpacing: 1.25),
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback _onTapCreate(List<ContactModel> contacts) {
    return () async {
      final _CreateOptions result = await showDialog<_CreateOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select action', style: ThemeProvider.of(context).body3),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, _CreateOptions.contacts),
                child: TMListTile(color: Colors.orangeAccent, icon: Icons.supervisor_account, title: "Contact"),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, _CreateOptions.jobs),
                child: TMListTile(color: Colors.greenAccent.shade400, icon: Icons.attach_money, title: "Job"),
              ),
            ],
          );
        },
      );
      switch (result) {
        case _CreateOptions.contacts:
          Dependencies.di().contactsCoordinator.toCreateContact();
          break;
        case _CreateOptions.jobs:
          Dependencies.di().jobsCoordinator.toCreateJob(contacts);
          break;
      }
    };
  }
}
