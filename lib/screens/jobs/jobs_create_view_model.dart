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
  List<_FireImage> fireImages = [];
  JobModelBuilder job;
  ContactModel contact;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool autovalidate = false;

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    job = JobModel(
      (b) => b
        ..userID = widget.userId
        ..contactID = contact?.id
        ..measurements = contact?.measurements?.toBuilder(),
    ).toBuilder();
  }

  void handlePhotoButtonPressed() async {
    final source = await mkImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile == null) {
      return;
    }
    final ref = Dependencies.di().jobs.createFile(imageFile, widget.userId);

    setState(() => fireImages.add(_FireImage()..ref = ref));
    try {
      final imageUrl = (await ref.getDownloadURL()).downloadUrl?.toString();
      setState(() {
        fireImages.last
          ..isLoading = false
          ..isSucess = true
          ..image = ImageModel(
            (b) => b
              ..userID = widget.userId
              ..contactID = contact.id
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
    final selectedContact = await Dependencies.di().contactsCoordinator.toContactsList(widget.contacts);
    if (selectedContact != null) {
      setState(() {
        contact = selectedContact;
        job
          ..contactID = contact?.id
          ..measurements = (contact?.measurements ?? BuiltMap.from(<String, double>{})).toBuilder();
      });
    }
  }

  void handleSubmit() async {
    final FormState form = formKey.currentState;
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
        ..images =
            BuiltList<ImageModel>(fireImages.where((img) => img.image != null).map<ImageModel>((img) => img.image))
                .toBuilder()
        ..contactID = contact.id;

      try {
        Dependencies.di().jobs.update(job.build(), widget.userId).listen((snap) {
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

class _FireImage {
  Storage ref;
  ImageModel image;
  bool isLoading = true;
  bool isSucess = false;
}
