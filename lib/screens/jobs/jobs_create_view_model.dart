import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/providers/snack_bar_provider.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/screens/jobs/jobs_create.dart';
import 'package:tailor_made/utils/ui/mk_image_choice_dialog.dart';

abstract class JobsCreateViewModel extends State<JobsCreatePage> with SnackBarProviderMixin {
  List<FireImage> fireImages = <FireImage>[];
  late JobModelBuilder job;
  ContactModel? contact;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool autovalidate = false;

  @override
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    job = JobModel(
      (JobModelBuilder b) => b
        ..userID = widget.userId
        ..contactID = contact?.id
        ..measurements = contact?.measurements?.toBuilder() ?? MapBuilder<String, double>(),
    ).toBuilder();
  }

  void handlePhotoButtonPressed() async {
    final ImageSource? source = await mkImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile == null) {
      return;
    }
    // TODO(Jogboms): move this out of here
    final Storage ref = Dependencies.di().jobs.createFile(File(imageFile.path), widget.userId)!;

    setState(() => fireImages.add(FireImage()..ref = ref));
    try {
      final String imageUrl = await ref.getDownloadURL();
      setState(() {
        fireImages.last
          ..isLoading = false
          ..isSucess = true
          ..image = ImageModel(
            (ImageModelBuilder b) => b
              ..userID = widget.userId
              ..contactID = contact!.id
              ..jobID = job.id
              ..src = imageUrl
              ..path = ref.path,
          );
      });
    } catch (e) {
      setState(() => fireImages.last.isLoading = false);
    }
  }

  void onSelectContact() async {
    final ContactModel? selectedContact = await Dependencies.di().contactsCoordinator.toContactsList(widget.contacts);
    if (selectedContact != null) {
      setState(() {
        contact = selectedContact;
        job
          ..contactID = contact?.id
          ..measurements = (contact?.measurements ?? BuiltMap<String, double>.from(<String, double>{})).toBuilder();
      });
    }
  }

  void handleSubmit() async {
    final FormState? form = formKey.currentState;
    if (form == null) {
      return;
    }

    if (!form.validate()) {
      autovalidate = true;
      showInSnackBar(MkStrings.fixErrors);
    } else {
      form.save();

      showLoadingSnackBar();

      job
        ..pendingPayment = job.price
        ..images = BuiltList<ImageModel>(
          fireImages.where((FireImage img) => img.image != null).map<ImageModel?>((FireImage img) => img.image),
        ).toBuilder()
        ..contactID = contact!.id;

      try {
        // TODO(Jogboms): move this out of here
        Dependencies.di().jobs.update(job.build(), widget.userId).listen((JobModel snap) {
          closeLoadingSnackBar();
          Dependencies.di().jobsCoordinator.toJob(snap);
        });
      } catch (e) {
        closeLoadingSnackBar();
        showInSnackBar(e.toString());
      }
    }
  }
}

class FireImage {
  late Storage ref;
  ImageModel? image;
  bool isLoading = true;
  bool isSucess = false;
}
