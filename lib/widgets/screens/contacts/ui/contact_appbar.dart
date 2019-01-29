import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_phone.dart';
import 'package:tailor_made/widgets/_partials/mk_circle_avatar.dart';
import 'package:tailor_made/widgets/screens/contacts/contacts_edit.dart';
import 'package:tailor_made/widgets/screens/contacts/ui/contact_measure.dart';
import 'package:tailor_made/widgets/screens/jobs/jobs_create.dart';
import 'package:tailor_made/widgets/screens/measures/measures.dart';

enum Choice {
  CreateJob,
  EditMeasure,
  EditAccount,
  SendText,
}

class ContactAppBar extends StatefulWidget {
  const ContactAppBar({
    Key key,
    @required this.grouped,
    this.contact,
  }) : super(key: key);

  final Map<String, List<MeasureModel>> grouped;
  final ContactModel contact;

  @override
  ContactAppBarState createState() {
    return ContactAppBarState();
  }
}

class ContactAppBarState extends State<ContactAppBar> {
  dynamic _selectChoice(Choice choice) {
    switch (choice) {
      case Choice.CreateJob:
        return MkNavigate(
          context,
          JobsCreatePage(contact: widget.contact, contacts: []),
        );
      case Choice.EditMeasure:
        return MkNavigate(
          context,
          ContactMeasure(
            contact: widget.contact,
            grouped: widget.grouped,
          ),
        );
      case Choice.EditAccount:
        return MkNavigate(
          context,
          ContactsEditPage(contact: widget.contact),
        );
      case Choice.SendText:
        return sms(widget.contact.phone);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
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
              onTap: () => MkNavigate(
                    context,
                    MeasuresPage(measurements: widget.contact.measurements),
                    fullscreenDialog: true,
                  ),
            ),
            appBarIcon(
              icon: Icons.call,
              onTap: () => call(widget.contact.phone),
            ),
            PopupMenuButton<Choice>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: _selectChoice,
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem<Choice>(
                      value: Choice.CreateJob,
                      child: Text('New Job',
                          style: mkFontRegular(14.0, Colors.black87)),
                    ),
                    PopupMenuItem<Choice>(
                      value: Choice.SendText,
                      child: Text('Text Message',
                          style: mkFontRegular(14.0, Colors.black87)),
                    ),
                    PopupMenuItem<Choice>(
                      value: Choice.EditMeasure,
                      child: Text('Edit Measurements',
                          style: mkFontRegular(14.0, Colors.black87)),
                    ),
                    PopupMenuItem<Choice>(
                      value: Choice.EditAccount,
                      child: Text('Edit Account',
                          style: mkFontRegular(14.0, Colors.black87)),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }

  Widget appBarLeading() {
    return FlatButton(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          SizedBox(width: 4.0),
          Hero(
            tag: widget.contact.id,
            child: MkCircleAvatar(
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
        child: Icon(icon, color: Colors.white),
        onTap: onTap,
        radius: 20.0,
      ),
    );
  }
}
