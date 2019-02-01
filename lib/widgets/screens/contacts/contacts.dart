import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/actions/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/contacts.dart';
import 'package:tailor_made/utils/mk_dispatch_provider.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/contacts/contacts_create.dart';
import 'package:tailor_made/widgets/screens/contacts/_partials/contacts_filter_button.dart';
import 'package:tailor_made/widgets/screens/contacts/_partials/contacts_list_item.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with MkDispatchProvider<AppState> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    return ViewModelSubscriber<AppState, ContactsViewModel>(
      converter: (store) => ContactsViewModel(store),
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        ContactsViewModel vm,
      ) {
        return WillPopScope(
          child: Scaffold(
            appBar: _isSearching
                ? buildSearchBar(theme, vm)
                : buildAppBar(theme, vm),
            body: buildBody(vm),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.person_add),
              onPressed: () => MkNavigate(context, ContactsCreatePage()),
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
      dispatchAction(const CancelSearchContactEvent());
      setState(() {
        _isSearching = false;
      });
    };
  }

  Widget buildSearchBar(MkTheme theme, ContactsViewModel vm) {
    return AppBar(
      centerTitle: false,
      elevation: 1.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.appBarTitle.color),
        onPressed: _handleSearchEnd(vm),
        tooltip: 'Back',
      ),
      title: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: MkTheme.of(context).subhead1Bold,
        ),
        style: MkTheme.of(context).subhead1Bold,
        onChanged: (term) => dispatchAction(SearchContactEvent(payload: term)),
      ),
      bottom: PreferredSize(
        child: SizedBox(
          height: 1.0,
          child: vm.isLoading
              ? const LinearProgressIndicator(backgroundColor: Colors.white)
              : null,
        ),
        preferredSize: const Size.fromHeight(1.0),
      ),
    );
  }

  Widget buildAppBar(MkTheme theme, ContactsViewModel vm) {
    return MkAppBar(
      title: const Text("Contacts"),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: theme.appBarTitle.color,
          ),
          onPressed: onTapSearch,
        ),
        ContactsFilterButton(
          vm: vm,
          onTapSort: (SortType type) {
            dispatchAction(SortContacts(payload: type));
          },
        ),
      ],
    );
  }

  Widget buildBody(ContactsViewModel vm) {
    if (vm.isLoading && !vm.isSearching) {
      return const MkLoadingSpinner();
    }

    return vm.contacts == null || vm.contacts.isEmpty
        ? Center(
            child: const EmptyResultView(message: "No contacts available"),
          )
        : ListView.separated(
            itemCount: vm.contacts.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 96.0),
            itemBuilder: (context, index) =>
                ContactsListItem(contact: vm.contacts[index]),
            separatorBuilder: (_, int index) => const Divider(),
          );
  }
}
