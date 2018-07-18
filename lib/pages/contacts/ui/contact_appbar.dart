import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/contacts_edit.dart';
import 'package:tailor_made/pages/contacts/ui/contact_measure.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/pages/jobs/ui/measures.dart';
import 'package:tailor_made/ui/circle_avatar.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_phone.dart';
import 'package:tailor_made/utils/tm_theme.dart';

enum Choice {
  CreateJob,
  EditMeasure,
  EditAccount,
  SendText,
}

class ContactAppBar extends StatefulWidget {
  final ContactModel contact;

  const ContactAppBar({
    Key key,
    this.contact,
  }) : super(key: key);

  @override
  ContactAppBarState createState() {
    return new ContactAppBarState();
  }
}

class ContactAppBarState extends State<ContactAppBar> {
  dynamic _selectChoice(Choice choice) {
    switch (choice) {
      case Choice.CreateJob:
        return TMNavigate(
          context,
          JobsCreatePage(contact: widget.contact, contacts: []),
        );
      case Choice.EditMeasure:
        return TMNavigate(
          context,
          ContactMeasure(contact: widget.contact),
        );
      case Choice.EditAccount:
        return TMNavigate(
          context,
          ContactsEditPage(contact: widget.contact),
        );
      case Choice.SendText:
        return sms(int.parse(widget.contact.phone));
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new PreferredSize(
      preferredSize: new Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        top: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            appBarLeading(),
            Expanded(child: appBarTitle()),
            appBarIcon(
              icon: Icons.content_cut,
              onTap: () => TMNavigate(
                    context,
                    MeasuresPage(measurements: widget.contact.measurements),
                    fullscreenDialog: true,
                  ),
            ),
            appBarIcon(
              icon: Icons.call,
              onTap: () => call(int.parse(widget.contact.phone)),
            ),
            new PopupMenuButton<Choice>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: _selectChoice,
              itemBuilder: (BuildContext context) => [
                    new PopupMenuItem<Choice>(
                      value: Choice.CreateJob,
                      child: new Text('New Job',
                          style: ralewayRegular(14.0, Colors.black87)),
                    ),
                    new PopupMenuItem<Choice>(
                      value: Choice.SendText,
                      child: new Text('Text Message',
                          style: ralewayRegular(14.0, Colors.black87)),
                    ),
                    new PopupMenuItem<Choice>(
                      value: Choice.EditMeasure,
                      child: new Text('Edit Measurements',
                          style: ralewayRegular(14.0, Colors.black87)),
                    ),
                    new PopupMenuItem<Choice>(
                      value: Choice.EditAccount,
                      child: new Text('Edit Account',
                          style: ralewayRegular(14.0, Colors.black87)),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }

  Widget appBarLeading() {
    return new FlatButton(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          new SizedBox(width: 4.0),
          new Hero(
            tag: widget.contact.id,
            child: circleAvatar(
              radius: null,
              imageUrl: widget.contact.imageUrl,
              useAlt: true,
            ),
          ),
        ],
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget appBarTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          widget.contact.location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget appBarIcon({IconData icon, VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkResponse(
        child: new Icon(icon, color: Colors.white),
        onTap: onTap,
        radius: 20.0,
      ),
    );
  }
}
