import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/pages/jobs/job.dart';
import 'package:tailor_made/pages/jobs/ui/contact_lists.dart';
import 'package:tailor_made/pages/jobs/ui/gallery_grid_item.dart';
import 'package:tailor_made/pages/jobs/ui/measure_create_items.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/measures.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/services/cloud_storage.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/avatar_app_bar.dart';
import 'package:tailor_made/ui/full_button.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_image_choice_dialog.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const _kGridWidth = 85.0;

class FireImage {
  StorageReference ref;
  ImageModel image;
  bool isLoading = true;
  bool isSucess = false;
}

class JobsCreatePage extends StatefulWidget {
  final ContactModel contact;
  final List<ContactModel> contacts;

  const JobsCreatePage({
    Key key,
    this.contact,
    @required this.contacts,
  }) : super(key: key);

  @override
  _JobsCreatePageState createState() => new _JobsCreatePageState();
}

class _JobsCreatePageState extends State<JobsCreatePage> with SnackBarProvider {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<FireImage> fireImages = [];
  JobModel job;
  ContactModel contact;
  MoneyMaskedTextController controller = new MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  final FocusNode _amountFocusNode = new FocusNode();
  final FocusNode _additionFocusNode = new FocusNode();

  bool _autovalidate = false;

  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    job = new JobModel(
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
    final TMTheme theme = TMTheme.of(context);

    final List<Widget> children = [];

    Widget makeHeader(String title, [String trailing = ""]) {
      return new Container(
        color: Colors.grey[100].withOpacity(.4),
        margin: const EdgeInsets.only(top: 8.0),
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
        alignment: AlignmentDirectional.centerStart,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title.toUpperCase(),
                style: ralewayLight(12.0, kTextBaseColor.shade800)),
            Text(trailing, style: ralewayLight(12.0, kTextBaseColor.shade800)),
          ],
        ),
      );
    }

    if (contact != null) {
      children.add(makeHeader("Style Name"));
      children.add(buildEnterName());

      children.add(makeHeader("Payment", "Naira (₦)"));
      children.add(buildEnterAmount());

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

    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldColor,
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
    return StoreConnector<ReduxState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (BuildContext context, vm) {
        return MeasureCreateItems(
          grouped: vm.grouped,
          measurements: job.measurements,
        );
      },
    );
  }

  Widget buildBody(TMTheme theme, List<Widget> children) {
    return contact != null
        ? new SafeArea(
            top: false,
            child: new SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          )
        : new Center(
            child: CupertinoButton(
              onPressed: onSelectContact,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(.2),
                    radius: 50.0,
                    child: Icon(Icons.person_add, color: theme.textColor),
                  ),
                  SizedBox(height: 16.0),
                  Text("SELECT A CLIENT", style: theme.smallTextStyle),
                ],
              ),
            ),
          );
  }

  void onSelectContact() async {
    final selectedContact = await Navigator.push<ContactModel>(
      context,
      TMNavigate.fadeIn<ContactModel>(ContactLists(contacts: widget.contacts)),
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

  PreferredSizeWidget buildAppBar(TMTheme theme) {
    return contact != null
        ? AvatarAppBar(
            tag: contact.createdAt.toString(),
            imageUrl: contact.imageUrl,
            elevation: 1.0,
            backgroundColor: Colors.white,
            title: new Text(
              contact.fullname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ralewayBold(18.0, theme.appBarColor),
            ),
            subtitle:
                Text("${contact.totalJobs} Jobs", style: theme.smallTextStyle),
            actions: widget.contacts.isNotEmpty
                ? <Widget>[
                    IconButton(
                      icon: Icon(Icons.people),
                      onPressed: onSelectContact,
                    )
                  ]
                : null,
          )
        : appBar(context);
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) {
      return;
    }

    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();

      showLoadingSnackBar();

      job
        ..pendingPayment = job.price
        ..images = fireImages.map((img) => img.image).toList()
        ..contactID = contact.id;

      try {
        final ref = CloudDb.jobsRef.document(job.id);
        await ref.setData(job.toMap());
        ref.snapshots().listen((snap) {
          closeLoadingSnackBar();
          Navigator.pushReplacement<dynamic, dynamic>(
            context,
            TMNavigate.slideIn<String>(JobPage(job: JobModel.fromDoc(snap))),
          );
        });
      } catch (e) {
        closeLoadingSnackBar();
        showInSnackBar(e.toString());
      }
    }
  }

  Widget buildAdditional() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: new TextFormField(
        focusNode: _additionFocusNode,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        maxLines: 6,
        decoration: new InputDecoration(
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
      return new Container(
        width: _kGridWidth,
        margin: EdgeInsets.only(right: 8.0),
        child: new Material(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey[100],
          child: new InkWell(
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

    final List<Widget> imagesList = List.generate(
      fireImages.length,
      (int index) {
        final fireImage = fireImages[index];
        final image = fireImage.image;

        if (image == null) {
          return Center(widthFactor: 2.5, child: loadingSpinner());
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

    return new Container(
      height: _kGridWidth + 8,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: new ListView(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        scrollDirection: Axis.horizontal,
        children: [newGrid()]..addAll(imagesList.reversed.toList()),
      ),
    );
  }

  Future<Null> _handlePhotoButtonPressed() async {
    final source = await imageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile == null) {
      return;
    }
    final ref = CloudStorage.createReferenceImage();
    final uploadTask = ref.putFile(imageFile);

    setState(() {
      fireImages.add(FireImage()..ref = ref);
    });
    try {
      final imageUrl = (await uploadTask.future).downloadUrl?.toString();
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

  Widget buildEnterName() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: new TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: new InputDecoration(
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
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: new TextFormField(
        focusNode: _amountFocusNode,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: new InputDecoration(
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
