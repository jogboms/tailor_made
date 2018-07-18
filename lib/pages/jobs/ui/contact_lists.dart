import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/ui/contacts_list_item.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactLists extends StatelessWidget {
  final List<ContactModel> contacts;

  const ContactLists({
    Key key,
    @required this.contacts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    AppBar buildAppBar() {
      return appBar(
        context,
        title: "Select Client",
      );
    }

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: buildAppBar(),
      body: (contacts ?? []).isEmpty
          ? Center(
              child: TMEmptyResult(message: "No contacts available"),
            )
          : new ListView.separated(
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
              separatorBuilder: (BuildContext context, int index) => new Divider(),
            ),
    );
  }
}
