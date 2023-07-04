import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/routing.dart';
import 'package:tailor_made/presentation/screens/contacts/providers/selected_contact_provider.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/widgets.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../state.dart';
import '../../utils.dart';
import '../measures/widgets/measure_create_items.dart';
import 'providers/job_provider.dart' hide job;
import 'widgets/avatar_app_bar.dart';
import 'widgets/gallery_grid_item.dart';
import 'widgets/image_form_value.dart';
import 'widgets/input_dropdown.dart';

class JobsCreatePage extends StatelessWidget {
  const JobsCreatePage({
    super.key,
    required this.contactId,
  });

  static const Key dataViewKey = Key('dataViewKey');

  final String? contactId;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final String? userId = ref.watch(accountProvider).valueOrNull?.uid;
        if (userId == null) {
          return const Scaffold(
            body: Center(
              child: LoadingSpinner(),
            ),
          );
        }

        final ContactEntity? contact;
        if (contactId case final String contactId) {
          contact = ref.watch(selectedContactProvider(contactId)).valueOrNull?.contact;
        } else {
          contact = null;
        }

        return _DataView(
          key: dataViewKey,
          contact: contact,
          userId: userId,
          storage: ref.read(imageStorageProvider),
        );
      },
    );
  }
}

class _DataView extends StatefulWidget {
  const _DataView({
    super.key,
    this.contact,
    required this.userId,
    required this.storage,
  });

  final ContactEntity? contact;
  final String userId;
  final ImageStorageProvider storage;

  @override
  State<_DataView> createState() => _DataViewState();
}

