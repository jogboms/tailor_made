import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/contacts/view_model.dart';
import 'package:tailor_made/screens/contacts/_partials/contact_appbar.dart';
import 'package:tailor_made/screens/contacts/_partials/contact_gallery_grid.dart';
import 'package:tailor_made/screens/contacts/_partials/contact_payments_list.dart';
import 'package:tailor_made/screens/jobs/_partials/jobs_list.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

const TABS = ["Jobs", "Gallery", "Payments"];

class ContactPage extends StatelessWidget {
  const ContactPage({
    Key key,
    this.contact,
  }) : super(key: key);

  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, ContactsViewModel>(
      converter: (state) => ContactsViewModel(state)..contactID = contact.id,
      builder: (
        BuildContext context,
        DispatchFunction dispatch,
        ContactsViewModel viewModel,
      ) {
        // in the case of newly created contacts
        final _contact = viewModel.selected ?? contact;
        return DefaultTabController(
          length: TABS.length,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kAccentColor,
              automaticallyImplyLeading: false,
              title: ContactAppBar(
                contact: _contact,
                grouped: viewModel.measuresGrouped,
              ),
              titleSpacing: 0.0,
              centerTitle: false,
              brightness: Brightness.dark,
              bottom: TabBar(
                labelStyle: ThemeProvider.of(context).body3Medium,
                tabs: TABS.map((tab) => Tab(child: Text(tab))).toList(),
              ),
            ),
            body: Builder(builder: (context) {
              if (viewModel.isLoading) {
                return const Center(
                  child: MkLoadingSpinner(),
                );
              }

              return TabBarView(
                children: [
                  _TabView(
                    name: TABS[0].toLowerCase(),
                    child: JobList(
                      jobs: viewModel.selectedJobs,
                    ),
                  ),
                  _TabView(
                    name: TABS[1].toLowerCase(),
                    child: GalleryGridWidget(
                      contact: _contact,
                      jobs: viewModel.selectedJobs,
                    ),
                  ),
                  _TabView(
                    name: TABS[2].toLowerCase(),
                    child: PaymentsListWidget(
                      contact: _contact,
                      jobs: viewModel.selectedJobs,
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

class _TabView extends StatelessWidget {
  const _TabView({
    Key key,
    @required this.name,
    @required this.child,
  }) : super(key: key);

  final String name;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            key: PageStorageKey<String>(name),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                sliver: child,
              ),
            ],
          );
        },
      ),
    );
  }
}
