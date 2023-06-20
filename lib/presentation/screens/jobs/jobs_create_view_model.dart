import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:uuid/uuid.dart';

import 'jobs_create.dart';

abstract class JobsCreateViewModel extends State<JobsCreatePage> {
  @protected
  List<FireImage> fireImages = <FireImage>[];
  @protected
  late CreateJobData job;
  @protected
  late ContactModel? contact;
  @protected
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @protected
  bool autovalidate = false;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    job = CreateJobData(
      id: const Uuid().v4(),
      userID: widget.userId,
      contactID: contact?.id,
      measurements: contact?.measurements ?? <String, double>{},
      price: 0.0,
      createdAt: DateTime.now(),
      dueAt: DateTime.now().add(const Duration(days: 7)),
    );
  }

  void handlePhotoButtonPressed() async {
    final Registry registry = context.registry;
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile == null) {
      return;
    }
    // TODO(Jogboms): move this out of here
    final Storage ref = registry.get<Jobs>().createFile(File(imageFile.path), widget.userId)!;

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
        await context.registry.get<ContactsCoordinator>().toContactsList(widget.contacts);
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

    final AppSnackBar snackBar = AppSnackBar.of(context);
    if (!form.validate()) {
      autovalidate = true;
      snackBar.info(AppStrings.fixErrors);
    } else {
      form.save();

      snackBar.loading();

      job = job.copyWith(
        pendingPayment: job.price,
        images: List<ImageModel>.from(
          fireImages.where((FireImage img) => img.image != null).map<ImageModel?>((FireImage img) => img.image),
        ),
        contactID: contact!.id,
      );

      try {
        // TODO(Jogboms): move this out of here
        final Registry registry = context.registry;
        final JobEntity result = await registry.get<Jobs>().create(widget.userId, job);
        snackBar.hide();
        registry.get<JobsCoordinator>().toJob(result);
      } catch (e) {
        snackBar.error(e.toString());
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
