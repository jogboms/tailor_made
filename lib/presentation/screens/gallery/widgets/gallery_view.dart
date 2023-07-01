import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

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
    return ViewModelSubscriber<AppState, ContactJobViewModel>(
      converter: (AppState store) => ContactJobViewModel(
        store,
        contactID: contactID,
        jobID: jobID,
      ),
      builder: (_, __, ContactJobViewModel vm) {
        return Scaffold(
          appBar: _MyAppBar(contactId: vm.selectedContact?.id, job: vm.selectedJob, account: vm.account),
          body: PhotoView(
            imageProvider: NetworkImage(src),
            loadingBuilder: (_, __) => const LoadingSpinner(),
            heroAttributes: PhotoViewHeroAttributes(tag: src),
          ),
        );
      },
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MyAppBar({this.contactId, this.job, required this.account});

  final String? contactId;
  final JobEntity? job;
  final AccountEntity? account;

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
              if (job case final JobEntity job)
                IconButton(
                  icon: const Icon(Icons.work, color: iconColor),
                  onPressed: () => context.registry.get<JobsCoordinator>().toJob(job),
                ),
              if (contactId case final String contactId)
                IconButton(
                  icon: const Icon(Icons.person, color: iconColor),
                  onPressed: () => context.registry.get<ContactsCoordinator>().toContact(contactId),
                ),
              if (account!.hasPremiumEnabled)
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
