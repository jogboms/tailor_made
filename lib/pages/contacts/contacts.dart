import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/pages/contacts/ui/contacts_filter_button.dart';
import 'package:tailor_made/pages/contacts/ui/contacts_list_item.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/contacts.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => new _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new StoreConnector<ReduxState, ContactsViewModel>(
      converter: (store) => ContactsViewModel(store),
      builder: (BuildContext context, ContactsViewModel vm) {
        return WillPopScope(
          child: new Scaffold(
            backgroundColor: theme.scaffoldColor,
            appBar: _isSearching
                ? buildSearchBar(theme, vm)
                : buildAppBar(theme, vm),
            body: buildBody(vm),
            floatingActionButton: new FloatingActionButton(
              child: new Icon(Icons.person_add),
              onPressed: () => TMNavigate(context, ContactsCreatePage()),
            ),
          ),
          onWillPop: () async {
            if (_isSearching) {
              _handleSearchEnd(vm)();
              return false;
            }
            return true;
          },
        );
      },
    );
  }

  void onTapSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  Function() _handleSearchEnd(ContactsViewModel vm) {
    return () {
      vm.cancelSearch();
      setState(() {
        _isSearching = false;
      });
    };
  }

  Widget buildSearchBar(TMTheme theme, ContactsViewModel vm) {
    return new AppBar(
        centerTitle: false,
        elevation: 1.0,
        leading: new IconButton(
          icon: Icon(Icons.arrow_back, color: theme.appBarColor),
          onPressed: _handleSearchEnd(vm),
          tooltip: 'Back',
        ),
        title: new Theme(
          data: ThemeData(
            hintColor: Colors.white,
            primaryColor: kPrimaryColor,
          ),
          child: TextField(
            autofocus: true,
            decoration: new InputDecoration(
              hintText: 'Search...',
              hintStyle: ralewayBold(16.0),
            ),
            style: ralewayBold(16.0, theme.appBarColor),
            onChanged: (term) => vm.search(term),
          ),
        ),
        bottom: PreferredSize(
          child: SizedBox(
            height: 1.0,
            child: vm.isLoading
                ? LinearProgressIndicator(backgroundColor: Colors.white)
                : null,
          ),
          preferredSize: Size.fromHeight(1.0),
        ));
  }

  AppBar buildAppBar(TMTheme theme, ContactsViewModel vm) {
    return appBar(
      context,
      title: "Contacts",
      actions: <Widget>[
        new IconButton(
          icon: new Icon(
            Icons.search,
            color: theme.appBarColor,
          ),
          onPressed: onTapSearch,
        ),
        ContactsFilterButton(vm: vm),
      ],
    );
  }

  Widget buildBody(ContactsViewModel vm) {
    if (vm.isLoading && !vm.isSearching) {
      return loadingSpinner();
    }

    return vm.contacts == null || vm.contacts.isEmpty
        ? Center(
            child: TMEmptyResult(message: "No contacts available"),
          )
        : new ListView.separated(
            itemCount: vm.contacts.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 96.0),
            itemBuilder: (context, index) =>
                ContactsListItem(contact: vm.contacts[index]),
            separatorBuilder: (_, int index) => new Divider(),
          );
  }
}
