import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/firebase/cloud_storage.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/utils/mk_image_choice_dialog.dart';
import 'package:tailor_made/utils/mk_snackbar.dart';
import 'package:tailor_made/utils/mk_validators.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_partials/mk_primary_button.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({
    Key key,
    @required this.contact,
    @required this.onHandleSubmit,
  }) : super(key: key);

  final ValueSetter<ContactModel> onHandleSubmit;
  final ContactModel contact;

  @override
  ContactFormState createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  ContactModel contact;
  bool _autovalidate = false;
  StorageReference _lastImgRef;
  TextEditingController _fNController, _pNController, _lNController;
  final FocusNode _pNFocusNode = FocusNode(), _locFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    _fNController = TextEditingController(text: contact.fullname);
    _pNController = TextEditingController(text: contact.phone);
    _lNController = TextEditingController(text: contact.location);
  }

  @override
  void dispose() {
    _pNFocusNode.dispose();
    _locFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 32.0),
          _Avatar(
            contact: contact,
            isLoading: isLoading,
            onTap: _handlePhotoButtonPressed,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _fNController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: "Fullname",
                    ),
                    validator: MkValidate.tryAlpha(),
                    onSaved: (fullname) => contact.fullname = fullname.trim(),
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_pNFocusNode),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    focusNode: _pNFocusNode,
                    controller: _pNController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      labelText: "Phone",
                    ),
                    validator: (value) =>
                        (value.isNotEmpty) ? null : "Please input a value",
                    onSaved: (phone) => contact.phone = phone.trim(),
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_locFocusNode),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    focusNode: _locFocusNode,
                    controller: _lNController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      prefixIcon: const Icon(Icons.location_city),
                      labelText: "Location",
                    ),
                    validator: (value) =>
                        (value.isNotEmpty) ? null : "Please input a value",
                    onSaved: (location) => contact.location = location.trim(),
                    onFieldSubmitted: (value) => _handleSubmit(),
                  ),
                  const SizedBox(height: 32.0),
                  MkPrimaryButton(
                    onPressed: _handleSubmit,
                    child: const Text("SUBMIT"),
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    final FormState form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      MkSnackBar.of(context).show(MkStrings.fixErrors);
    } else {
      form.save();
      widget.onHandleSubmit(contact);
    }
  }

  Future<Null> _handlePhotoButtonPressed() async {
    final source = await mkImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final imageFile = await ImagePicker.pickImage(
        source: source, maxWidth: 200.0, maxHeight: 200.0);
    if (imageFile == null) {
      return;
    }
    final ref = CloudStorage.createContactImage()..putFile(imageFile);

    setState(() => isLoading = true);
    try {
      contact.imageUrl = (await ref.getDownloadURL()).downloadUrl?.toString();
      if (mounted) {
        MkSnackBar.of(context).show("Upload Successful");
        setState(() {
          if (_lastImgRef != null) {
            _lastImgRef.delete();
          }
          isLoading = false;
          _lastImgRef = ref;
        });
      }
    } catch (e) {
      if (mounted) {
        MkSnackBar.of(context).show("Please try again");
        setState(() => isLoading = false);
      }
    }
  }

  void reset() => _formKey.currentState.reset();

  void updateContact(ContactModel _contact) {
    setState(() {
      reset();
      contact = _contact;
      _fNController.text = contact.fullname ?? "";
      _pNController.text = contact.phone ?? "";
      _lNController.text = contact.location ?? "";
    });
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    Key key,
    @required this.contact,
    @required this.isLoading,
    @required this.onTap,
  }) : super(key: key);

  final ContactModel contact;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: MkColors.primary,
          width: 2.0,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimarySwatch.shade100,
        ),
        child: Center(
          child: GestureDetector(
            onTap: onTap,
            child: SizedBox.fromSize(
              size: const Size.square(120.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  contact.imageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(contact.imageUrl),
                          backgroundColor: kPrimarySwatch.shade100,
                        )
                      : const SizedBox(),
                  isLoading
                      ? const MkLoadingSpinner()
                      : MkClearButton(
                          child: const Icon(
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
}
