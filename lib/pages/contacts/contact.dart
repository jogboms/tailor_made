import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/pages/contacts/ui/contact_appbar.dart';
import 'package:tailor_made/pages/contacts/ui/contact_gallery_grid.dart';
import 'package:tailor_made/pages/contacts/ui/contact_jobs_list.dart';
import 'package:tailor_made/pages/contacts/ui/contact_payments_list.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const TABS = const ["Jobs", "Gallery", "Payments"];

class ContactPage extends StatefulWidget {
  final ContactModel contact;

  ContactPage({
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

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      body: new DefaultTabController(
        length: 3,
        child: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: new SliverAppBar(
                  backgroundColor: kAccentColor,
                  automaticallyImplyLeading: false,
                  title: new ContactAppBar(contact: widget.contact),
                  pinned: true,
                  titleSpacing: 0.0,
                  centerTitle: false,
                  expandedHeight: 0.0,
                  forceElevated: true,
                  bottom: tabTitles(),
                ),
              ),
            ];
          },
          body: StreamBuilder(
            stream: Cloudstore.jobs.where("contactID", isEqualTo: widget.contact.id).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: loadingSpinner(),
                );
              }

              List<DocumentSnapshot> list = snapshot.data.documents;

              final jobs = list.map((item) => JobModel.fromDoc(item)).toList();

              return new TabBarView(
                children: [
                  tabView(
                    name: TABS[0].toLowerCase(),
                    child: JobsListWidget(contact: widget.contact),
                  ),
                  tabView(
                    name: TABS[1].toLowerCase(),
                    child: GalleryGridWidget(contact: widget.contact, jobs: jobs),
                  ),
                  tabView(
                    name: TABS[2].toLowerCase(),
                    child: PaymentsListWidget(contact: widget.contact, jobs: jobs),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget tabTitles() {
  return PreferredSize(
    child: Container(
      child: TabBar(
        labelStyle: ralewayMedium(14.0),
        tabs: [
          Tab(child: Text(TABS[0])),
          Tab(child: Text(TABS[1])),
          Tab(child: Text(TABS[2])),
        ],
      ),
    ),
    preferredSize: Size.fromHeight(kTextTabBarHeight),
  );
}

Widget tabView({name: String, child: Widget}) {
  return new SafeArea(
    top: false,
    bottom: true,
    child: new Builder(
      builder: (BuildContext context) {
        return new CustomScrollView(
          key: new PageStorageKey<String>(name),
          slivers: <Widget>[
            new SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
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
