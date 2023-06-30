import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../measures/widgets/measure_create_items.dart';
import 'jobs_create_view_model.dart';
import 'widgets/avatar_app_bar.dart';
import 'widgets/gallery_grid_item.dart';
import 'widgets/image_form_value.dart';
import 'widgets/input_dropdown.dart';

class JobsCreatePage extends StatefulWidget {
  const JobsCreatePage({
    super.key,
    this.contact,
    required this.contacts,
    required this.userId,
  });

  final ContactEntity? contact;
  final List<ContactEntity> contacts;
  final String userId;

  @override
  State<JobsCreatePage> createState() => _JobsCreatePageState();
}

class _JobsCreatePageState extends JobsCreateViewModel {
  final MoneyMaskedTextController _controller = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

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
              title: Text(contact.fullname, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.title),
              subtitle: Text('${contact.totalJobs} Jobs', style: theme.small),
              actions: widget.contacts.isNotEmpty
                  ? <Widget>[
                      IconButton(icon: const Icon(Icons.people), onPressed: handleSelectContact),
                    ]
                  : null,
            )
          : CustomAppBar.empty,
      body: Builder(
        builder: (BuildContext context) {
          if (contact == null) {
            return Center(
              child: AppClearButton(
                onPressed: handleSelectContact,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(.2),
                      radius: 50.0,
                      child: const Icon(Icons.person_add, color: kTextBaseColor),
                    ),
                    const SizedBox(height: 16.0),
                    Text('SELECT A CLIENT', style: theme.small),
                  ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const FormSectionHeader(title: 'Style Name'),
                    _buildEnterName(),
                    const FormSectionHeader(title: 'Payment', trailing: 'Naira (₦)'),
                    _buildEnterAmount(),
                    const FormSectionHeader(title: 'Due Date'),
                    _buildDueDate(),
                    const FormSectionHeader(title: 'References'),
                    Container(
                      height: _kGridWidth + 8,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          _NewGrid(onPressed: handlePhotoButtonPressed),
                          for (final ImageFormValue value in images.reversed)
                            GalleryGridItem.formValue(
                              value: value,
                              onTapDelete: handleDeleteImageItem,
                            )
                        ],
                      ),
                    ),
                    const FormSectionHeader(title: 'Measurements', trailing: 'Inches (In)'),
                    _buildMeasures(),
                    const FormSectionHeader(title: 'Additional Notes'),
                    _buildAdditional(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 82.0),
                      child: PrimaryButton(
                        onPressed: handleSubmit,
                        child: const Text('FINISH'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMeasures() {
    return ViewModelSubscriber<AppState, MeasuresViewModel>(
      converter: MeasuresViewModel.new,
      builder: (_, __, MeasuresViewModel vm) {
        return MeasureCreateItems(
          grouped: vm.grouped,
          measurements: job.measurements,
          onSaved: (Map<String, double>? value) {
            if (value != null) {
              job = job.copyWith(measurements: value);
            }
          },
        );
      },
    );
  }

  Widget _buildAdditional() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        style: Theme.of(context).title.copyWith(color: Colors.black),
        maxLines: 6,
        decoration: const InputDecoration(
          isDense: true,
          hintText: 'Fabric color, size, special requirements...',
        ),
        onSaved: (String? value) => job = job.copyWith(notes: value!.trim()),
        onFieldSubmitted: (String value) => handleSubmit(),
      ),
    );
  }

  Widget _buildDueDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InputDropdown(
        valueText: DateFormat.yMMMd().format(job.dueAt),
        valueStyle: Theme.of(context).title.copyWith(color: Colors.black),
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
    );
  }

  Widget _buildEnterName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        style: Theme.of(context).title.copyWith(color: Colors.black),
        decoration: const InputDecoration(isDense: true, hintText: 'Enter Style Name'),
        validator: (String? value) => (value!.isNotEmpty) ? null : 'Please input a name',
        onSaved: (String? value) => job = job.copyWith(name: value!.trim()),
      ),
    );
  }

  Widget _buildEnterAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        controller: _controller,
        textInputAction: TextInputAction.next,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: Theme.of(context).title.copyWith(color: Colors.black),
        decoration: const InputDecoration(isDense: true, hintText: 'Enter Amount'),
        validator: (String? value) => (_controller.numberValue > 0) ? null : 'Please input a price',
        onSaved: (String? value) => job = job.copyWith(price: _controller.numberValue),
      ),
    );
  }
}

class _NewGrid extends StatelessWidget {
  const _NewGrid({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kGridWidth,
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: InkWell(
          onTap: onPressed,
          child: Icon(Icons.add_a_photo, size: 24.0, color: kTextBaseColor.withOpacity(.35)),
        ),
      ),
    );
  }
}

const double _kGridWidth = 85.0;
