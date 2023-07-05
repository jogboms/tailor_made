import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../../utils.dart';

class JobsFilterButton extends StatelessWidget {
  const JobsFilterButton({super.key, required this.sortType, required this.onTapSort});

  final JobsSortType sortType;
  final ValueSetter<JobsSortType> onTapSort;

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
            child: PopupMenuButton<JobsSortType>(
              icon: const Icon(Icons.filter_list),
              onSelected: onTapSort,
              itemBuilder: (BuildContext context) => <_Option>[
                for (final JobsSortType option in JobsSortType.values)
                  _Option(
                    text: option.caption(l10n),
                    type: option,
                    enabled: sortType != option,
                    style: optionTheme.copyWith(color: _colorTestFn(option, colorScheme)),
                  ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0.75, -0.5),
            child: sortType != JobsSortType.reset ? Dots(color: colorScheme.secondary) : null,
          ),
        ],
      ),
    );
  }

  Color? _colorTestFn(JobsSortType type, ColorScheme colorScheme) => sortType == type ? colorScheme.secondary : null;
}

class _Option extends PopupMenuItem<JobsSortType> {
  _Option({
    required super.enabled,
    required this.text,
    required this.type,
    required this.style,
  }) : super(
          value: type,
          child: Text(text, style: style),
        );

  final String text;
  final JobsSortType type;
  final TextStyle style;
}

extension on JobsSortType {
  String caption(L10n l10n) {
    return switch (this) {
      JobsSortType.recent => l10n.sortByActiveCaption,
      JobsSortType.active => l10n.sortByNameCaption,
      JobsSortType.names => l10n.sortByOwedCaption,
      JobsSortType.owed => l10n.sortByPaymentsCaption,
      JobsSortType.payments => l10n.sortByPriceCaption,
      JobsSortType.price => l10n.sortByRecentCaption,
      JobsSortType.reset => l10n.noSortCaption,
    };
  }
}
