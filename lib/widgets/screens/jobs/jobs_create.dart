import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/measures.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/services/cloud_storage.dart';
import 'package:tailor_made/utils/mk_image_choice_dialog.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_snackbar_provider.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/avatar_app_bar.dart';
import 'package:tailor_made/widgets/_partials/full_button.dart';
import 'package:tailor_made/widgets/_partials/input_dropdown.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/screens/jobs/job.dart';
import 'package:tailor_made/widgets/screens/jobs/ui/contact_lists.dart';
import 'package:tailor_made/widgets/screens/jobs/ui/gallery_grid_item.dart';
import 'package:tailor_made/widgets/screens/measures/ui/measure_create_items.dart';

const _kGridWidth = 85.0;

class FireImage {
  StorageReference ref;
  ImageModel image;
  bool isLoading = true;
  bool isSucess = false;
}

class JobsCreatePage extends StatefulWidget {
  const JobsCreatePage({
    Key key,
    this.contact,
    @required this.contacts,
  }) : super(key: key);

  final ContactModel contact;
  final List<ContactModel> contacts;

  @override
  _JobsCreatePageState createState() => _JobsCreatePageState();
}

class _JobsCreatePageState extends State<JobsCreatePage>
    with MkSnackBarProvider {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<FireImage> fireImages = [];
  JobModel job;
  ContactModel contact;
  MoneyMaskedTextController controller = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _additionFocusNode = FocusNode();

  bool _autovalidate = false;

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    job = JobModel(
      contactID: contact?.id,
      measurements: contact?.measurements ?? {},
    );
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _additionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    final List<Widget> children = [];

    Widget makeHeader(String title, [String trailing = ""]) {
      return Container(
        color: Colors.grey[100].withOpacity(.4),
        margin: const EdgeInsets.only(top: 8.0),
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title.toUpperCase(),
              style: mkFontLight(12.0, kTextBaseColor),
            ),
            Text(
              trailing,
              style: mkFontLight(12.0, kTextBaseColor),
            ),
          ],
        ),
      );
    }

    if (contact != null) {
      children.add(makeHeader("Style Name"));
      children.add(buildEnterName());

      children.add(makeHeader("Payment", "Naira (₦)"));
      children.add(buildEnterAmount());

      children.add(makeHeader("Due Date"));
      children.add(buildDueDate());

      children.add(makeHeader("References"));
      children.add(buildImageGrid());

      children.add(makeHeader("Measurements", "Inches (In)"));
      children.add(buildCreateMeasure());

      children.add(makeHeader("Additional Notes"));
      children.add(buildAdditional());

      children.add(
        Padding(
          child: FullButton(
            child: Text(
              "FINISH",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _handleSubmit,
          ),
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 50.0),
        ),
      );

      children.add(SizedBox(height: 32.0));
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: buildAppBar(theme),
      body: Theme(
        data: ThemeData(
          hintColor: kHintColor,
          primaryColor: kPrimaryColor,
        ),
        child: buildBody(theme, children),
      ),
    );
  }

  Widget buildCreateMeasure() {
    return ViewModelSubscriber<AppState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        vm,
      ) {
        return MeasureCreateItems(
          grouped: vm.grouped,
          measurements: job.measurements,
        );
      },
    );
  }

  Widget buildBody(MkTheme theme, List<Widget> children) {
    return contact != null
        ? SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          )
        : Center(
            child: CupertinoButton(
              onPressed: onSelectContact,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(.2),
                    radius: 50.0,
                    child: Icon(Icons.person_add, color: kTextBaseColor),
                  ),
                  SizedBox(height: 16.0),
                  Text("SELECT A CLIENT", style: theme.small),
                ],
              ),
            ),
          );
  }

  void onSelectContact() async {
    final selectedContact = await Navigator.push<ContactModel>(
      context,
      MkNavigate.fadeIn<ContactModel>(ContactLists(contacts: widget.contacts)),
    );
    if (selectedContact != null) {
      setState(() {
        contact = selectedContact;
        job = job.copyWith(
          contactID: contact?.id,
          measurements: contact?.measurements ?? {},
        );
      });
    }
  }

  PreferredSizeWidget buildAppBar(MkTheme theme) {
    return contact != null
        ? AvatarAppBar(
            tag: contact.createdAt.toString(),
            imageUrl: contact.imageUrl,
            elevation: 1.0,
            backgroundColor: Colors.white,
            title: Text(
              contact.fullname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: mkFontBold(18.0, theme.appBarTitle.color),
            ),
            subtitle: Text("${contact.totalJobs} Jobs", style: theme.small),
            actions: widget.contacts.isNotEmpty
                ? <Widget>[
                    IconButton(
                      icon: Icon(Icons.people),
                      onPressed: onSelectContact,
                    )
                  ]
                : null,
          )
        : MkAppBar(title: Text(""));
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) {
      return;
    }

    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar(MkStrings.fixErrors);
    } else {
      form.save();

      showLoadingSnackBar();

      job
        ..pendingPayment = job.price
        ..images = fireImages
            .where((img) => img.image != null)
            .map((img) => img.image)
            .toList()
        ..contactID = contact.id;

      try {
        final ref = CloudDb.jobsRef.document(job.id);
        await ref.setData(job.toMap());
        ref.snapshots().listen((snap) {
          closeLoadingSnackBar();
          Navigator.pushReplacement<dynamic, dynamic>(
            context,
            MkNavigate.slideIn<String>(JobPage(job: JobModel.fromDoc(snap))),
          );
        });
      } catch (e) {
        closeLoadingSnackBar();
        showInSnackBar(e.toString());
      }
    }
  }

  Widget buildAdditional() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        focusNode: _additionFocusNode,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        maxLines: 6,
        decoration: InputDecoration(
          isDense: true,
          hintText: "Fabric color, size, special requirements...",
          hintStyle: TextStyle(fontSize: 14.0),
        ),
        onSaved: (value) => job.notes = value.trim(),
        onFieldSubmitted: (value) => _handleSubmit(),
      ),
    );
  }

  Container buildImageGrid() {
    Widget newGrid() {
      return Container(
        width: _kGridWidth,
        margin: EdgeInsets.only(right: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey[100],
          child: InkWell(
            onTap: _handlePhotoButtonPressed,
            child: Icon(
              Icons.add_a_photo,
              size: 24.0,
              color: kTextBaseColor.withOpacity(.35),
            ),
          ),
        ),
      );
    }

    final List<Widget> imagesList = List<Widget>.generate(
      fireImages.length,
      (int index) {
        final fireImage = fireImages[index];
        final image = fireImage.image;

        if (image == null) {
          return Center(widthFactor: 2.5, child: const MkLoadingSpinner());
        }

        return GalleryGridItem(
          image: image,
          tag: "$image-$index",
          size: _kGridWidth,
          onTapDelete: (image) {
            setState(() {
              fireImage.ref.delete();
              fireImages.removeAt(index);
            });
          },
        );
      },
    ).toList();

    return Container(
      height: _kGridWidth + 8,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        scrollDirection: Axis.horizontal,
        children: [newGrid()]..addAll(imagesList.reversed.toList()),
      ),
    );
  }

  Future<Null> _handlePhotoButtonPressed() async {
    final source = await mkImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile == null) {
      return;
    }
    final ref = CloudStorage.createReferenceImage()..putFile(imageFile);

    setState(() {
      fireImages.add(FireImage()..ref = ref);
    });
    try {
      final imageUrl = (await ref.getDownloadURL()).downloadUrl?.toString();
      setState(() {
        fireImages.last
          ..isLoading = false
          ..isSucess = true
          ..image = ImageModel(
            contactID: contact.id,
            jobID: job.id,
            src: imageUrl,
            path: ref.path,
          );
        //
      });
    } catch (e) {
      setState(() {
        fireImages.last.isLoading = false;
      });
    }
  }

  Widget buildDueDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InputDropdown(
        valueText: DateFormat.yMMMd().format(job.dueAt),
        valueStyle: TextStyle(fontSize: 18.0, color: Colors.black),
        onPressed: () async {
          final DateTime picked = await showDatePicker(
            context: context,
            initialDate: job.dueAt,
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
          );
          if (picked != null && picked != job.dueAt) {
            setState(() {
              job = job.copyWith(dueAt: picked);
            });
          }
        },
      ),
    );
  }

  Widget buildEnterName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: InputDecoration(
          isDense: true,
          hintText: "Enter Style Name",
          hintStyle: TextStyle(fontSize: 14.0),
        ),
        validator: (value) => (value.isNotEmpty) ? null : "Please input a name",
        onSaved: (value) => job.name = value.trim(),
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(_amountFocusNode),
      ),
    );
  }

  Widget buildEnterAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        focusNode: _amountFocusNode,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: InputDecoration(
          isDense: true,
          hintText: "Enter Amount",
          hintStyle: TextStyle(fontSize: 14.0),
        ),
        validator: (value) =>
            (controller.numberValue > 0) ? null : "Please input a price",
        onSaved: (value) => job.price = controller.numberValue,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(_additionFocusNode),
      ),
    );
  }
}
