import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/utils/mk_phone.dart';
import 'package:tailor_made/widgets/_partials/mk_dots.dart';
import 'package:tailor_made/widgets/dependencies.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class ContactsListItem extends StatelessWidget {
  const ContactsListItem({Key key, this.contact, this.onTapContact, this.showActions = true}) : super(key: key);

  final ContactModel contact;
  final VoidCallback onTapContact;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context);

    final int pending = contact.pendingJobs;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      onTap: onTapContact ?? () => Dependencies.di().contactsCoordinator.toContact(contact),
      leading: _Avatar(contact: contact),
      title: Text(
        contact.fullname,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.subhead3Semi,
      ),
      subtitle: Text(
        pending >= 1 ? "$pending pending" : "${contact.totalJobs > 0 ? contact.totalJobs : 'none'} completed",
        style: theme.body3Hint,
      ),
      trailing: showActions
          ? IconButton(
              icon: const Icon(Icons.call),
              onPressed: () => call(contact.phone),
            )
          : null,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({Key key, @required this.contact}) : super(key: key);

  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: contact.id,
      child: CircleAvatar(
        radius: 24.0,
        backgroundColor: kPrimaryColor,
        backgroundImage: contact.imageUrl != null ? CachedNetworkImageProvider(contact.imageUrl) : null,
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(1.05, -1.05),
              child: contact.pendingJobs > 0 ? const MkDots(color: kAccentColor) : null,
            ),
            if (contact.imageUrl == null) const Center(child: Icon(Icons.person_outline, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
