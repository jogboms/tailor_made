import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({
    super.key,
    required this.src,
    required this.contactID,
    required this.jobID,
  });

  final String src;
  final String contactID;
  final String jobID;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) => ref
          .watch(selectedContactJobProvider(contactId: contactID, jobId: jobID))
          .when(
            skipLoadingOnReload: true,
            data: (ContactJobState state) => Scaffold(
              appBar: _MyAppBar(contactId: state.selectedContact.id, job: state.selectedJob, account: state.account),
              body: PhotoView(
                imageProvider: NetworkImage(src),
                loadingBuilder: (_, __) => const LoadingSpinner(),
                heroAttributes: PhotoViewHeroAttributes(tag: src),
              ),
            ),
            error: ErrorView.new,
            loading: () => child!,
          ),
      child: const Center(child: LoadingSpinner()),
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MyAppBar({required this.contactId, required this.job, required this.account});

  final String contactId;
  final JobEntity job;
  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    const Color iconColor = Colors.white;
    return AppStatusBar(
      brightness: Brightness.dark,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: <Widget>[
              const AppBackButton(color: iconColor),
              const Expanded(child: SizedBox()),
              IconButton(
                icon: const Icon(Icons.work, color: iconColor),
                onPressed: () => context.router.toJob(job),
              ),
              IconButton(
                icon: const Icon(Icons.person, color: iconColor),
                onPressed: () => context.router.toContact(contactId),
              ),
              if (account.hasPremiumEnabled)
                const IconButton(
                  icon: Icon(Icons.share, color: iconColor),
                  // TODO(Jogboms): Handle
                  onPressed: null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
