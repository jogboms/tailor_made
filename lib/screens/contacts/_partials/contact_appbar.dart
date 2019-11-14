import 'package:flutter/material.dart';
import 'package:tailor_made/coordinator/contacts_coordinator.dart';
import 'package:tailor_made/coordinator/jobs_coordinator.dart';
import 'package:tailor_made/coordinator/measures_coordinator.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/utils/mk_phone.dart';
import 'package:tailor_made/widgets/_partials/mk_circle_avatar.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

enum Choice { CreateJob, EditMeasure, EditAccount, SendText }

class ContactAppBar extends StatefulWidget {
  const ContactAppBar({Key key, @required this.grouped, this.contact}) : super(key: key);

  final Map<String, List<MeasureModel>> grouped;
  final ContactModel contact;

  @override
  _ContactAppBarState createState() => _ContactAppBarState();
}

class _ContactAppBarState extends State<ContactAppBar> {
  void _selectChoice(Choice choice) {
    switch (choice) {
      case Choice.CreateJob:
        JobsCoordinator.di().toCreateJob([], widget.contact);
        break;
      case Choice.EditMeasure:
        ContactsCoordinator.di().toContactMeasure(widget.contact, widget.grouped);
        break;
      case Choice.EditAccount:
        ContactsCoordinator.di().toContactEdit(widget.contact);
        break;
      case Choice.SendText:
        sms(widget.contact.phone);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _popTextStyle = ThemeProvider.of(context).body1;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        top: true,
        child: Row(
          children: <Widget>[
            _Leading(contact: widget.contact),
            Expanded(child: _Title(contact: widget.contact)),
            _Icon(
              icon: Icons.content_cut,
              onTap: () => MeasuresCoordinator.di().toMeasures(widget.contact.measurements.toMap()),
            ),
            _Icon(icon: Icons.call, onTap: () => call(widget.contact.phone)),
            PopupMenuButton<Choice>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: _selectChoice,
              itemBuilder: (_) {
                return [
                  PopupMenuItem<Choice>(
                    value: Choice.CreateJob,
                    child: Text('New Job', style: _popTextStyle),
                  ),
                  PopupMenuItem<Choice>(
                    value: Choice.SendText,
                    child: Text('Text Message', style: _popTextStyle),
                  ),
                  PopupMenuItem<Choice>(
                    value: Choice.EditMeasure,
                    child: Text('Edit Measurements', style: _popTextStyle),
                  ),
                  PopupMenuItem<Choice>(
                    value: Choice.EditAccount,
                    child: Text('Edit Account', style: _popTextStyle),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({Key key, @required this.icon, @required this.onTap}) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkResponse(child: Icon(icon, color: Colors.white), onTap: onTap, radius: 20.0),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key key, @required this.contact}) : super(key: key);

  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.title.copyWith(color: Colors.white),
        ),
        Text(
          contact.location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.body1.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({Key key, @required this.contact}) : super(key: key);

  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.arrow_back, color: Colors.white),
          const SizedBox(width: 4.0),
          Hero(
            tag: contact.id,
            child: MkCircleAvatar(radius: null, imageUrl: contact.imageUrl, useAlt: true),
          ),
        ],
      ),
      onPressed: () => Navigator.maybePop(context),
    );
  }
}
