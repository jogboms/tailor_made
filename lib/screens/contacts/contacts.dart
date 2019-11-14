import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/coordinator/contacts_coordinator.dart';
import 'package:tailor_made/providers/dispatch_provider.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/contacts/actions.dart';
import 'package:tailor_made/rebloc/contacts/sort_type.dart';
import 'package:tailor_made/rebloc/contacts/view_model.dart';
import 'package:tailor_made/screens/contacts/_partials/contacts_filter_button.dart';
import 'package:tailor_made/screens/contacts/_partials/contacts_list_item.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_close_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with DispatchProvider<AppState> {
  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, ContactsViewModel>(
      converter: (store) => ContactsViewModel(store),
      builder: (BuildContext context, DispatchFunction dispatch, ContactsViewModel vm) {
        return WillPopScope(
          child: Scaffold(
            appBar: _AppBar(vm: vm),
            body: Builder(builder: (context) {
              if (vm.isLoading && !vm.isSearching) {
                return const MkLoadingSpinner();
              }

              if (vm.contacts == null || vm.contacts.isEmpty) {
                return Center(
                  child: const EmptyResultView(message: "No contacts available"),
                );
              }

              return ListView.separated(
                itemCount: vm.contacts.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 96.0),
                itemBuilder: (_, index) => ContactsListItem(contact: vm.contacts[index]),
                separatorBuilder: (_, __) => const Divider(height: 0),
              );
            }),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.person_add),
              onPressed: () => ContactsCoordinator.di().toCreateContact(),
            ),
          ),
          onWillPop: () async {
            // if (_isSearching) {
            //   _handleSearchEnd(vm)();
            //   return false;
            // }
            return true;
          },
        );
      },
    );
  }
}

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  const _AppBar({Key key, @required this.vm}) : super(key: key);

  final ContactsViewModel vm;

  @override
  _AppBarState createState() => _AppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> with DispatchProvider<AppState> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context);

    if (!_isSearching) {
      return MkAppBar(
        title: const Text("Contacts"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: theme.appBarTitle.color),
            onPressed: _onTapSearch,
          ),
          ContactsFilterButton(
            vm: widget.vm,
            onTapSort: (SortType type) => dispatchAction(SortContacts(payload: type)),
          ),
        ],
      );
    }

    final _textStyle = theme.subhead1Bold;

    return AppBar(
      centerTitle: false,
      elevation: 1.0,
      leading: MkCloseButton(color: Colors.white, onPop: _handleSearchEnd),
      title: TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: 'Search...', hintStyle: _textStyle.copyWith(color: Colors.white)),
        style: _textStyle.copyWith(color: Colors.white),
        onChanged: (term) => dispatchAction(SearchContactAction(payload: term)),
      ),
      bottom: PreferredSize(
        child: SizedBox(
          height: 1.0,
          child: widget.vm.isLoading ? const LinearProgressIndicator(backgroundColor: Colors.white) : null,
        ),
        preferredSize: const Size.fromHeight(1.0),
      ),
    );
  }

  void _onTapSearch() => setState(() => _isSearching = true);

  void _handleSearchEnd() {
    dispatchAction(const CancelSearchContactAction());
    setState(() => _isSearching = false);
  }
}
