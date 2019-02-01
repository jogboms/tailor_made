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
      leading: _Avatar(contact: contact),
      title: Text(
        contact.fullname,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.subhead3,
      ),
      subtitle: Text(
        pending >= 1
            ? "$pending pending"
            : "${contact.totalJobs > 0 ? contact.totalJobs : 'none'} completed",
        style: theme.body3,
      ),
      trailing: showActions
          ? IconButton(
              icon: const Icon(Icons.call, size: 22.0),
              onPressed: () => call(contact.phone),
            )
          : null,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    Key key,
    @required this.contact,
  }) : super(key: key);

  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
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
              alignment: const Alignment(1.05, -1.05),
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
                ? const SizedBox()
                : const Center(
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
