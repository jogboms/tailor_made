import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/contacts/ui/contact_appbar.dart';
import 'package:tailor_made/pages/contacts/ui/contact_gallery_grid.dart';
import 'package:tailor_made/pages/contacts/ui/contact_payments_list.dart';
import 'package:tailor_made/pages/jobs/jobs_list.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/contacts.dart';
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

    return StoreConnector<ReduxState, ContactsViewModel>(
      converter: (store) =>
          ContactsViewModel(store)..contactID = widget.contact.id,
      builder: (BuildContext context, vm) {
        // in the case of newly created contacts
        final contact = vm.selected ?? widget.contact;
        return new DefaultTabController(
          length: TABS.length,
          child: new Scaffold(
            backgroundColor: theme.scaffoldColor,
            appBar: new AppBar(
              backgroundColor: kAccentColor,
              automaticallyImplyLeading: false,
              title: new ContactAppBar(
                contact: contact,
                grouped: vm.measuresGrouped,
              ),
              titleSpacing: 0.0,
              centerTitle: false,
              brightness: Brightness.dark,
              bottom: tabTitles(),
            ),
            body: _buildBody(vm, contact),
          ),
        );
      },
    );
  }

  Widget _buildBody(ContactsViewModel vm, ContactModel contact) {
    if (vm.isLoading) {
      return Center(
        child: loadingSpinner(),
      );
    }

    return new TabBarView(
      children: [
        tabView(
          name: TABS[0].toLowerCase(),
          child: JobList(jobs: vm.selectedJobs),
        ),
        tabView(
          name: TABS[1].toLowerCase(),
          child: GalleryGridWidget(contact: contact, jobs: vm.selectedJobs),
        ),
        tabView(
          name: TABS[2].toLowerCase(),
          child: PaymentsListWidget(contact: contact, jobs: vm.selectedJobs),
        ),
      ],
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