class _DataViewState extends State<_DataView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MoneyMaskedTextController _controller = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  final List<ImageFormValue> _images = <ImageFormValue>[];

  late ContactEntity? _contact = widget.contact;
  late CreateJobData _job = CreateJobData(
    id: const Uuid().v4(),
    userID: widget.userId,
    contactID: _contact?.id,
    measurements: _contact?.measurements ?? <String, double>{},
    price: 0.0,
    createdAt: clock.now(),
    dueAt: clock.now().add(const Duration(days: 7)),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final ContactEntity? contact = _contact;

    return Scaffold(
      appBar: contact != null
          ? AvatarAppBar(
              tag: contact.createdAt.toString(),
              imageUrl: contact.imageUrl,
              elevation: 1.0,
              useSafeArea: true,
              title: Text(
                contact.fullname,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.pageTitle,
              ),
              subtitle: Text('${contact.totalJobs} Jobs', style: theme.textTheme.bodySmall),
              actions: <Widget>[
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, _) => ref.watch(contactsProvider).maybeWhen(
                        data: (List<ContactEntity> data) => IconButton(
                          icon: const Icon(Icons.people),
                          onPressed: () => _handleSelectContact(data),
                        ),
                        orElse: () => const SizedBox.shrink(),
                      ),
                ),
              ],
            )
          : CustomAppBar.empty,
      body: Builder(
        builder: (BuildContext context) {
          if (contact == null) {
            return Center(
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, _) => ref.watch(contactsProvider).maybeWhen(
                      data: (List<ContactEntity> data) => AppClearButton(
                        onPressed: () => _handleSelectContact(data),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const CircleAvatar(radius: 50.0, child: Icon(Icons.person_add)),
                            const SizedBox(height: 16.0),
                            Text('SELECT A CLIENT', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      orElse: () => const LoadingSpinner(),
                    ),
              ),
            );
          }

          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const FormSectionHeader(title: 'Style Name'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(isDense: true, hintText: 'Enter Style Name'),
                          validator: (String? value) => (value!.isNotEmpty) ? null : 'Please input a name',
                          onSaved: (String? value) => _job = _job.copyWith(name: value!.trim()),
                        ),
                      ),
                      const FormSectionHeader(title: 'Payment', trailing: 'Naira (₦)'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: TextFormField(
                          controller: _controller,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(isDense: true, hintText: 'Enter Amount'),
                          validator: (String? value) => (_controller.numberValue > 0) ? null : 'Please input a price',
                          onSaved: (String? value) => _job = _job.copyWith(price: _controller.numberValue),
                        ),
                      ),
                      const FormSectionHeader(title: 'Due Date'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: InputDropdown(
                          valueText: DateFormat.yMMMd().format(_job.dueAt),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _job.dueAt,
                              firstDate: clock.now(),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != _job.dueAt) {
                              setState(() {
                                _job = _job.copyWith(dueAt: picked);
                              });
                            }
                          },
                        ),
                      ),
                      const FormSectionHeader(title: 'References'),
                      Container(
                        height: _NewGrid._kGridWidth + 8,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            _NewGrid(onPressed: () => _handlePhotoButtonPressed(widget.storage)),
                            for (final ImageFormValue value in _images.reversed)
                              GalleryGridItem.formValue(
                                value: value,
                                onTapDelete: (ImageFormValue value) => _handleDeleteImageItem(widget.storage, value),
                              )
                          ],
                        ),
                      ),
                      const FormSectionHeader(title: 'Measurements', trailing: 'Inches (In)'),
                      ref.watch(measurementsProvider).when(
                            skipLoadingOnReload: true,
                            data: (MeasurementsState state) => MeasureCreateItems(
                              grouped: state.grouped,
                              measurements: _job.measurements,
                              onSaved: (Map<String, double>? value) {
                                if (value != null) {
                                  _job = _job.copyWith(measurements: value);
                                }
                              },
                            ),
                            error: ErrorView.new,
                            loading: () => child!,
                          ),
                      const FormSectionHeader(title: 'Additional Notes'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Fabric color, size, special requirements...',
                          ),
                          onSaved: (String? value) => _job = _job.copyWith(notes: value!.trim()),
                          onFieldSubmitted: (String value) => _handleSubmit(ref.read(jobProvider)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 82.0),
                        child: PrimaryButton(
                          onPressed: () => _handleSubmit(ref.read(jobProvider)),
                          child: const Text('FINISH'),
                        ),
                      ),
                    ],
                  ),
                  child: const Center(child: LoadingSpinner()),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handlePhotoButtonPressed(ImageStorageProvider storage) async {
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile == null) {
      return;
    }

    try {
      final ImageFileReference ref = await storage.create(
        CreateImageType.reference,
        path: imageFile.path,
      );

      setState(() {
        _images.add(
          ImageCreateFormValue(
            CreateImageData(
              userID: widget.userId,
              contactID: _contact!.id,
              jobID: _job.id,
              src: ref.src,
              path: ref.path,
            ),
          ),
        );
      });
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
    }
  }

  void _handleSelectContact(List<ContactEntity> contacts) async {
    final ContactEntity? selectedContact = await context.router.toContactsList(contacts);
    if (selectedContact != null) {
      setState(() {
        _contact = selectedContact;
        _job = _job.copyWith(
          contactID: _contact?.id,
          measurements: _contact?.measurements ?? <String, double>{},
        );
      });
    }
  }

  void _handleDeleteImageItem(ImageStorageProvider storage, ImageFormValue value) async {
    final ImageFileReference reference = switch (value) {
      ImageCreateFormValue(:final CreateImageData data) => (src: data.src, path: data.path),
      ImageModifyFormValue(:final ImageEntity data) => (src: data.src, path: data.path),
    };
    await storage.delete(reference);
    if (mounted) {
      setState(() {
        _images.remove(value);
      });
    }
  }

  void _handleSubmit(JobProvider jobProvider) async {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }

    final AppSnackBar snackBar = AppSnackBar.of(context);
    if (!form.validate()) {
      snackBar.info(AppStrings.fixErrors);
      return;
    }

    form.save();
    snackBar.loading();

    final AppRouter router = context.router;
    try {
      _job = _job.copyWith(
        contactID: _contact!.id,
        pendingPayment: _job.price,
        images: _images
            .map(
              (ImageFormValue input) => switch (input) {
                ImageCreateFormValue() => CreateImageOperation(data: input.data),
                ImageModifyFormValue() => ModifyImageOperation(data: input.data),
              },
            )
            .toList(growable: false),
      );
      final JobEntity result = await jobProvider.create(job: _job);
      snackBar.success('Successfully Added');
      router.toJob(result, replace: true);
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      snackBar.error(error.toString());
    }
  }
}

class _NewGrid extends StatelessWidget {
  const _NewGrid({required this.onPressed});

  static const double _kGridWidth = 85.0;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: _kGridWidth,
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: colorScheme.outlineVariant,
        child: InkWell(
          onTap: onPressed,
          child: const Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}
