import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/contacts/_partials/contacts_list_item.dart';

class ContactLists extends StatelessWidget {
  const ContactLists({
    Key key,
    @required this.contacts,
  }) : super(key: key);

  final List<ContactModel> contacts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MkAppBar(
        title: const Text("Select Client"),
      ),
      body: (contacts ?? []).isEmpty
          ? const Center(
              child: const EmptyResultView(message: "No contacts available"),
            )
          : ListView.separated(
              itemCount: contacts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = contacts[index];
                return ContactsListItem(
                  contact: item,
                  showActions: false,
                  onTapContact: () => Navigator.pop(context, item),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
    );
  }
}
