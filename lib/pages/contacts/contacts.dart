import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/contacts/ui/contacts_item.dart';
import 'package:tailor_made/services/cloudstore.dart';
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
      body: StreamBuilder(
        stream: Cloudstore.contacts.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          List<DocumentSnapshot> _data = snapshot.data.documents;
          var data = _data.where((doc) => doc.data.containsKey("fullname")).toList();

          return new ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            itemExtent: null,
            itemBuilder: (context, index) {
              return ContactsItem(contact: ContactModel.fromJson(data[index].data));
            },
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => TMNavigate(context, ContactsCreatePage()),
      ),
    );
  }
}
