import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key, this.image});

  final ImageModel? image;

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, ContactJobViewModel>(
      converter: (AppState store) => ContactJobViewModel(store)
        ..contactID = image!.contactID
        ..jobID = image!.jobID,
      builder: (_, __, ContactJobViewModel vm) {
        return Scaffold(
          backgroundColor: Colors.black87,
          appBar: _MyAppBar(contact: vm.selectedContact, job: vm.selectedJob, account: vm.account),
          body: PhotoView(
            imageProvider: NetworkImage(image!.src),
            loadingBuilder: (_, __) => const LoadingSpinner(),
            heroAttributes: PhotoViewHeroAttributes(tag: image!.src),
          ),
        );
      },
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MyAppBar({this.contact, this.job, required this.account});

  final ContactModel? contact;
  final JobModel? job;
  final AccountEntity? account;

  @override
  Widget build(BuildContext context) {
    return AppStatusBar(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.black26),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: <Widget>[
              const AppBackButton(color: Colors.white),
              const Expanded(child: SizedBox()),
              if (job != null)
                IconButton(
                  icon: const Icon(Icons.work, color: Colors.white),
                  onPressed: () => context.registry.get<JobsCoordinator>().toJob(job),
                ),
              if (contact != null)
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () => context.registry.get<ContactsCoordinator>().toContact(contact!),
                ),
              if (account!.hasPremiumEnabled)
                const IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
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
