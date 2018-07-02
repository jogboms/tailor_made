import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/contacts/ui/contact_appbar.dart';
import 'package:tailor_made/pages/contacts/ui/contact_gallery_grid.dart';
import 'package:tailor_made/pages/contacts/ui/contact_jobs_list.dart';
import 'package:tailor_made/pages/contacts/ui/contact_payments_list.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const TABS = const ["Jobs", "Gallery", "Payments"];

class Contact extends StatefulWidget {
  final ContactModel contact;

  Contact({this.contact});

  @override
  _ContactState createState() => new _ContactState();
}

class _ContactState extends State<Contact> {
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
                  backgroundColor: accentColor,
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
            stream: Cloudstore.jobs.where("contact.id", isEqualTo: widget.contact.id).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: loadingSpinner(),
                );
              }

              List<DocumentSnapshot> list = snapshot.data.documents;

              final jobs = list.map((item) => JobModel.fromJson(item.data)).toList();

              return new TabBarView(
                children: [
                  tabView(name: TABS[0].toLowerCase(), child: JobsListWidget(contact: widget.contact, jobs: jobs)),
                  tabView(name: TABS[1].toLowerCase(), child: GalleryGridWidget(contact: widget.contact, jobs: jobs)),
                  tabView(name: TABS[2].toLowerCase(), child: PaymentsListWidget(contact: widget.contact, jobs: jobs)),
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
        indicatorSize: TabBarIndicatorSize.label,
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
