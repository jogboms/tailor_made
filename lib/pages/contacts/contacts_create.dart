import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/utils/tm_validators.dart';

class ContactsCreatePage extends StatefulWidget {
  @override
  _ContactsCreatePageState createState() => new _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> with SnackBarProvider {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool isLoading = false;
  bool isSuccess = false;
  ContactModel contact;
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
    contact = new ContactModel();
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      // key: scaffoldKey,
      backgroundColor: theme.scaffoldColor,
      //   backgroundColor: Colors.grey.shade100,
      appBar: appBar(
        context,
        title: "Create Contacts",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 16.0),
            _buildAvatar(),
            SizedBox(height: 16.0),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Theme(
      data: ThemeData(hintColor: Colors.grey.shade400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Fullname",
                ),
                validator: validateAlpha(),
                onSaved: (fullname) => contact.fullname = fullname,
              ),
              SizedBox(height: 8.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Phone",
                ),
                validator: (value) => (value.length > 0) ? null : "Please input a value",
                onSaved: (phone) => contact.phone = phone,
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  labelText: "Location",
                ),
                validator: (value) => (value.length > 0) ? null : "Please input a value",
                onSaved: (location) => contact.location = location,
              ),
              SizedBox(height: 32.0),
              FlatButton(
                onPressed: _handleSubmit,
                child: Text("SUBMIT"),
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 158.0,
      height: 158.0,
      // margin: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.withOpacity(.5), width: 2.0),
      ),
      child: Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(.2),
        ),
        padding: EdgeInsets.all(4.0),
        child: Center(
          child: GestureDetector(
            onTap: _handlePhotoButtonPressed,
            child: isSuccess
                ? SizedBox.fromSize(
                    size: Size.square(150.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(contact.imageUrl),
                    ),
                  )
                // TODO
                // FadeInImage.assetNetwork()
                : isLoading
                    ? CircularProgressIndicator()
                    : CupertinoButton(
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.black.withOpacity(.35),
                        ),
                        onPressed: null,
                      ),
          ),
        ),
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
    var imageFile = await ImagePicker.pickImage(source: source, maxWidth: 200.0, maxHeight: 200.0);
    var random = new Random().nextInt(10000);
    var ref = FirebaseStorage.instance.ref().child('image_$random.jpg');
    var uploadTask = ref.putFile(imageFile);

    setState(() {
      isLoading = true;
      isSuccess = false;
    });
    try {
      contact.imageUrl = (await uploadTask.future).downloadUrl?.toString();
      setState(() {
        isLoading = false;
        isSuccess = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isSuccess = false;
      });
    }
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

      try {
        var data = await Cloudstore.contacts.add(contact.toMap());
        closeLoadingSnackBar();
        print(data);
        showInSnackBar("Successfully Added");
        _handleSuccess();
      } catch (e) {
        closeLoadingSnackBar();
        showInSnackBar(e.toString());
      }
    }
  }

  void _handleSuccess() async {
    var choice = await showChildDialog(
      context: context,
      child: new AlertDialog(
        content: Text("Do you wish to add another?"),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.pop(context, 1), child: Text("DISMISS")),
          FlatButton(onPressed: () => Navigator.pop(context, 2), child: Text("OK")),
        ],
      ),
    );
    if (choice == null) return;
    if (choice == 1) {
      Navigator.pop(context, true);
    } else {
      contact = new ContactModel();
      setState(() => isSuccess = false);
      _formKey.currentState.reset();
    }
  }
}
