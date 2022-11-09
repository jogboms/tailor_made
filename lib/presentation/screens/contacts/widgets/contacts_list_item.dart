import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class ContactsListItem extends StatelessWidget {
  const ContactsListItem({super.key, this.contact, this.onTapContact, this.showActions = true});

  final ContactModel? contact;
  final VoidCallback? onTapContact;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context)!;

    final int pending = contact!.pendingJobs;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      onTap: onTapContact ?? () => context.registry.get<ContactsCoordinator>().toContact(contact),
      leading: _Avatar(contact: contact),
      title: Text(
        contact!.fullname,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.subhead3Semi,
      ),
      subtitle: Text(
        pending >= 1 ? '$pending pending' : "${contact!.totalJobs > 0 ? contact!.totalJobs : 'none'} completed",
        style: theme.body3Hint,
      ),
      trailing: showActions
          ? IconButton(
              icon: const Icon(Icons.call),
              onPressed: () => call(contact!.phone),
            )
          : null,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.contact});

  final ContactModel? contact;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: contact!.id,
      child: CircleAvatar(
        radius: 24.0,
        backgroundColor: kPrimaryColor,
        backgroundImage: contact!.imageUrl != null ? CachedNetworkImageProvider(contact!.imageUrl!) : null,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: const Alignment(1.05, -1.05),
              child: contact!.pendingJobs > 0 ? const Dots(color: kAccentColor) : null,
            ),
            if (contact!.imageUrl == null) const Center(child: Icon(Icons.person_outline, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
