import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/contact_job_view_model.dart';
import 'package:tailor_made/screens/contacts/contact.dart';
import 'package:tailor_made/screens/jobs/job.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_status_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({
    Key key,
    this.image,
  }) : super(key: key);

  final ImageModel image;

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, ContactJobViewModel>(
      converter: (store) => ContactJobViewModel(store)
        ..contactID = image.contactID
        ..jobID = image.jobID,
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        ContactJobViewModel vm,
      ) {
        return Scaffold(
          backgroundColor: Colors.black87,
          appBar: _MyAppBar(
            contact: vm.selectedContact,
            job: vm.selectedJob,
            account: vm.account,
          ),
          body: PhotoView(
            imageProvider: NetworkImage(image.src),
            loadingChild: const MkLoadingSpinner(),
            heroTag: image.src,
          ),
        );
      },
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MyAppBar({
    Key key,
    this.contact,
    this.job,
    @required this.account,
  }) : super(key: key);

  final ContactModel contact;
  final JobModel job;
  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return MkStatusBar(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.black26,
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: <Widget>[
              const MkBackButton(
                color: Colors.white,
              ),
              const Expanded(child: SizedBox()),
              job != null
                  ? IconButton(
                      icon: const Icon(
                        Icons.work,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        MkNavigate(context, JobPage(job: job));
                      },
                    )
                  : const SizedBox(),
              contact != null
                  ? IconButton(
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        MkNavigate(
                          context,
                          ContactPage(contact: contact),
                        );
                      },
                    )
                  : const SizedBox(),
              account.hasPremiumEnabled
                  ? IconButton(
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      // TODO
                      onPressed: null,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
