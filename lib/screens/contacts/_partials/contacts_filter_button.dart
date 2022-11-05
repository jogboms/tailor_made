import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/rebloc/contacts/sort_type.dart';
import 'package:tailor_made/rebloc/contacts/view_model.dart';
import 'package:tailor_made/widgets/_partials/mk_dots.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class ContactsFilterButton extends StatelessWidget {
  const ContactsFilterButton({super.key, required this.vm, required this.onTapSort});

  final ContactsViewModel vm;
  final ValueSetter<SortType> onTapSort;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context)!;
    final TextStyle optionTheme = theme.body1;
    return SizedBox.fromSize(
      size: const Size.square(48.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PopupMenuButton<SortType>(
              icon: Icon(Icons.filter_list, color: theme.appBarTitle.color),
              onSelected: onTapSort,
              itemBuilder: (BuildContext context) {
                return <_Option>[
                  _Option(
                    enabled: vm.sortFn != SortType.jobs,
                    style: optionTheme.copyWith(color: _colorTestFn(SortType.jobs)),
                    text: 'Sort by Jobs',
                    type: SortType.jobs,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.names,
                    style: optionTheme.copyWith(color: _colorTestFn(SortType.names)),
                    text: 'Sort by Name',
                    type: SortType.names,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.completed,
                    style: optionTheme.copyWith(color: _colorTestFn(SortType.completed)),
                    text: 'Sort by Completed',
                    type: SortType.completed,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.pending,
                    style: optionTheme.copyWith(color: _colorTestFn(SortType.pending)),
                    text: 'Sort by Pending',
                    type: SortType.pending,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.recent,
                    style: optionTheme.copyWith(color: _colorTestFn(SortType.recent)),
                    text: 'Sort by Recent',
                    type: SortType.recent,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.reset,
                    style: optionTheme.copyWith(color: _colorTestFn(SortType.reset)),
                    text: 'No Sort',
                    type: SortType.reset,
                  ),
                ];
              },
            ),
          ),
          Align(
            alignment: const Alignment(0.75, -0.5),
            child: vm.hasSortFn ? const MkDots(color: kAccentColor) : null,
          ),
        ],
      ),
    );
  }

  Color _colorTestFn(SortType type) => vm.sortFn == type ? kAccentColor : Colors.black87;
}

class _Option extends PopupMenuItem<SortType> {
  _Option({
    required super.enabled,
    required this.text,
    required this.type,
    required this.style,
  }) : super(value: type, child: Text(text, style: style));

  final String text;
  final SortType type;
  final TextStyle style;
}
