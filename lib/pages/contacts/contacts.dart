import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/pages/contacts/ui/contacts_list_item.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/contacts.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsPage extends StatefulWidget {
  // final List<ContactModel> contacts;

  ContactsPage({
    Key key,
    // @required this.contacts,
  }) : super(key: key);

  @override
  _ContactsPageState createState() => new _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchQuery = new TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new StoreConnector<ReduxState, ContactsViewModel>(
      converter: (store) => ContactsViewModel(store),
      builder: (BuildContext context, ContactsViewModel vm) {
        return new Scaffold(
          backgroundColor: theme.scaffoldColor,
          appBar: _isSearching ? buildSearchBar() : buildAppBar(),
          body: buildBody(vm),
          floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.person_add),
            onPressed: () => TMNavigate(context, ContactsCreatePage()),
          ),
        );
      },
    );
  }

  // void onTapSearch() {
  //   setState(() {
  //     _isSearching = true;
  //   });
  // }

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
    );
  }

  AppBar buildAppBar() {
    return appBar(
      context,
      title: "Clients",
      actions: <Widget>[
        // new IconButton(
        //   icon: new Icon(
        //     Icons.search,
        //     color: theme.appBarColor,
        //   ),
        //   onPressed: onTapSearch,
        // )
      ],
    );
  }

  Widget buildBody(ContactsViewModel vm) {
    if (vm.isLoading) {
      return loadingSpinner();
    }

    return vm.contacts.isEmpty
        ? Center(
            child: TMEmptyResult(message: "No contacts available"),
          )
        : new ListView.separated(
            itemCount: vm.contacts.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 96.0),
            itemBuilder: (context, index) => ContactsListItem(contact: vm.contacts[index]),
            separatorBuilder: (BuildContext context, int index) => new Divider(),
          );
  }
}
