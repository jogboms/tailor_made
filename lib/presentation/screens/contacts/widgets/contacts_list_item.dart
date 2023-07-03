import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

class ContactsListItem extends StatelessWidget {
  const ContactsListItem({super.key, required this.contact, this.onTapContact, this.showActions = true});

  final ContactEntity contact;
  final VoidCallback? onTapContact;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final int pending = contact.pendingJobs;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      onTap: onTapContact ?? () => context.router.toContact(contact.id),
      leading: _Avatar(contact: contact),
      title: Text(
        contact.fullname,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: AppFontWeight.semibold),
      ),
      subtitle: Text(
        pending >= 1 ? '$pending pending' : "${contact.totalJobs > 0 ? contact.totalJobs : 'none'} completed",
        style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.outline),
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
  const _Avatar({required this.contact});

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Hero(
      tag: contact.id,
      child: CircleAvatar(
        radius: 24.0,
        backgroundColor: colorScheme.primary,
        backgroundImage: contact.imageUrl != null ? CachedNetworkImageProvider(contact.imageUrl!) : null,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: const Alignment(1.05, -1.05),
              child: contact.pendingJobs > 0 ? Dots(color: colorScheme.secondary) : null,
            ),
            if (contact.imageUrl == null) const Center(child: Icon(Icons.person_outline)),
          ],
        ),
      ),
    );
  }
}
