import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/contacts.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/screens/contacts/ui/contact_appbar.dart';
import 'package:tailor_made/widgets/screens/contacts/ui/contact_gallery_grid.dart';
import 'package:tailor_made/widgets/screens/contacts/ui/contact_payments_list.dart';
import 'package:tailor_made/widgets/screens/jobs/jobs_list.dart';

const TABS = const ["Jobs", "Gallery", "Payments"];

class ContactPage extends StatefulWidget {
  const ContactPage({
    Key key,
    this.contact,
  }) : super(key: key);

  final ContactModel contact;

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, ContactsViewModel>(
      converter: (state) =>
          ContactsViewModel(state)..contactID = widget.contact.id,
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        ContactsViewModel viewModel,
      ) {
        // in the case of newly created contacts
        final contact = viewModel.selected ?? widget.contact;
        return DefaultTabController(
          length: TABS.length,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kAccentColor,
              automaticallyImplyLeading: false,
              title: ContactAppBar(
                contact: contact,
                grouped: viewModel.measuresGrouped,
              ),
              titleSpacing: 0.0,
              centerTitle: false,
              brightness: Brightness.dark,
              bottom: tabTitles(),
            ),
            body: _buildBody(viewModel, contact),
          ),
        );
      },
    );
  }

  Widget _buildBody(ContactsViewModel vm, ContactModel contact) {
    if (vm.isLoading) {
      return Center(
        child: const MkLoadingSpinner(),
      );
    }

    return TabBarView(
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
          labelStyle: mkFontMedium(14.0),
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
    return SafeArea(
      top: false,
      bottom: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            key: PageStorageKey<String>(name),
            slivers: <Widget>[
              SliverPadding(
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
