import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/constants.dart';
import 'package:tailor_made/presentation/providers.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({
    super.key,
    required this.contact,
    required this.onHandleSubmit,
    required this.userId,
  });

  final ValueSetter<ContactModel> onHandleSubmit;
  final ContactModel? contact;
  final String userId;

  @override
  ContactFormState createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late ContactModel contact;
  bool _autovalidate = false;
  Storage? _lastImgRef;
  TextEditingController? _fNController, _pNController, _lNController;
  final FocusNode _pNFocusNode = FocusNode(), _locFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // TODO(Jogboms): look into this
    contact = widget.contact!;
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
          _Avatar(contact: contact, isLoading: isLoading, onTap: _handlePhotoButtonPressed),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _fNController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.person), labelText: 'Fullname'),
                    validator: InputValidator.tryAlpha(),
                    onSaved: (String? fullname) => contact = contact.copyWith(fullname: fullname!.trim()),
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_pNFocusNode),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    focusNode: _pNFocusNode,
                    controller: _pNController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.phone), labelText: 'Phone'),
                    validator: (String? value) => (value!.isNotEmpty) ? null : 'Please input a value',
                    onSaved: (String? phone) => contact = contact.copyWith(phone: phone!.trim()),
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_locFocusNode),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    focusNode: _locFocusNode,
                    controller: _lNController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.location_city), labelText: 'Location'),
                    validator: (String? value) => (value!.isNotEmpty) ? null : 'Please input a value',
                    onSaved: (String? location) => contact = contact.copyWith(location: location!.trim()),
                    onFieldSubmitted: (String value) => _handleSubmit(),
                  ),
                  const SizedBox(height: 32.0),
                  PrimaryButton(onPressed: _handleSubmit, child: const Text('SUBMIT')),
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
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true;
      SnackBarProvider.of(context).show(AppStrings.fixErrors);
    } else {
      form.save();
      widget.onHandleSubmit(contact);
    }
  }

  Future<void> _handlePhotoButtonPressed() async {
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source, maxWidth: 200.0, maxHeight: 200.0);
    if (imageFile == null) {
      return;
    }
    // TODO(Jogboms): move this out of here
    final Storage ref = Dependencies.di().contacts.createFile(File(imageFile.path), widget.userId)!;

    setState(() => isLoading = true);
    try {
      contact = contact.copyWith(imageUrl: await ref.getDownloadURL());
      if (mounted) {
        SnackBarProvider.of(context).show('Upload Successful');
        setState(() {
          if (_lastImgRef != null) {
            _lastImgRef!.delete();
          }
          isLoading = false;
          _lastImgRef = ref;
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarProvider.of(context).show('Please try again');
        setState(() => isLoading = false);
      }
    }
  }

  void reset() => _formKey.currentState!.reset();

  void updateContact(ContactModel contact) {
    setState(() {
      reset();
      _fNController!.text = contact.fullname;
      _pNController!.text = contact.phone ?? '';
      _lNController!.text = contact.location ?? '';
    });
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.contact,
    required this.isLoading,
    required this.onTap,
  });

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
        border: Border.all(color: AppColors.primary, width: 2.0),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimarySwatch.shade100),
        child: Center(
          child: GestureDetector(
            onTap: onTap,
            child: SizedBox.fromSize(
              size: const Size.square(120.0),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (contact.imageUrl != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(contact.imageUrl!),
                      backgroundColor: kPrimarySwatch.shade100,
                    ),
                  if (isLoading)
                    const LoadingSpinner()
                  else
                    const AppClearButton(
                      onPressed: null,
                      child: Icon(Icons.add_a_photo, color: Colors.white),
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
