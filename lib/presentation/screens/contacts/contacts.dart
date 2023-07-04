import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import 'providers/filtered_contacts_state_provider.dart';
import 'widgets/contacts_filter_button.dart';
import 'widgets/contacts_list_item.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final AsyncValue<FilteredContactsState> filteredContacts = ref.watch(filteredContactsProvider);

        return WillPopScope(
          child: Scaffold(
            appBar: _AppBar(loading: filteredContacts.isLoading),
            body: filteredContacts.when(
              skipLoadingOnReload: true,
              data: (FilteredContactsState state) {
                if (state.contacts.isEmpty) {
                  return const Center(
                    child: EmptyResultView(message: 'No contacts available'),
                  );
                }

                return ListView.separated(
                  itemCount: state.contacts.length,
                  padding: const EdgeInsets.only(bottom: 96.0),
                  itemBuilder: (_, int index) => ContactsListItem(contact: state.contacts[index]),
                  separatorBuilder: (_, __) => const Divider(height: 0),
                );
              },
              error: ErrorView.new,
              loading: () => child!,
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.person_add),
              onPressed: () => context.router.toCreateContact(),
            ),
          ),
          onWillPop: () async {
            final SearchContactQueryState queryState = ref.read(searchContactQueryStateProvider.notifier);
            if (queryState.isSearching()) {
              queryState.setState('');
              return false;
            }
            return true;
          },
        );
      },
      child: const Center(child: LoadingSpinner()),
    );
  }
}

class _AppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const _AppBar({required this.loading});

  final bool loading;

  @override
  ConsumerState<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends ConsumerState<_AppBar> {
  late final SearchContactQueryState _queryProvider = ref.read(searchContactQueryStateProvider.notifier);
  late final SearchContactSortState _sortProvider = ref.read(searchContactSortStateProvider.notifier);
  late final TextEditingController _controller = TextEditingController(text: _queryProvider.currentState);
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(searchContactQueryStateProvider, (_, String next) {
      if (_controller.text != next) {
        _controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length, affinity: TextAffinity.upstream),
        );
      }
    });

    if (!_isSearching) {
      return CustomAppBar(
        title: const Text('Contacts'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onTapSearch,
          ),
          ContactsFilterButton(
            sortType: ref.watch(searchContactSortStateProvider),
            onTapSort: _sortProvider.setState,
          ),
        ],
      );
    }

    return AppBar(
      leading: AppCloseButton(onPop: _handleSearchEnd),
      title: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Search...'),
        onChanged: _queryProvider.setState,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: SizedBox(
          height: 1.0,
          child: widget.loading ? const LinearProgressIndicator() : null,
        ),
      ),
    );
  }

  void _onTapSearch() => setState(() => _isSearching = true);

  void _handleSearchEnd() {
    _queryProvider.setState('');
    setState(() => _isSearching = false);
  }
}
