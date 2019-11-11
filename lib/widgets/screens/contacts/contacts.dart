import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/actions/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/contacts.dart';
import 'package:tailor_made/utils/mk_dispatch_provider.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_close_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/contacts/_partials/contacts_filter_button.dart';
import 'package:tailor_made/widgets/screens/contacts/_partials/contacts_list_item.dart';
import 'package:tailor_made/widgets/screens/contacts/contacts_create.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with MkDispatchProvider<AppState> {
  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, ContactsViewModel>(
      converter: (store) => ContactsViewModel(store),
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        ContactsViewModel vm,
      ) {
        return WillPopScope(
          child: Scaffold(
            appBar: _AppBar(vm: vm),
            body: Builder(builder: (context) {
              if (vm.isLoading && !vm.isSearching) {
                return const MkLoadingSpinner();
              }

              if (vm.contacts == null || vm.contacts.isEmpty) {
                return Center(
                  child: const EmptyResultView(
                    message: "No contacts available",
                  ),
                );
              }

              return ListView.separated(
                itemCount: vm.contacts.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 96.0),
                itemBuilder: (context, index) => ContactsListItem(contact: vm.contacts[index]),
                separatorBuilder: (_, __) => const Divider(height: 0),
              );
            }),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.person_add),
              onPressed: () => MkNavigate(context, const ContactsCreatePage()),
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
  const _AppBar({
    Key key,
    @required this.vm,
  }) : super(key: key);

  final ContactsViewModel vm;

  @override
  _AppBarState createState() => _AppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> with MkDispatchProvider<AppState> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    return !_isSearching
        ? MkAppBar(
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
                vm: widget.vm,
                onTapSort: (SortType type) {
                  dispatchAction(SortContacts(payload: type));
                },
              ),
            ],
          )
        : AppBar(
            centerTitle: false,
            elevation: 1.0,
            leading: MkCloseButton(
              color: Colors.white,
              onPop: _handleSearchEnd(widget.vm),
            ),
            title: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: MkTheme.of(context).subhead1Bold.copyWith(color: Colors.white),
              ),
              style: MkTheme.of(context).subhead1Bold.copyWith(color: Colors.white),
              onChanged: (term) => dispatchAction(SearchContactAction(payload: term)),
            ),
            bottom: PreferredSize(
              child: SizedBox(
                height: 1.0,
                child: widget.vm.isLoading
                    ? const LinearProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : null,
              ),
              preferredSize: const Size.fromHeight(1.0),
            ),
          );
  }

  void onTapSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  Function() _handleSearchEnd(ContactsViewModel vm) {
    return () {
      dispatchAction(const CancelSearchContactAction());
      setState(() {
        _isSearching = false;
      });
    };
  }
}
