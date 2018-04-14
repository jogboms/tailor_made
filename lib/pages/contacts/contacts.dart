import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/contacts/ui/contacts_item.dart';
import 'package:tailor_made/ui/back_button.dart';
import 'package:tailor_made/utils/tm_colors.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => new _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchQuery = new TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    List<ContactModel> contactList = <ContactModel>[
      ContactModel(title: "Princess", pending: 4, image: "https://placeimg.com/640/640/people"),
      ContactModel(title: "Winnie", pending: 2, image: "https://placeimg.com/640/640/nature"),
      ContactModel(title: "Joy", pending: 0, image: "https://placeimg.com/640/640/arch"),
      ContactModel(title: "Princess", pending: 3, image: "https://placeimg.com/640/640/people"),
      ContactModel(title: "Mikun", pending: 5, image: "https://placeimg.com/640/640/animals"),
      ContactModel(title: "Joy", pending: 0, image: "https://placeimg.com/640/640/people"),
      ContactModel(title: "Princess", pending: 6, image: "https://placeimg.com/640/640/tech"),
      ContactModel(title: "Mikun", pending: 1, image: "https://placeimg.com/640/640/arch"),
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
      return AppBar(
        leading: backButton(context),
        title: new Text(
          "Clients",
          style: new TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.95,
          ),
        ),
        // centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: Colors.grey.shade800,
            ),
            onPressed: onTapSearch,
          )
        ],
      );
    }

    return new Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Colors.grey.shade100,
      appBar: _isSearching ? buildSearchBar() : buildAppBar(),
      // body: new Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: <Widget>[],
      // ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
        // padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // padding: EdgeInsets.all(0.0),
        // padding: EdgeInsets.all(15.0),
        child: GridView.count(
          primary: false,
          padding: EdgeInsets.all(2.0),
          // childAspectRatio: 0.75,
          childAspectRatio: 0.925,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          crossAxisCount: 2,
          children: contactList.map((ContactModel contact) => ContactsItem(contact: contact)).toList(),
        ),
      ),
    );
  }
}
