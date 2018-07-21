import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/pages/jobs/job.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/contact_job.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_navigate.dart';

class GalleryView extends StatelessWidget {
  final ImageModel image;

  const GalleryView({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<ReduxState, ContactJobViewModel>(
      converter: (store) => ContactJobViewModel(store)
        ..contactID = image.contactID
        ..jobID = image.jobID,
      builder: (BuildContext context, ContactJobViewModel vm) {
        final contact = vm.selectedContact;
        final job = vm.selectedJob;
        return new Scaffold(
          backgroundColor: Colors.black87,
          appBar: MyAppBar(contact: contact, job: job),
          body: new Hero(
            tag: image.src,
            child: new PhotoView(
              imageProvider: NetworkImage(image.src),
              loadingChild: loadingSpinner(),
            ),
          ),
        );
      },
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ContactModel contact;
  final JobModel job;

  const MyAppBar({
    Key key,
    this.contact,
    this.job,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: Colors.black26,
        child: new SafeArea(
          bottom: false,
          child: Row(
            children: <Widget>[
              new IconButton(
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
                      onPressed: () => TMNavigate(context, JobPage(job: job)),
                    )
                  : SizedBox(),
              contact != null
                  ? IconButton(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          TMNavigate(context, ContactPage(contact: contact)),
                    )
                  : SizedBox(),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                // TODO
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
