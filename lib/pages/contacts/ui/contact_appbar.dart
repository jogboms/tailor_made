import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/ui/circle_avatar.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_phone.dart';
import 'package:tailor_made/utils/tm_theme.dart';

enum Choice {
  CreateJob,
}

class ContactAppBar extends StatefulWidget {
  final ContactModel contact;

  ContactAppBar({
    Key key,
    this.contact,
  }) : super(key: key);

  @override
  ContactAppBarState createState() {
    return new ContactAppBarState();
  }
}

class ContactAppBarState extends State<ContactAppBar> {
  bool isAtTop = false;

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
              icon: Icons.call,
              onTap: () => call(int.parse(widget.contact.phone)),
            ),
            appBarIcon(
              icon: Icons.message,
              onTap: () => sms(int.parse(widget.contact.phone)),
            ),
            appBarIcon(
              icon: Icons.add,
              onTap: () {
                TMNavigate(
                  context,
                  JobsCreatePage(contact: widget.contact, contacts: []),
                );
              },
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
          new SizedBox(width: isAtTop ? 0.0 : 4.0),
          new Hero(
            tag: widget.contact.documentID,
            child: circleAvatar(
              radius: isAtTop ? 0.0 : null,
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
            fontWeight: FontWeight.w500,
          ),
        ),
        isAtTop || (widget.contact.pendingJobs < 1)
            ? Container()
            : Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.contact.pendingJobs.toString(),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: " pending",
                    ),
                  ],
                ),
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
        splashColor: accentColor.withOpacity(.25),
      ),
    );
  }
}
