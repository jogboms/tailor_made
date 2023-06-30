import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../jobs/widgets/jobs_list.dart';
import 'widgets/contact_appbar.dart';
import 'widgets/contact_gallery_grid.dart';
import 'widgets/contact_payments_list.dart';

const List<String> _tabs = <String>['Jobs', 'Gallery', 'Payments'];

class ContactPage extends StatelessWidget {
  const ContactPage({super.key, required this.contact});

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, ContactsViewModel>(
      converter: (AppState state) => ContactsViewModel(state, contactID: contact.id),
      builder: (BuildContext context, DispatchFunction dispatch, ContactsViewModel viewModel) {
        // in the case of newly created contacts
        final ContactEntity contact = viewModel.selected ?? this.contact;
        return DefaultTabController(
          length: _tabs.length,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kAccentColor,
              automaticallyImplyLeading: false,
              title: ContactAppBar(
                userId: viewModel.userId,
                contact: contact,
                grouped: viewModel.measuresGrouped,
              ),
              titleSpacing: 0.0,
              centerTitle: false,
              bottom: TabBar(
                labelStyle: Theme.of(context).body3Medium,
                tabs: _tabs.map((String tab) => Tab(child: Text(tab))).toList(),
              ),
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: Builder(
              builder: (BuildContext context) {
                if (viewModel.isLoading) {
                  return const Center(child: LoadingSpinner());
                }

                return TabBarView(
                  children: <Widget>[
                    _TabView(
                      name: _tabs[0].toLowerCase(),
                      child: JobList(jobs: viewModel.selectedJobs),
                    ),
                    _TabView(
                      name: _tabs[1].toLowerCase(),
                      child: GalleryGridWidget(jobs: viewModel.selectedJobs),
                    ),
                    _TabView(
                      name: _tabs[2].toLowerCase(),
                      child: PaymentsListWidget(jobs: viewModel.selectedJobs),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _TabView extends StatelessWidget {
  const _TabView({required this.name, required this.child});

  final String name;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
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
