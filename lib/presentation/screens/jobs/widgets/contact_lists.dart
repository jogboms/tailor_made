import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import '../../contacts/widgets/contacts_list_item.dart';

class ContactLists extends StatelessWidget {
  const ContactLists({super.key, required this.contacts});

  final List<ContactEntity> contacts;

  @override
  Widget build(BuildContext context) {
    final L10n l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(title: Text(l10n.selectClientMessage)),
      body: contacts.isEmpty
          ? Center(child: EmptyResultView(message: l10n.noContactsAvailableMessage))
          : ListView.separated(
              itemCount: contacts.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final ContactEntity item = contacts[index];
                return ContactsListItem(
                  contact: item,
                  showActions: false,
                  onTapContact: () => Navigator.pop(context, item),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
            ),
    );
  }
}
