import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

enum Choice { createJob, editMeasure, editAccount, sendText }

class ContactAppBar extends StatefulWidget {
  const ContactAppBar({
    super.key,
    required this.grouped,
    required this.contact,
  });

  final Map<MeasureGroup, List<MeasureEntity>> grouped;
  final ContactEntity contact;

  @override
  State<ContactAppBar> createState() => _ContactAppBarState();
}

class _ContactAppBarState extends State<ContactAppBar> {
  void _selectChoice(Choice choice) {
    final AppRouter router = context.router;
    switch (choice) {
      case Choice.createJob:
        router.toCreateJob(widget.contact.id);
        break;
      case Choice.editMeasure:
        router.toContactMeasure(contact: widget.contact, grouped: widget.grouped);
        break;
      case Choice.editAccount:
        router.toContactEdit(widget.contact);
        break;
      case Choice.sendText:
        sms(widget.contact.phone);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle popTextStyle = Theme.of(context).textTheme.bodyMedium!;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Row(
        children: <Widget>[
          _Leading(contact: widget.contact),
          Expanded(child: _Title(contact: widget.contact)),
          _Icon(
            icon: Icons.content_cut,
            onTap: () => context.router.toMeasures(widget.contact.measurements),
          ),
          _Icon(icon: Icons.call, onTap: () => call(widget.contact.phone)),
          PopupMenuButton<Choice>(
            icon: const Icon(Icons.more_vert),
            onSelected: _selectChoice,
            itemBuilder: (_) {
              return <PopupMenuItem<Choice>>[
                PopupMenuItem<Choice>(
                  value: Choice.createJob,
                  child: Text('New Job', style: popTextStyle),
                ),
                PopupMenuItem<Choice>(
                  value: Choice.sendText,
                  child: Text('Text Message', style: popTextStyle),
                ),
                PopupMenuItem<Choice>(
                  value: Choice.editMeasure,
                  child: Text('Edit Measurements', style: popTextStyle),
                ),
                PopupMenuItem<Choice>(
                  value: Choice.editAccount,
                  child: Text('Edit Account', style: popTextStyle),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkResponse(onTap: onTap, radius: 20.0, child: Icon(icon)),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.contact});

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.pageTitle,
        ),
        Text(
          contact.location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({required this.contact});

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.arrow_back),
          const SizedBox(width: 4.0),
          Hero(
            tag: contact.id,
            child: AppCircleAvatar(imageUrl: contact.imageUrl, useAlt: true),
          ),
        ],
      ),
      onPressed: () => Navigator.maybePop(context),
    );
  }
}
