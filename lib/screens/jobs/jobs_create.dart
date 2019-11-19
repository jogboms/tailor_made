import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/measures/view_model.dart';
import 'package:tailor_made/screens/jobs/_partials/avatar_app_bar.dart';
import 'package:tailor_made/screens/jobs/_partials/gallery_grid_item.dart';
import 'package:tailor_made/screens/jobs/_partials/input_dropdown.dart';
import 'package:tailor_made/screens/jobs/jobs_create_view_model.dart';
import 'package:tailor_made/screens/measures/_partials/measure_create_items.dart';
import 'package:tailor_made/widgets/_partials/form_section_header.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_partials/mk_primary_button.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class JobsCreatePage extends StatefulWidget {
  const JobsCreatePage({
    Key key,
    this.contact,
    @required this.contacts,
    @required this.userId,
  }) : super(key: key);

  final ContactModel contact;
  final List<ContactModel> contacts;
  final String userId;

  @override
  _JobsCreatePageState createState() => _JobsCreatePageState();
}

class _JobsCreatePageState extends JobsCreateViewModel {
  MoneyMaskedTextController controller = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _additionFocusNode = FocusNode();

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _additionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: contact != null
          ? AvatarAppBar(
              tag: contact.createdAt.toString(),
              imageUrl: contact.imageUrl,
              elevation: 1.0,
              backgroundColor: Colors.white,
              title: Text(contact.fullname, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.title),
              subtitle: Text("${contact.totalJobs} Jobs", style: theme.small),
              actions: widget.contacts.isNotEmpty
                  ? <Widget>[
                      IconButton(icon: const Icon(Icons.people), onPressed: onSelectContact),
                    ]
                  : null,
            )
          : const MkAppBar(title: Text("")),
      body: Builder(builder: (BuildContext context) {
        if (contact == null) {
          return Center(
            child: MkClearButton(
              onPressed: onSelectContact,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(.2),
                    radius: 50.0,
                    child: const Icon(Icons.person_add, color: kTextBaseColor),
                  ),
                  const SizedBox(height: 16.0),
                  Text("SELECT A CLIENT", style: theme.small),
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
              autovalidate: autovalidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormSectionHeader(title: "Style Name"),
                  _buildEnterName(),
                  const FormSectionHeader(title: "Payment", trailing: "Naira (₦)"),
                  _buildEnterAmount(),
                  const FormSectionHeader(title: "Due Date"),
                  _buildDueDate(),
                  const FormSectionHeader(title: "References"),
                  _buildImageGrid(),
                  const FormSectionHeader(title: "Measurements", trailing: "Inches (In)"),
                  _buildMeasures(),
                  const FormSectionHeader(title: "Additional Notes"),
                  _buildAdditional(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 82.0),
                    child: MkPrimaryButton(
                      child: const Text("FINISH"),
                      onPressed: handleSubmit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMeasures() {
    return ViewModelSubscriber<AppState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (_, __, MeasuresViewModel vm) {
        return MeasureCreateItems(
          grouped: vm.grouped,
          measurements: job.measurements.build().toMap(),
        );
      },
    );
  }

  Widget _buildAdditional() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        focusNode: _additionFocusNode,
        keyboardType: TextInputType.text,
        style: ThemeProvider.of(context).title.copyWith(color: Colors.black),
        maxLines: 6,
        decoration: const InputDecoration(
          isDense: true,
          hintText: "Fabric color, size, special requirements...",
        ),
        onSaved: (value) => job.notes = value.trim(),
        onFieldSubmitted: (value) => handleSubmit(),
      ),
    );
  }

  Widget _buildImageGrid() {
    final List<Widget> imagesList = List<Widget>.generate(
      fireImages.length,
      (int index) {
        final fireImage = fireImages[index];
        final image = fireImage.image;

        if (image == null) {
          return const Center(widthFactor: 2.5, child: MkLoadingSpinner());
        }

        return GalleryGridItem(
          image: image,
          tag: "$image-$index",
          size: _kGridWidth,
          onTapDelete: (image) => setState(() {
            fireImage.ref.delete();
            fireImages.removeAt(index);
          }),
        );
      },
    ).reversed.toList();

    return Container(
      height: _kGridWidth + 8,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        scrollDirection: Axis.horizontal,
        children: [
          _NewGrid(onPressed: handlePhotoButtonPressed),
          ...imagesList,
        ],
      ),
    );
  }

  Widget _buildDueDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InputDropdown(
        valueText: DateFormat.yMMMd().format(job.dueAt),
        valueStyle: ThemeProvider.of(context).title.copyWith(color: Colors.black),
        onPressed: () async {
          final DateTime picked = await showDatePicker(
            context: context,
            initialDate: job.dueAt,
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
          );
          if (picked != null && picked != job.dueAt) {
            setState(() {
              job = job..dueAt = picked;
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
        style: ThemeProvider.of(context).title.copyWith(color: Colors.black),
        decoration: const InputDecoration(isDense: true, hintText: "Enter Style Name"),
        validator: (value) => (value.isNotEmpty) ? null : "Please input a name",
        onSaved: (value) => job.name = value.trim(),
        onEditingComplete: () => FocusScope.of(context).requestFocus(_amountFocusNode),
      ),
    );
  }

  Widget _buildEnterAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        focusNode: _amountFocusNode,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: ThemeProvider.of(context).title.copyWith(color: Colors.black),
        decoration: const InputDecoration(isDense: true, hintText: "Enter Amount"),
        validator: (value) => (controller.numberValue > 0) ? null : "Please input a price",
        onSaved: (value) => job.price = controller.numberValue,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_additionFocusNode),
      ),
    );
  }
}

class _NewGrid extends StatelessWidget {
  const _NewGrid({Key key, @required this.onPressed}) : super(key: key);

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

const _kGridWidth = 85.0;
