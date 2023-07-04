import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/screens/contacts/providers/selected_contact_provider.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../state.dart';
import '../measures/widgets/measure_create_items.dart';
import 'jobs_create_view_model.dart';
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

class _DataViewState extends State<_DataView> with JobsCreateViewModel {
  final MoneyMaskedTextController _controller = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

  @override
  ContactEntity? get defaultContact => widget.contact;

  @override
  String get userId => widget.userId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final ContactEntity? contact = this.contact;

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
                          onPressed: () => handleSelectContact(data),
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
                        onPressed: () => handleSelectContact(data),
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
                key: formKey,
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
                          onSaved: (String? value) => job = job.copyWith(name: value!.trim()),
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
                          onSaved: (String? value) => job = job.copyWith(price: _controller.numberValue),
                        ),
                      ),
                      const FormSectionHeader(title: 'Due Date'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: InputDropdown(
                          valueText: DateFormat.yMMMd().format(job.dueAt),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: job.dueAt,
                              firstDate: clock.now(),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != job.dueAt) {
                              setState(() {
                                job = job.copyWith(dueAt: picked);
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
                            _NewGrid(onPressed: () => handlePhotoButtonPressed(widget.storage)),
                            for (final ImageFormValue value in images.reversed)
                              GalleryGridItem.formValue(
                                value: value,
                                onTapDelete: (ImageFormValue value) => handleDeleteImageItem(widget.storage, value),
                              )
                          ],
                        ),
                      ),
                      const FormSectionHeader(title: 'Measurements', trailing: 'Inches (In)'),
                      ref.watch(measurementsProvider).when(
                            skipLoadingOnReload: true,
                            data: (MeasurementsState state) => MeasureCreateItems(
                              grouped: state.grouped,
                              measurements: job.measurements,
                              onSaved: (Map<String, double>? value) {
                                if (value != null) {
                                  job = job.copyWith(measurements: value);
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
                          onSaved: (String? value) => job = job.copyWith(notes: value!.trim()),
                          onFieldSubmitted: (String value) => handleSubmit(ref.read(jobProvider)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 82.0),
                        child: PrimaryButton(
                          onPressed: () => handleSubmit(ref.read(jobProvider)),
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
