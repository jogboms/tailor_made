import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../../utils.dart';

class ContactsFilterButton extends StatelessWidget {
  const ContactsFilterButton({super.key, required this.sortType, required this.onTapSort});

  final ContactsSortType sortType;
  final ValueSetter<ContactsSortType> onTapSort;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle optionTheme = theme.textTheme.bodyMedium!;
    final ColorScheme colorScheme = theme.colorScheme;
    return SizedBox.fromSize(
      size: const Size.square(48.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PopupMenuButton<ContactsSortType>(
              icon: const Icon(Icons.filter_list),
              onSelected: onTapSort,
              itemBuilder: (BuildContext context) {
                return <_Option>[
                  _Option(
                    enabled: sortType != ContactsSortType.jobs,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.jobs, colorScheme)),
                    text: 'Sort by Jobs',
                    type: ContactsSortType.jobs,
                  ),
                  _Option(
                    enabled: sortType != ContactsSortType.names,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.names, colorScheme)),
                    text: 'Sort by Name',
                    type: ContactsSortType.names,
                  ),
                  _Option(
                    enabled: sortType != ContactsSortType.completed,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.completed, colorScheme)),
                    text: 'Sort by Completed',
                    type: ContactsSortType.completed,
                  ),
                  _Option(
                    enabled: sortType != ContactsSortType.pending,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.pending, colorScheme)),
                    text: 'Sort by Pending',
                    type: ContactsSortType.pending,
                  ),
                  _Option(
                    enabled: sortType != ContactsSortType.recent,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.recent, colorScheme)),
                    text: 'Sort by Recent',
                    type: ContactsSortType.recent,
                  ),
                  _Option(
                    enabled: sortType != ContactsSortType.reset,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.reset, colorScheme)),
                    text: 'No Sort',
                    type: ContactsSortType.reset,
                  ),
                ];
              },
            ),
          ),
          Align(
            alignment: const Alignment(0.75, -0.5),
            child: sortType != ContactsSortType.reset ? Dots(color: colorScheme.secondary) : null,
          ),
        ],
      ),
    );
  }

  Color? _colorTestFn(ContactsSortType type, ColorScheme colorScheme) =>
      sortType == type ? colorScheme.secondary : null;
}

class _Option extends PopupMenuItem<ContactsSortType> {
  _Option({
    required super.enabled,
    required this.text,
    required this.type,
    required this.style,
  }) : super(value: type, child: Text(text, style: style));

  final String text;
  final ContactsSortType type;
  final TextStyle style;
}
