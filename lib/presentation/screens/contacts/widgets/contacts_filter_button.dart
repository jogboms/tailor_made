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
    final L10n l10n = context.l10n;

    return SizedBox.fromSize(
      size: const Size.square(48.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PopupMenuButton<ContactsSortType>(
              icon: const Icon(Icons.filter_list),
              onSelected: onTapSort,
              itemBuilder: (BuildContext context) => <_Option>[
                for (final ContactsSortType item in ContactsSortType.values)
                  _Option(
                    enabled: sortType != item,
                    style: optionTheme.copyWith(color: _colorTestFn(item, colorScheme)),
                    text: item.caption(l10n),
                    type: item,
                  ),
              ],
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

extension on ContactsSortType {
  String caption(L10n l10n) => switch (this) {
        ContactsSortType.recent => l10n.sortByJobsCaption,
        ContactsSortType.jobs => l10n.sortByNameCaption,
        ContactsSortType.completed => l10n.sortByCompletedCaption,
        ContactsSortType.pending => l10n.sortByPendingCaption,
        ContactsSortType.names => l10n.sortByRecentCaption,
        ContactsSortType.reset => l10n.noSortCaption,
      };
}
