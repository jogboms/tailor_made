import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({
    super.key,
    required this.contact,
    required this.onHandleSubmit,
  });

  final ValueSetter<CreateContactData> onHandleSubmit;
  final CreateContactData contact;

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
    final L10n l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 32.0),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, _) => _Avatar(
              imageUrl: _contact.imageUrl,
              isLoading: _isLoading,
              onTap: () => _handlePhotoButtonPressed(l10n, ref.read(imageStorageProvider)),
            ),
          ),
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
                    decoration: InputDecoration(prefixIcon: const Icon(Icons.person), labelText: l10n.fullnameLabel),
                    validator: InputValidator.tryAlpha(),
                    onSaved: (String? fullname) => _contact = _contact.copyWith(fullname: fullname!.trim()),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    controller: _pNController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(prefixIcon: const Icon(Icons.phone), labelText: l10n.phoneLabel),
                    validator: InputValidator.tryString(l10n.inputValueMessage),
                    onSaved: (String? phone) => _contact = _contact.copyWith(phone: phone!.trim()),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    controller: _lNController,
                    textInputAction: TextInputAction.done,
                    decoration:
                        InputDecoration(prefixIcon: const Icon(Icons.location_city), labelText: l10n.locationLabel),
                    validator: InputValidator.tryString(l10n.inputValueMessage),
                    onSaved: (String? location) => _contact = _contact.copyWith(location: location!.trim()),
                    onFieldSubmitted: (String value) => _handleSubmit(l10n),
                  ),
                  const SizedBox(height: 32.0),
                  PrimaryButton(onPressed: () => _handleSubmit(l10n), child: Text(l10n.submitCaption)),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(L10n l10n) async {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true;
      AppSnackBar.of(context).error(l10n.fixFormErrors);
    } else {
      form.save();
      widget.onHandleSubmit(_contact);
    }
  }

  Future<void> _handlePhotoButtonPressed(L10n l10n, ImageStorageProvider storage) async {
    final AppSnackBar snackBar = AppSnackBar.of(context);
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source, maxWidth: 200.0, maxHeight: 200.0);
    if (imageFile == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO(Jogboms): move this out of here
      final ImageFileReference ref = await storage.create(CreateImageType.contact, path: imageFile.path);
      _contact = _contact.copyWith(imageUrl: ref.src);
      if (mounted) {
        snackBar.success(l10n.uploadSuccessfulMessage);
        if (_previousImageFileRef case final ImageFileReference reference) {
          storage.delete(reference).ignore();
        }
        _previousImageFileRef = ref;
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        snackBar.error(l10n.genericErrorMessage);
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
