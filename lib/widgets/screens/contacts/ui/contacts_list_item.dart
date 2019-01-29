import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_phone.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/screens/contacts/contact.dart';

class ContactsListItem extends StatelessWidget {
  const ContactsListItem({
    Key key,
    this.contact,
    this.onTapContact,
    this.showActions = true,
  }) : super(key: key);

  final ContactModel contact;
  final VoidCallback onTapContact;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    final int pending = contact.pendingJobs;

    return ListTile(
      dense: true,
      onTap: onTapContact ??
          () => MkNavigate(context, ContactPage(contact: contact)),
      leading: avatar(theme),
      title: Text(
        contact.fullname,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.0,
          color: kTextBaseColor,
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
      icon: Icon(icon, size: 22.0),
      onPressed: onTap,
    );
  }

  Hero avatar(MkTheme theme) {
    return Hero(
      tag: contact.id,
      child: CircleAvatar(
        radius: 24.0,
        backgroundColor: kPrimaryColor,
        backgroundImage: contact.imageUrl != null
            ? CachedNetworkImageProvider(contact.imageUrl)
            : null,
        child: Stack(
          children: [
            Align(
              alignment: Alignment(1.05, -1.05),
              child: contact.pendingJobs > 0
                  ? Container(
                      width: 15.5,
                      height: 15.5,
                      decoration: BoxDecoration(
                        color: kAccentColor,
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
