import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_primary_button.dart';
import 'package:tailor_made/widgets/screens/contacts/contacts_create.dart';
import 'package:tailor_made/widgets/screens/homepage/_partials/helpers.dart';
import 'package:tailor_made/widgets/screens/jobs/jobs_create.dart';

enum CreateOptions {
  contacts,
  jobs,
}

class CreateButton extends StatefulWidget {
  const CreateButton({
    Key key,
    @required this.contacts,
    @required this.height,
  }) : super(key: key);

  final List<ContactModel> contacts;
  final double height;

  @override
  _CreateButtonState createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1200))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          })
          ..forward();
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
      child: SafeArea(
        child: SizedBox.fromSize(
          size: Size.fromHeight(widget.height),
          child: MkPrimaryButton(
            onPressed: _onTapCreate(widget.contacts),
            shape: const RoundedRectangleBorder(),
            child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.025).animate(controller),
              alignment: FractionalOffset.center,
              child: Text(
                "TAP TO CREATE",
                style: MkTheme.of(context)
                    .body3Medium
                    .copyWith(color: Colors.white, letterSpacing: 1.25),
              ),
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback _onTapCreate(List<ContactModel> contacts) {
    return () async {
      final CreateOptions result = await showDialog<CreateOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'Select action',
              style: MkTheme.of(context).body3,
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, CreateOptions.contacts),
                child: TMListTile(
                  color: Colors.orangeAccent,
                  icon: Icons.supervisor_account,
                  title: "Contact",
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, CreateOptions.jobs),
                child: TMListTile(
                  color: Colors.greenAccent.shade400,
                  icon: Icons.attach_money,
                  title: "Job",
                ),
              ),
            ],
          );
        },
      );
      switch (result) {
        case CreateOptions.contacts:
          MkNavigate(context, const ContactsCreatePage());
          break;
        case CreateOptions.jobs:
          MkNavigate(context, JobsCreatePage(contacts: contacts));
          break;
      }
    };
  }
}
