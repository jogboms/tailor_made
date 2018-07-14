import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/services/cloud_storage.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_image_choice_dialog.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/utils/tm_validators.dart';

class ContactForm extends StatefulWidget {
  final void Function(ContactModel) onHandleSubmit;
  final ContactModel contact;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ContactForm({
    Key key,
    @required this.contact,
    @required this.onHandleSubmit,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  ContactFormState createState() {
    return new ContactFormState();
  }
}

class ContactFormState extends State<ContactForm> with SnackBarProvider {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool isLoading = false;
  ContactModel contact;
  bool _autovalidate = false;
  StorageReference _lastImgRef;

  get scaffoldKey => widget.scaffoldKey;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 32.0),
          _buildAvatar(),
          SizedBox(height: 16.0),
          _buildForm(),
        ],
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                initialValue: contact.fullname,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Fullname",
                ),
                validator: validateAlpha(),
                onSaved: (fullname) => contact.fullname = fullname.trim(),
              ),
              SizedBox(height: 4.0),
              TextFormField(
                initialValue: contact.phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Phone",
                ),
                validator: (value) => (value.length > 0) ? null : "Please input a value",
                onSaved: (phone) => contact.phone = phone.trim(),
              ),
              SizedBox(height: 4.0),
              TextFormField(
                initialValue: contact.location,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  labelText: "Location",
                ),
                validator: (value) => (value.length > 0) ? null : "Please input a value",
                onSaved: (location) => contact.location = location.trim(),
              ),
              SizedBox(height: 32.0),
              RaisedButton(
                color: kAccentColor,
                shape: StadiumBorder(),
                onPressed: _handleSubmit,
                child: Text(
                  "SUBMIT",
                  style: TextStyle(color: Colors.white),
                ),
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
      alignment: Alignment.center,
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: kPrimarySwatch.shade200, width: 2.0),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimarySwatch.shade100,
        ),
        child: Center(
          child: GestureDetector(
            onTap: _handlePhotoButtonPressed,
            child: SizedBox.fromSize(
              size: Size.square(120.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  contact.imageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(contact.imageUrl),
                          backgroundColor: kPrimarySwatch.shade100,
                        )
                      : SizedBox(),
                  isLoading
                      ? loadingSpinner()
                      : CupertinoButton(
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                          onPressed: null,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      widget.onHandleSubmit(contact);
    }
  }

  Future<Null> _handlePhotoButtonPressed() async {
    final source = await imageChoiceDialog(context: context);
    if (source == null) return;
    final imageFile = await ImagePicker.pickImage(source: source, maxWidth: 200.0, maxHeight: 200.0);
    final ref = CloudStorage.createContact();
    final uploadTask = ref.putFile(imageFile);

    setState(() => isLoading = true);
    try {
      contact.imageUrl = (await uploadTask.future).downloadUrl?.toString();
      setState(() {
        if (_lastImgRef != null) {
          _lastImgRef.delete();
        }
        isLoading = false;
        _lastImgRef = ref;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  reset() => _formKey.currentState.reset();
}
