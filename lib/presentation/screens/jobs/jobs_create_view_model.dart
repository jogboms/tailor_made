import 'dart:io';

import 'package:clock/clock.dart';
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
  late ContactEntity? contact;
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
      createdAt: clock.now(),
      dueAt: clock.now().add(const Duration(days: 7)),
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
    final FileStorageReference ref = registry.get<Jobs>().createFile(File(imageFile.path), widget.userId)!;

    setState(() => fireImages.add(FireImage()..ref = ref));
    try {
      final String imageUrl = await ref.getDownloadURL();
      setState(() {
        final String id = const Uuid().v4();
        fireImages.last
          ..isLoading = false
          ..isSucess = true
          ..image = ImageEntity(
            reference: ReferenceEntity(
              id: id,
              path: id, // TODO
            ),
            userID: widget.userId,
            contactID: contact!.id,
            jobID: job.id,
            src: imageUrl,
            path: ref.path,
            id: id,
            createdAt: clock.now(),
          );
      });
    } catch (e) {
      setState(() => fireImages.last.isLoading = false);
    }
  }

  void onSelectContact() async {
    final ContactEntity? selectedContact =
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
        images: List<ImageEntity>.from(
          fireImages.where((FireImage img) => img.image != null).map<ImageEntity?>((FireImage img) => img.image),
        ),
        contactID: contact!.id,
      );

      try {
        // TODO(Jogboms): move this out of here
        final Registry registry = context.registry;
        final JobEntity result = await registry.get<Jobs>().create(widget.userId, job);
        snackBar.hide();
        registry.get<JobsCoordinator>().toJob(result, replace: true);
      } catch (e) {
        snackBar.error(e.toString());
      }
    }
  }
}

class FireImage {
  late FileStorageReference ref;
  ImageEntity? image;
  bool isLoading = true;
  bool isSucess = false;
}
