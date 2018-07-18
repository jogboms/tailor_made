import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/pages/contacts/ui/contact_appbar.dart';
import 'package:tailor_made/pages/contacts/ui/contact_gallery_grid.dart';
import 'package:tailor_made/pages/contacts/ui/contact_jobs_list.dart';
import 'package:tailor_made/pages/contacts/ui/contact_payments_list.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/contacts.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const TABS = const ["Jobs", "Gallery", "Payments"];

class ContactPage extends StatefulWidget {
  final ContactModel contact;

  const ContactPage({
    Key key,
    this.contact,
  }) : super(key: key);

  @override
  _ContactState createState() => new _ContactState();
}

class _ContactState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    // TODO Maybe a clean up here
    return StoreConnector<ReduxState, ContactsViewModel>(
      converter: (store) => ContactsViewModel(store)..contactID = widget.contact.id,
      builder: (BuildContext context, ContactsViewModel vm) {
        final contact = vm.selected;
        return new DefaultTabController(
          length: 3,
          child: new Scaffold(
            backgroundColor: theme.scaffoldColor,
            appBar: new AppBar(
              backgroundColor: kAccentColor,
              automaticallyImplyLeading: false,
              title: new ContactAppBar(contact: contact),
              titleSpacing: 0.0,
              centerTitle: false,
              brightness: Brightness.dark,
              bottom: tabTitles(),
            ),
            // TODO could maybe refactor this as well
            body: new StreamBuilder(
              stream: CloudDb.jobs.where("contactID", isEqualTo: contact.id).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingSpinner(),
                  );
                }

                final List<DocumentSnapshot> list = snapshot.data.documents;

                final jobs = list.map((item) => JobModel.fromDoc(item)).toList();

                return new TabBarView(
                  children: [
                    tabView(
                      name: TABS[0].toLowerCase(),
                      child: JobsListWidget(contact: contact),
                    ),
                    tabView(
                      name: TABS[1].toLowerCase(),
                      child: GalleryGridWidget(contact: contact, jobs: jobs),
                    ),
                    tabView(
                      name: TABS[2].toLowerCase(),
                      child: PaymentsListWidget(contact: contact, jobs: jobs),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget tabTitles() {
    return PreferredSize(
      child: Container(
        child: TabBar(
          labelStyle: ralewayMedium(14.0),
          tabs: [
            Tab(child: Text(TABS[0], style: TextStyle(color: Colors.white))),
            Tab(child: Text(TABS[1], style: TextStyle(color: Colors.white))),
            Tab(child: Text(TABS[2], style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(kTextTabBarHeight),
    );
  }

  Widget tabView({String name, Widget child}) {
    return new SafeArea(
      top: false,
      bottom: true,
      child: new Builder(
        builder: (BuildContext context) {
          return new CustomScrollView(
            key: new PageStorageKey<String>(name),
            slivers: <Widget>[
              new SliverPadding(
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
