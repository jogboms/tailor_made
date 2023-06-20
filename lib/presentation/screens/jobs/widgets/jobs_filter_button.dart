import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/rebloc.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/widgets.dart';

class JobsFilterButton extends StatelessWidget {
  const JobsFilterButton({super.key, required this.vm, required this.onTapSort});

  final JobsViewModel vm;
  final ValueSetter<JobsSortType> onTapSort;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context)!;
    final TextStyle optionTheme = theme.body1;
    return SizedBox.fromSize(
      size: const Size.square(48.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PopupMenuButton<JobsSortType>(
              icon: Icon(Icons.filter_list, color: theme.appBarTitle.color),
              onSelected: onTapSort,
              itemBuilder: (BuildContext context) {
                return <_Option>[
                  _Option(
                    text: 'Sort by Active',
                    type: JobsSortType.active,
                    enabled: vm.sortFn != JobsSortType.active,
                    style: optionTheme.copyWith(color: _colorTestFn(JobsSortType.active)),
                  ),
                  _Option(
                    text: 'Sort by Name',
                    type: JobsSortType.names,
                    enabled: vm.sortFn != JobsSortType.names,
                    style: optionTheme.copyWith(color: _colorTestFn(JobsSortType.names)),
                  ),
                  _Option(
                    text: 'Sort by Owed',
                    type: JobsSortType.owed,
                    enabled: vm.sortFn != JobsSortType.owed,
                    style: optionTheme.copyWith(color: _colorTestFn(JobsSortType.owed)),
                  ),
                  _Option(
                    text: 'Sort by Payments',
                    type: JobsSortType.payments,
                    enabled: vm.sortFn != JobsSortType.payments,
                    style: optionTheme.copyWith(color: _colorTestFn(JobsSortType.payments)),
                  ),
                  _Option(
                    text: 'Sort by Price',
                    type: JobsSortType.price,
                    enabled: vm.sortFn != JobsSortType.price,
                    style: optionTheme.copyWith(color: _colorTestFn(JobsSortType.price)),
                  ),
                  _Option(
                    text: 'Sort by Recent',
                    type: JobsSortType.recent,
                    enabled: vm.sortFn != JobsSortType.recent,
                    style: optionTheme.copyWith(color: _colorTestFn(JobsSortType.recent)),
                  ),
                  _Option(
                    text: 'No Sort',
                    type: JobsSortType.reset,
                    enabled: vm.sortFn != JobsSortType.reset,
                    style: optionTheme.copyWith(color: _colorTestFn(JobsSortType.reset)),
                  ),
                ];
              },
            ),
          ),
          Align(
            alignment: const Alignment(0.75, -0.5),
            child: vm.hasSortFn ? const Dots(color: kAccentColor) : null,
          ),
        ],
      ),
    );
  }

  Color _colorTestFn(JobsSortType type) => vm.sortFn == type ? kAccentColor : Colors.black87;
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