import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:uuid/uuid.dart';

import 'jobs_create.dart';

abstract class JobsCreateViewModel extends State<JobsCreatePage> with SnackBarProviderMixin {
  List<FireImage> fireImages = <FireImage>[];
  late JobModel job;
  late ContactModel? contact;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool autovalidate = false;

  @override
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    job = JobModel.fromDefaults(
      userID: widget.userId,
      contactID: contact?.id,
      measurements: contact?.measurements ?? <String, double>{},
    );
  }

  void handlePhotoButtonPressed() async {
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile == null) {
      return;
    }
    // TODO(Jogboms): move this out of here
    final Storage ref = Dependencies.di().get<Jobs>().createFile(File(imageFile.path), widget.userId)!;

    setState(() => fireImages.add(FireImage()..ref = ref));
    try {
      final String imageUrl = await ref.getDownloadURL();
      setState(() {
        fireImages.last
          ..isLoading = false
          ..isSucess = true
          ..image = ImageModel(
            userID: widget.userId,
            contactID: contact!.id,
            jobID: job.id,
            src: imageUrl,
            path: ref.path,
            id: const Uuid().v4(),
            createdAt: DateTime.now(),
          );
      });
    } catch (e) {
      setState(() => fireImages.last.isLoading = false);
    }
  }

  void onSelectContact() async {
    final ContactModel? selectedContact =
        await Dependencies.di().get<ContactsCoordinator>().toContactsList(widget.contacts);
    if (selectedContact != null) {
      setState(() {
        contact = selectedContact;
        job = job.copyWith(
          contactID: contact?.id,
          measurements: contact?.measurements ?? <String, double>{},
        );
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
      showInSnackBar(AppStrings.fixErrors);
    } else {
      form.save();

      showLoadingSnackBar();

      job = job.copyWith(
        pendingPayment: job.price,
        images: List<ImageModel>.from(
          fireImages.where((FireImage img) => img.image != null).map<ImageModel?>((FireImage img) => img.image),
        ),
        contactID: contact!.id,
      );

      try {
        // TODO(Jogboms): move this out of here
        Dependencies.di().get<Jobs>().update(job, widget.userId).listen((JobModel snap) {
          closeLoadingSnackBar();
          Dependencies.di().get<JobsCoordinator>().toJob(snap);
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
