import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/ui/full_button.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

enum CreateOptions {
  contacts,
  jobs,
}

class CreateButton extends StatefulWidget {
  final List<ContactModel> contacts;
  final double height;

  const CreateButton({
    Key key,
    @required this.contacts,
    @required this.height,
  }) : super(key: key);

  @override
  CreateButtonState createState() => new CreateButtonState();
}

class CreateButtonState extends State<CreateButton>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200))
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
        child: SizedBox(
          height: widget.height,
          child: FullButton(
            onPressed: _onTapCreate(context, widget.contacts),
            shape: RoundedRectangleBorder(),
            child: ScaleTransition(
              scale: new Tween(begin: 0.95, end: 1.025).animate(controller),
              alignment: FractionalOffset.center,
              child: new Text(
                "TAP TO CREATE",
                style: ralewayBold(14.0, Colors.white)
                    .copyWith(letterSpacing: 1.25),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Function() _onTapCreate(
      BuildContext context, List<ContactModel> contacts) {
    return () async {
      final CreateOptions result = await showDialog<CreateOptions>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('Select action',
                style: const TextStyle(fontSize: 14.0)),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(context, CreateOptions.contacts),
                child: TMListTile(
                  color: Colors.orangeAccent,
                  icon: Icons.supervisor_account,
                  title: "Contacts",
                ),
              ),
              new SimpleDialogOption(
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
          TMNavigate(context, ContactsCreatePage());
          break;
        case CreateOptions.jobs:
          TMNavigate(context, JobsCreatePage(contacts: contacts));
          break;
      }
    };
  }
}
