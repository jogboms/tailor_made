import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:registry/registry.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/avatar_app_bar.dart';
import 'widgets/gallery_grids.dart';
import 'widgets/payment_grids.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key, required this.job});

  final JobEntity job;

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ViewModelSubscriber<AppState, JobsViewModel>(
      converter: (AppState store) => JobsViewModel(store, jobID: widget.job.id),
      builder: (BuildContext context, _, JobsViewModel vm) {
        // in the case of newly created jobs
        final JobEntity job = vm.selected ?? widget.job;
        final ContactEntity? contact = vm.selectedContact;
        if (vm.isLoading || contact == null) {
          return const Center(child: LoadingSpinner());
        }
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 250.0,
                  flexibleSpace: FlexibleSpaceBar(background: _Header(job: job)),
                  pinned: true,
                  titleSpacing: 0.0,
                  elevation: 1.0,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: _AvatarAppBar(job: job, contact: contact),
                ),
              ];
            },
            body: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text('DUE DATE', style: theme.textTheme.bodySmall),
                        ),
                        AppClearButton(
                          onPressed: job.isComplete ? null : () => _onSaveDate(job),
                          child: Text(
                            'EXTEND DATE',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: AppFontWeight.medium,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        AppDate(job.dueAt, day: 'EEEE', month: 'MMMM', year: 'yyyy').formatted!,
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    GalleryGrids(job: job, userId: vm.userId),
                    const SizedBox(height: 4.0),
                    PaymentGrids(job: job, userId: vm.userId),
                    const SizedBox(height: 32.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        job.notes,
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: AppFontWeight.light),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 48.0),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            icon: Icon(job.isComplete ? Icons.undo : Icons.check),
            backgroundColor: job.isComplete ? colorScheme.onSecondary : colorScheme.secondary,
            foregroundColor: job.isComplete ? colorScheme.secondary : colorScheme.onSecondary,
            label: Text(job.isComplete ? 'Undo Completed' : 'Mark Completed'),
            onPressed: () => _onTapComplete(job),
          ),
        );
      },
    );
  }

  void _onTapComplete(JobEntity job) async {
    final Registry registry = context.registry;
    final AppSnackBar snackBar = AppSnackBar.of(context);
    final bool? choice = await showChoiceDialog(context: context, message: 'Are you sure?');
    if (choice == null || choice == false) {
      return;
    }

    snackBar.loading();

    try {
      await registry.get<Jobs>().update(
            job.userID,
            reference: job.reference,
            isComplete: !job.isComplete,
          );
      snackBar.hide();
    } catch (e, stackTrace) {
      AppLog.e(e, stackTrace);
      snackBar.error(e.toString());
    }
  }

  void _onSaveDate(JobEntity job) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: job.dueAt,
      firstDate: job.dueAt.isAfter(clock.now()) ? clock.now() : job.dueAt,
      lastDate: DateTime(2101),
    );
    if (picked == null || picked == job.dueAt) {
      return;
    }
    if (context.mounted) {
      final Registry registry = context.registry;
      final AppSnackBar snackBar = AppSnackBar.of(context);
      final bool? choice = await showChoiceDialog(context: context, message: 'Are you sure?');
      if (choice == null || choice == false) {
        return;
      }

      snackBar.loading();

      try {
        await registry.get<Jobs>().update(
              job.userID,
              reference: job.reference,
              dueAt: picked,
            );
        snackBar.hide();
      } catch (e, stackTrace) {
        AppLog.e(e, stackTrace);
        snackBar.error(e.toString());
      }
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.job});

  final JobEntity job;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            job.name,
            style: theme.textTheme.pageTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          AppMoney(job.price).formatted,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: AppFontWeight.semibold,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24.0),
        Container(
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: Divider.createBorderSide(context)),
          ),
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _PaidBox(job: job),
              _UnpaidBox(job: job),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarAppBar extends StatelessWidget {
  const _AvatarAppBar({required this.job, required this.contact});

  final JobEntity job;
  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    final String date = AppDate(job.createdAt).formatted!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return AvatarAppBar(
      tag: contact.createdAt.toString(),
      imageUrl: contact.imageUrl,
      title: GestureDetector(
        onTap: () => context.registry.get<ContactsCoordinator>().toContact(contact),
        child: Text(
          contact.fullname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.pageTitle,
        ),
      ),
      subtitle: Text(
        date,
        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w300),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.content_cut),
          onPressed: () => context.registry.get<MeasuresCoordinator>().toMeasures(job.measurements),
        ),
        IconButton(
          icon: Icon(Icons.check, color: job.isComplete ? colorScheme.primary : null),
          onPressed: null,
        ),
      ],
    );
  }
}

class _PaidBox extends StatelessWidget {
  const _PaidBox({required this.job});

  final JobEntity job;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(border: Border(right: Divider.createBorderSide(context))),
        child: Column(
          children: <Widget>[
            Text('PAID', style: theme.textTheme.labelSmall, textAlign: TextAlign.center),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.arrow_drop_up, color: Colors.green.shade600, size: 16.0),
                const SizedBox(width: 4.0),
                Text(
                  AppMoney(job.completedPayment).formatted,
                  style: theme.textTheme.pageTitle.copyWith(letterSpacing: 1.25),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UnpaidBox extends StatelessWidget {
  const _UnpaidBox({required this.job});

  final JobEntity job;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: <Widget>[
          Text('UNPAID', style: theme.textTheme.labelSmall, textAlign: TextAlign.center),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_drop_down, color: Colors.red.shade600, size: 16.0),
              const SizedBox(width: 4.0),
              Text(
                AppMoney(job.pendingPayment).formatted,
                style: theme.textTheme.pageTitle.copyWith(letterSpacing: 1.25),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
