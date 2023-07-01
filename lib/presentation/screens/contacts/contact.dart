import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../jobs/widgets/jobs_list.dart';
import 'providers/selected_contact_provider.dart';
import 'widgets/contact_appbar.dart';
import 'widgets/contact_gallery_grid.dart';
import 'widgets/contact_payments_list.dart';

const List<String> _tabs = <String>['Jobs', 'Gallery', 'Payments'];

class ContactPage extends StatelessWidget {
  const ContactPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) => DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: colorScheme.secondary,
            automaticallyImplyLeading: false,
            title: ref.watch(selectedContactProvider(id)).maybeWhen(
                  skipLoadingOnReload: true,
                  data: (ContactState data) => ContactAppBar(
                    userId: data.userId,
                    contact: data.contact,
                    grouped: data.measurements,
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
            titleSpacing: 0.0,
            centerTitle: false,
            bottom: TabBar(
              labelStyle: theme.textTheme.labelLarge,
              tabs: _tabs.map((String tab) => Tab(child: Text(tab))).toList(),
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: ref.watch(selectedContactProvider(id)).when(
                skipLoadingOnReload: true,
                data: (ContactState data) => TabBarView(
                  children: <Widget>[
                    _TabView(
                      name: _tabs[0].toLowerCase(),
                      child: JobList(jobs: data.jobs),
                    ),
                    _TabView(
                      name: _tabs[1].toLowerCase(),
                      child: GalleryGridWidget(jobs: data.jobs),
                    ),
                    _TabView(
                      name: _tabs[2].toLowerCase(),
                      child: PaymentsListWidget(jobs: data.jobs),
                    ),
                  ],
                ),
                error: ErrorView.new,
                loading: () => child!,
              ),
        ),
      ),
      child: const Center(child: LoadingSpinner()),
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
