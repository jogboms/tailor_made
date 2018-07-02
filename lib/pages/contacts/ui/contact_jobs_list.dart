import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/jobs/jobs_list.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';

class JobsListWidget extends StatelessWidget {
  final ContactModel contact;

  JobsListWidget({@required this.contact});

  @override
  build(BuildContext context) {
    print(contact.toMap());
    return StreamBuilder(
      stream: Cloudstore.jobs.where("contact.id", isEqualTo: contact.id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverFillRemaining(
            child: loadingSpinner(),
          );
        }

        List<DocumentSnapshot> list = snapshot.data.documents;

        if (list.isEmpty) {
          return SliverFillRemaining(
            child: TMEmptyResult(message: "No jobs available"),
          );
        }

        return JobList(
          jobs: list.map((item) => JobModel.fromJson(item.data)).toList(),
        );
      },
    );
  }
}
