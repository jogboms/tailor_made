import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/contacts_job.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/screens/contacts/contact.dart';
import 'package:tailor_made/widgets/screens/jobs/job.dart';

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
          appBar: MyAppBar(
            contact: vm.selectedContact,
            job: vm.selectedJob,
            account: vm.account,
          ),
          body: Hero(
            tag: image.src,
            child: PhotoView(
              imageProvider: NetworkImage(image.src),
              loadingChild: const MkLoadingSpinner(),
            ),
          ),
        );
      },
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: Colors.black26,
        child: SafeArea(
          bottom: false,
          child: Row(
            children: <Widget>[
              IconButton(
                color: Colors.white,
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(Icons.arrow_back),
              ),
              Expanded(child: SizedBox()),
              job != null
                  ? IconButton(
                      icon: Icon(
                        Icons.work,
                        color: Colors.white,
                      ),
                      onPressed: () => MkNavigate(context, JobPage(job: job)),
                    )
                  : SizedBox(),
              contact != null
                  ? IconButton(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          MkNavigate(context, ContactPage(contact: contact)),
                    )
                  : SizedBox(),
              account.hasPremiumEnabled
                  ? IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      // TODO
                      onPressed: null,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
