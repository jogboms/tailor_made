import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
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
    void onTapGoBack() => Navigator.pop(context);

    Widget appBarLeading = new FlatButton(
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
            child: new CircleAvatar(
              radius: isAtTop ? 0.0 : null,
              backgroundColor: widget.contact.imageUrl != null ? Colors.grey.shade400 : Colors.white,
              backgroundImage: widget.contact.imageUrl != null ? NetworkImage(widget.contact.imageUrl) : null,
              child: widget.contact.imageUrl != null ? null : Center(child: Icon(Icons.person_outline)),
            ),
          ),
        ],
      ),
      onPressed: onTapGoBack,
    );

    Widget appBarTitle = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          widget.contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: new TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        isAtTop || (widget.contact.hasPending < 1)
            ? new Container()
            : new Text.rich(
                new TextSpan(
                  children: [
                    new TextSpan(
                      text: widget.contact.hasPending.toString(),
                      style: new TextStyle(fontWeight: FontWeight.w600),
                    ),
                    new TextSpan(
                      text: " pending wear-ables",
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  fontSize: 13.0,
                  color: Colors.white,
                ),
              ),
      ],
    );

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

    return new PreferredSize(
      preferredSize: new Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        top: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            appBarLeading,
            Expanded(
              child: appBarTitle,
            ),
            appBarIcon(
              icon: Icons.call,
              onTap: () {},
            ),
            appBarIcon(
              icon: Icons.message,
              onTap: () {},
            ),
            appBarIcon(
              icon: Icons.add,
              onTap: () {
                TMNavigate(context, JobsCreatePage(contact: widget.contact));
              },
            ),
          ],
        ),
      ),
    );
  }
}
