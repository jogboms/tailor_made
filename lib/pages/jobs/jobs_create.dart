import 'dart:async';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/gallery/models/image.model.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/pages/jobs/models/measure.model.dart';
import 'package:tailor_made/pages/jobs/ui/gallery_grids.dart';
import 'package:tailor_made/pages/jobs/ui/job_create_item.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/avatar_app_bar.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const _kGridWidth = 85.0;

class FireImage {
  StorageReference ref;
  String imageUrl;
  bool isLoading = true;
  bool isSucess = false;
}

class VM {}

class JobsCreatePage extends StatefulWidget {
  final ContactModel contact;
  final List<ContactModel> contacts;

  JobsCreatePage({
    Key key,
    this.contact,
    this.contacts = const [],
  }) : super(key: key);

  @override
  _JobsCreatePageState createState() => new _JobsCreatePageState();
}

class _JobsCreatePageState extends State<JobsCreatePage> with SnackBarProvider, VM {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<FireImage> fireImages = [];
  JobModel job;

  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
    job = new JobModel(
      contact: widget.contact,
      measurements: [
        MeasureModel(name: "Arm Hole", type: MeasureModelType.blouse),
        MeasureModel(name: "Shoulder", type: MeasureModelType.blouse),
        MeasureModel(name: "Burst", type: MeasureModelType.blouse),
        MeasureModel(name: "Burst Point", type: MeasureModelType.blouse),
        MeasureModel(name: "Shoulder - Burst Point", type: MeasureModelType.blouse),
        MeasureModel(name: "Shoulder - Under Burst", type: MeasureModelType.blouse),
        MeasureModel(name: "Shoulder - Waist", type: MeasureModelType.blouse),
        MeasureModel(name: "Length", type: MeasureModelType.trouser),
        MeasureModel(name: "Waist", type: MeasureModelType.trouser),
        MeasureModel(name: "Crouch", type: MeasureModelType.trouser),
        MeasureModel(name: "Thigh", type: MeasureModelType.trouser),
        MeasureModel(name: "Body Rise", type: MeasureModelType.trouser),
        MeasureModel(name: "Width", type: MeasureModelType.trouser),
        MeasureModel(name: "Hip", type: MeasureModelType.trouser),
        MeasureModel(name: "Full Length", type: MeasureModelType.skirts),
        MeasureModel(name: "Short Length", type: MeasureModelType.skirts),
        MeasureModel(name: "Knee Length", type: MeasureModelType.skirts),
        MeasureModel(name: "Hip", type: MeasureModelType.skirts),
        MeasureModel(name: "Waist", type: MeasureModelType.gown),
        MeasureModel(name: "Long Length", type: MeasureModelType.gown),
        MeasureModel(name: "Short Length", type: MeasureModelType.gown),
        MeasureModel(name: "Knee Length", type: MeasureModelType.gown),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<Widget> children = [];

    Widget makeHeader(String title, [String trailing = ""]) {
      return new Container(
        color: Colors.grey[100].withOpacity(.4),
        margin: const EdgeInsets.only(top: 8.0),
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
        alignment: AlignmentDirectional.centerStart,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title.toUpperCase(), style: ralewayLight(12.0, textBaseColor.shade800)),
            Text(trailing, style: ralewayLight(12.0, textBaseColor.shade800)),
          ],
        ),
      );
    }

    if (widget.contact != null) {
      children.add(makeHeader("Style Name"));
      children.add(buildEnterName());

      children.add(makeHeader("Payment", "Naira (₦)"));
      children.add(buildEnterAmount());

      children.add(makeHeader("References"));
      children.add(buildImageGrid());

      children.add(makeHeader("Measurements", "Inches (In)"));
      children.add(JobMeasures(job));

      children.add(makeHeader("Additional Notes"));
      children.add(buildAdditional());

      children.add(
        Padding(
          child: RaisedButton(
            color: accentColor,
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
      body: buildBody(children),
    );
  }

  Widget buildBody(List<Widget> children) {
    return widget.contact != null
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
            child: FlatButton(
              onPressed: () {},
              child: Text("SELECT A CLIENT"),
            ),
          );
  }

  PreferredSizeWidget buildAppBar(TMTheme theme) {
    return widget.contact != null
        ? AvatarAppBar(
            tag: widget.contact.imageUrl,
            image: NetworkImage(widget.contact.imageUrl),
            title: new Text(
              widget.contact.fullname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ralewayRegular(18.0, theme.appBarColor),
            ),
            subtitle: Text("${widget.contact.totalJobs} Jobs", style: theme.smallTextStyle),
          )
        : appBar(context);
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showLoadingSnackBar();

      job.images = fireImages
          .map((img) => ImageModel(
                src: img.imageUrl,
                path: img.ref.path,
                contact: widget.contact,
              ))
          .toList();
      try {
        var data = await Cloudstore.jobs.add(job.toMap());
        closeLoadingSnackBar();
        print(data);
        showInSnackBar("Successfully Added");
        form.reset();
        fireImages.clear();
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
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        maxLines: 6,
        decoration: new InputDecoration(
          isDense: true,
          hintText: "Fabric color, size, special requirements...",
          hintStyle: TextStyle(fontSize: 14.0),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderSideColor,
              width: 0.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        onSaved: (value) => job.notes = value,
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
              color: textBaseColor.withOpacity(.35),
            ),
          ),
        ),
      );
    }

    List<Widget> imagesList = List.generate(
      fireImages.length,
      (int index) {
        final fireImage = fireImages[index];
        final image = fireImage.imageUrl;

        if (image == null) {
          return Center(widthFactor: 2.5, child: CircularProgressIndicator());
        }

        return GalleryGrid(
          imageUrl: image,
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
    var source = await showChildDialog(
      context: context,
      child: new SimpleDialog(
        children: <Widget>[
          new SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Padding(child: Text("Camera"), padding: EdgeInsets.all(8.0)),
          ),
          new SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Padding(child: Text("Gallery"), padding: EdgeInsets.all(8.0)),
          ),
        ],
      ),
    );
    if (source == null) return;
    var imageFile = await ImagePicker.pickImage(source: source);
    var random = new Random().nextInt(10000);
    var ref = FirebaseStorage.instance.ref().child('references/image_$random.jpg');
    var uploadTask = ref.putFile(imageFile);

    setState(() {
      fireImages.add(FireImage()..ref = ref);
    });
    try {
      var image = (await uploadTask.future).downloadUrl?.toString();
      setState(() {
        fireImages.last
          ..isLoading = false
          ..isSucess = true
          ..imageUrl = image;
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
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: new InputDecoration(
          isDense: true,
          hintText: "Enter Style Name",
          hintStyle: TextStyle(fontSize: 14.0),
          // border: InputBorder.none,
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderSideColor,
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        validator: (value) => (value.length > 0) ? null : "Please input a name",
        onSaved: (value) => job.name = value,
      ),
    );
  }

  Widget buildEnterAmount() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: new TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: new InputDecoration(
          isDense: true,
          hintText: "Enter Amount",
          hintStyle: TextStyle(fontSize: 14.0),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderSideColor,
              width: 0.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        validator: (value) => (value.length > 0) ? null : "Please input a price",
        onSaved: (value) => job.price = double.tryParse(value),
      ),
    );
  }
}
