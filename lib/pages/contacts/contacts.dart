import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/contacts/ui/contacts_item.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_colors.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => new _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchQuery = new TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    List<ContactModel> contactList = <ContactModel>[
      ContactModel(title: "Princess", pending: 4, image: "https://placeimg.com/640/640/animals"),
      ContactModel(title: "Winnie", pending: 2, image: "https://placeimg.com/640/640/nature"),
      ContactModel(title: "Joy", pending: 0, image: "https://placeimg.com/640/640/arch"),
      // ContactModel(title: "Princess", pending: 3, image: "https://placeimg.com/640/640/people"),
      ContactModel(title: "Mikun", pending: 5, image: "https://placeimg.com/640/640/people"),
      // ContactModel(title: "Joy", pending: 0, image: "https://placeimg.com/640/640/people"),
      // ContactModel(title: "Princess", pending: 6, image: "https://placeimg.com/640/640/tech"),
      // ContactModel(title: "Mikun", pending: 1, image: "https://placeimg.com/640/640/arch"),
    ];

    void onTapSearch() {
      setState(() {
        _isSearching = true;
      });
    }

    void _handleSearchEnd() {
      setState(() {
        _isSearching = false;
      });
    }

    Widget buildSearchBar() {
      return new AppBar(
        leading: new IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _handleSearchEnd,
          tooltip: 'Back',
        ),
        title: new TextField(
          controller: _searchQuery,
          autofocus: true,
          decoration: new InputDecoration(
            hintText: 'Search...',
            hintStyle: new TextStyle(color: Colors.white),
          ),
          style: new TextStyle(fontSize: 18.0),
        ),
        backgroundColor: TMColors.primary,
      );
    }

    AppBar buildAppBar() {
      return appBar(
        context,
        title: "Clients",
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: theme.appBarColor,
            ),
            onPressed: onTapSearch,
          )
        ],
      );
    }

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: _isSearching ? buildSearchBar() : buildAppBar(),
      body: Padding(
        padding: EdgeInsets.zero,
        child: ListView(
          shrinkWrap: true,
          itemExtent: null,
          children: contactList.map((ContactModel contact) => ContactsItem(contact: contact)).toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => TMNavigate(context, ContactsCreatePage()),
      ),
    );
  }
}
