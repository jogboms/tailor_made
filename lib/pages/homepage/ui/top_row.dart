import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/contacts.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/jobs/jobs.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TopRowWidget extends StatelessWidget {
  final List<JobModel> jobs;
  final List<ContactModel> contacts;

  TopRowWidget({
    Key key,
    @required this.jobs,
    @required this.contacts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 120.0,
      decoration: new BoxDecoration(
        border: new Border(bottom: TMBorderSide()),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: new BoxDecoration(
                border: new Border(right: TMBorderSide()),
              ),
              child: TMGridTile(
                icon: Icons.supervisor_account,
                color: Colors.orangeAccent,
                title: "Clients",
                subTitle: "${contacts.length} Contacts",
                onPressed: () => TMNavigate(context, ContactsPage(contacts: contacts)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: TMGridTile(
                icon: Icons.usb,
                color: Colors.greenAccent.shade400,
                title: "Jobs",
                subTitle: "${jobs.length} Total",
                onPressed: () => TMNavigate(context, JobsPage(jobs: jobs, contacts: contacts)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
