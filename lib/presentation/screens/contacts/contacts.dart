import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/contacts_filter_button.dart';
import 'widgets/contacts_list_item.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with DispatchProvider<AppState> {
  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, ContactsViewModel>(
      converter: ContactsViewModel.new,
      builder: (BuildContext context, DispatchFunction dispatch, ContactsViewModel vm) {
        return WillPopScope(
          child: Scaffold(
            appBar: _AppBar(vm: vm),
            body: Builder(
              builder: (BuildContext context) {
                if (vm.isLoading && !vm.isSearching) {
                  return const LoadingSpinner();
                }

                if (vm.contacts == null || vm.contacts!.isEmpty) {
                  return const Center(
                    child: EmptyResultView(message: 'No contacts available'),
                  );
                }

                return ListView.separated(
                  itemCount: vm.contacts!.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 96.0),
                  itemBuilder: (_, int index) => ContactsListItem(contact: vm.contacts![index]),
                  separatorBuilder: (_, __) => const Divider(height: 0),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.person_add),
              onPressed: () => context.registry.get<ContactsCoordinator>().toCreateContact(vm.userId),
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
  const _AppBar({required this.vm});

  final ContactsViewModel vm;

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> with DispatchProvider<AppState> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider? theme = ThemeProvider.of(context);

    if (!_isSearching) {
      return CustomAppBar(
        title: const Text('Contacts'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: theme!.appBarTitle.color),
            onPressed: _onTapSearch,
          ),
          ContactsFilterButton(
            vm: widget.vm,
            onTapSort: (ContactsSortType type) => dispatchAction(SortContacts(type)),
          ),
        ],
      );
    }

    final TextStyle textStyle = theme!.subhead1Bold;

    return AppBar(
      centerTitle: false,
      elevation: 1.0,
      leading: AppCloseButton(color: Colors.white, onPop: _handleSearchEnd),
      title: TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: 'Search...', hintStyle: textStyle.copyWith(color: Colors.white)),
        style: textStyle.copyWith(color: Colors.white),
        onChanged: (String term) => dispatchAction(SearchContactAction(term)),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: SizedBox(
          height: 1.0,
          child: widget.vm.isLoading ? const LinearProgressIndicator(backgroundColor: Colors.white) : null,
        ),
      ),
    );
  }

  void _onTapSearch() => setState(() => _isSearching = true);

  void _handleSearchEnd() {
    dispatchAction(const CancelSearchContactAction());
    setState(() => _isSearching = false);
  }
}
