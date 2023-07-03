import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:registry/registry.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({
    super.key,
    required this.contact,
    required this.onHandleSubmit,
    required this.userId,
  });

  final ValueSetter<CreateContactData> onHandleSubmit;
  final CreateContactData contact;
  final String userId;

  @override
  ContactFormState createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late CreateContactData _contact = widget.contact;
  bool _autovalidate = false;
  ImageFileReference? _previousImageFileRef;
  late final TextEditingController _fNController = TextEditingController(text: _contact.fullname);
  late final TextEditingController _pNController = TextEditingController(text: _contact.phone);
  late final TextEditingController _lNController = TextEditingController(text: _contact.location);

  @override
  void didUpdateWidget(covariant ContactForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contact != widget.contact) {
      _contact = widget.contact;
    }
  }

  @override
  void dispose() {
    _fNController.dispose();
    _pNController.dispose();
    _lNController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 32.0),
          _Avatar(imageUrl: _contact.imageUrl, isLoading: _isLoading, onTap: _handlePhotoButtonPressed),
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
                    onSaved: (String? fullname) => _contact = _contact.copyWith(fullname: fullname!.trim()),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    controller: _pNController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.phone), labelText: 'Phone'),
                    validator: InputValidator.tryString('Please input a value'),
                    onSaved: (String? phone) => _contact = _contact.copyWith(phone: phone!.trim()),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    controller: _lNController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.location_city), labelText: 'Location'),
                    validator: InputValidator.tryString('Please input a value'),
                    onSaved: (String? location) => _contact = _contact.copyWith(location: location!.trim()),
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
      AppSnackBar.of(context).error(AppStrings.fixErrors);
    } else {
      form.save();
      widget.onHandleSubmit(_contact);
    }
  }

  Future<void> _handlePhotoButtonPressed() async {
    final Registry registry = context.registry;
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source, maxWidth: 200.0, maxHeight: 200.0);
    if (imageFile == null) {
      return;
    }
    final ImageStorage imageStorage = registry.get();

    setState(() => _isLoading = true);
    try {
      // TODO(Jogboms): move this out of here
      final ImageFileReference ref = await imageStorage.createContactImage(path: imageFile.path, userId: widget.userId);
      _contact = _contact.copyWith(imageUrl: ref.src);
      if (mounted) {
        AppSnackBar.of(context).success('Upload Successful');
        if (_previousImageFileRef case final ImageFileReference ref) {
          imageStorage.delete(reference: ref, userId: widget.userId).ignore();
        }
        _previousImageFileRef = ref;
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.of(context).error('Please try again');
        setState(() => _isLoading = false);
      }
    }
  }

  void reset() => _formKey.currentState!.reset();

  void updateContact(CreateContactData contact) {
    setState(() {
      reset();
      _fNController.text = contact.fullname;
      _pNController.text = contact.phone;
      _lNController.text = contact.location;
    });
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.imageUrl,
    required this.isLoading,
    required this.onTap,
  });

  final String? imageUrl;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color backgroundColor = colorScheme.primary;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: backgroundColor, width: 2.0),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
          child: SizedBox.fromSize(
            size: const Size.square(120.0),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (imageUrl != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl!),
                    backgroundColor: backgroundColor,
                  ),
                if (isLoading) const LoadingSpinner() else Icon(Icons.add_a_photo, color: colorScheme.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
