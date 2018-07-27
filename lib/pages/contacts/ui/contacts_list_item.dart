import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_phone.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsListItem extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTapContact;
  final bool showActions;

  const ContactsListItem({
    Key key,
    this.contact,
    this.onTapContact,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    final int pending = contact.pendingJobs;

    return ListTile(
      dense: true,
      onTap: onTapContact ??
          () => TMNavigate(context, ContactPage(contact: contact)),
      leading: avatar(theme),
      title: new Text(
        contact.fullname,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.0,
          color: theme.textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        pending >= 1
            ? "$pending pending"
            : "${contact.totalJobs > 0 ? contact.totalJobs : 'none'} completed",
        style: TextStyle(fontSize: 14.0, color: kTextBaseColor),
      ),
      trailing: showActions
          ? iconCircle(Icons.call, () => call(contact.phone))
          : null,
    );
  }

  Widget iconCircle(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: new Icon(icon, size: 22.0),
      onPressed: onTap,
    );
  }

  Hero avatar(TMTheme theme) {
    return new Hero(
      tag: contact.id,
      child: new CircleAvatar(
        radius: 24.0,
        backgroundColor: theme.primaryColor,
        backgroundImage: contact.imageUrl != null
            ? CachedNetworkImageProvider(contact.imageUrl)
            : null,
        child: Stack(
          children: [
            new Align(
              alignment: Alignment(1.05, -1.05),
              child: contact.pendingJobs > 0
                  ? new Container(
                      width: 15.5,
                      height: 15.5,
                      decoration: new BoxDecoration(
                        color: theme.accentColor,
                        border: Border.all(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 2.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            contact.imageUrl != null
                ? SizedBox()
                : Center(
                    child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  )),
          ],
        ),
      ),
    );
  }
}
