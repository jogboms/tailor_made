import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import 'providers/job_provider.dart';
import 'providers/selected_job_provider.dart';
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
    final L10n l10n = context.l10n;

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) =>
          ref.watch(selectedJobProvider(widget.job.id)).when(
                skipLoadingOnReload: true,
                data: (JobState state) => Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 250.0,
                          flexibleSpace: FlexibleSpaceBar(background: _Header(job: state.job)),
                          pinned: true,
                          titleSpacing: 0.0,
                          elevation: 1.0,
                          automaticallyImplyLeading: false,
                          centerTitle: false,
                          title: _AvatarAppBar(job: state.job, contact: state.contact),
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
                                  child: Text(l10n.dueDateCaption.toUpperCase(), style: theme.textTheme.bodySmall),
                                ),
                                AppClearButton(
                                  onPressed: state.job.isComplete
                                      ? null
                                      : () => _onSaveDate(l10n, ref.read(jobProvider), state.job),
                                  child: Text(
                                    l10n.extendDateCaption,
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
                                AppDate(state.job.dueAt, day: 'EEEE', month: 'MMMM', year: 'yyyy').formatted!,
                                style: theme.textTheme.labelLarge,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            GalleryGrids(job: state.job, userId: state.userId),
                            const SizedBox(height: 4.0),
                            PaymentGrids(job: state.job, userId: state.userId),
                            const SizedBox(height: 32.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                state.job.notes,
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
                    icon: Icon(state.job.isComplete ? Icons.undo : Icons.check),
                    backgroundColor: state.job.isComplete ? colorScheme.onSecondary : colorScheme.secondary,
                    foregroundColor: state.job.isComplete ? colorScheme.secondary : colorScheme.onSecondary,
                    label: Text(state.job.isComplete ? l10n.undoCompletedCaption : l10n.markCompletedCaption),
                    onPressed: () => _onTapComplete(l10n, ref.read(jobProvider), state.job),
                  ),
                ),
                error: ErrorView.new,
                loading: () => child!,
              ),
      child: const Center(child: LoadingSpinner()),
    );
  }

  void _onTapComplete(L10n l10n, JobProvider jobProvider, JobEntity job) async {
    final AppSnackBar snackBar = AppSnackBar.of(context);
    final bool? choice = await showChoiceDialog(context: context, message: l10n.confirmationMessage);
    if (choice == null || choice == false) {
      return;
    }

    snackBar.loading();

    try {
      await jobProvider.complete(reference: job.reference, complete: !job.isComplete);
      snackBar.hide();
    } catch (e, stackTrace) {
      AppLog.e(e, stackTrace);
      snackBar.error(e.toString());
    }
  }

  void _onSaveDate(L10n l10n, JobProvider jobProvider, JobEntity job) async {
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
      final AppSnackBar snackBar = AppSnackBar.of(context);
      final bool? choice = await showChoiceDialog(context: context, message: l10n.confirmationMessage);
      if (choice == null || choice == false) {
        return;
      }

      snackBar.loading();

      try {
        await jobProvider.changeDueAt(reference: job.reference, dueAt: picked);
        snackBar.hide();
      } catch (error, stackTrace) {
        AppLog.e(error, stackTrace);
        snackBar.error(error.toString());
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
        onTap: () => context.router.toContact(contact.id),
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
          onPressed: () => context.router.toMeasures(job.measurements),
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
    final L10n l10n = context.l10n;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(border: Border(right: Divider.createBorderSide(context))),
        child: Column(
          children: <Widget>[
            Text(l10n.paidCaption, style: theme.textTheme.labelSmall, textAlign: TextAlign.center),
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
    final L10n l10n = context.l10n;

    return Expanded(
      child: Column(
        children: <Widget>[
          Text(l10n.unpaidCaption, style: theme.textTheme.labelSmall, textAlign: TextAlign.center),
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
