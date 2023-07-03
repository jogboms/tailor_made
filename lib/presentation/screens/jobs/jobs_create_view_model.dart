import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:registry/registry.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:uuid/uuid.dart';

import '../../routing.dart';
import 'widgets/image_form_value.dart';

@optionalTypeArgs
mixin JobsCreateViewModel<T extends StatefulWidget> on State<T> {
  @protected
  final List<ImageFormValue> images = <ImageFormValue>[];
  @protected
  late CreateJobData job;
  @protected
  late ContactEntity? contact;
  @protected
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @protected
  bool autovalidate = false;

  @protected
  String get userId;

  @protected
  ContactEntity? get defaultContact;

  @override
  void initState() {
    super.initState();
    contact = defaultContact;
    job = CreateJobData(
      id: const Uuid().v4(),
      userID: userId,
      contactID: contact?.id,
      measurements: contact?.measurements ?? <String, double>{},
      price: 0.0,
      createdAt: clock.now(),
      dueAt: clock.now().add(const Duration(days: 7)),
    );
  }

  void handlePhotoButtonPressed(ImageStorageProvider storage) async {
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile == null) {
      return;
    }

    try {
      final ImageFileReference ref = await storage.create(
        CreateImageType.reference,
        path: imageFile.path,
      );

      setState(() {
        images.add(
          ImageCreateFormValue(
            CreateImageData(
              userID: userId,
              contactID: contact!.id,
              jobID: job.id,
              src: ref.src,
              path: ref.path,
            ),
          ),
        );
      });
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
    }
  }

  void handleSelectContact(List<ContactEntity> contacts) async {
    final ContactEntity? selectedContact = await context.router.toContactsList(contacts);
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

  void handleDeleteImageItem(ImageStorageProvider storage, ImageFormValue value) async {
    final ImageFileReference reference = switch (value) {
      ImageCreateFormValue(:final CreateImageData data) => (src: data.src, path: data.path),
      ImageModifyFormValue(:final ImageEntity data) => (src: data.src, path: data.path),
    };
    await storage.delete(reference);
    if (mounted) {
      setState(() {
        images.remove(value);
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
        images: images
            .map(
              (ImageFormValue input) => switch (input) {
                ImageCreateFormValue() => CreateImageOperation(data: input.data),
                ImageModifyFormValue() => ModifyImageOperation(data: input.data),
              },
            )
            .toList(growable: false),
        contactID: contact!.id,
      );

      try {
        // TODO(Jogboms): move this out of here
        final Registry registry = context.registry;
        final AppRouter router = context.router;
        final JobEntity result = await registry.get<Jobs>().create(userId, job);
        snackBar.hide();
        router.toJob(result, replace: true);
      } catch (e) {
        snackBar.error(e.toString());
      }
    }
  }
}
