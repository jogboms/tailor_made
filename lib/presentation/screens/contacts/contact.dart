import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../utils.dart';
import '../jobs/widgets/jobs_list.dart';
import 'providers/selected_contact_provider.dart';
import 'widgets/contact_appbar.dart';
import 'widgets/contact_gallery_grid.dart';
import 'widgets/contact_payments_list.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final L10n l10n = context.l10n;

    final List<String> tabs = <String>[l10n.jobsPageTitle, l10n.galleryPageTitle, l10n.paymentsPageTitle];

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) => DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: colorScheme.secondary,
            automaticallyImplyLeading: false,
            title: ref.watch(selectedContactProvider(id)).maybeWhen(
                  skipLoadingOnReload: true,
                  data: (ContactState data) => ContactAppBar(
                    contact: data.contact,
                    grouped: data.measurements,
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
            titleSpacing: 0.0,
            centerTitle: false,
            bottom: TabBar(
              labelStyle: theme.textTheme.labelLarge,
              tabs: tabs.map((String tab) => Tab(child: Text(tab))).toList(),
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: ref.watch(selectedContactProvider(id)).when(
                skipLoadingOnReload: true,
                data: (ContactState data) => TabBarView(
                  children: <Widget>[
                    _TabView(
                      name: tabs[0].toLowerCase(),
                      child: JobList(jobs: data.jobs),
                    ),
                    _TabView(
                      name: tabs[1].toLowerCase(),
                      child: GalleryGridWidget(jobs: data.jobs),
                    ),
                    _TabView(
                      name: tabs[2].toLowerCase(),
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
