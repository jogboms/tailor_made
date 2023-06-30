import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/rebloc.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/widgets.dart';

class ContactsFilterButton extends StatelessWidget {
  const ContactsFilterButton({super.key, required this.vm, required this.onTapSort});

  final ContactsViewModel vm;
  final ValueSetter<ContactsSortType> onTapSort;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle optionTheme = theme.body1;
    return SizedBox.fromSize(
      size: const Size.square(48.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PopupMenuButton<ContactsSortType>(
              icon: Icon(Icons.filter_list, color: theme.appBarTitle.color),
              onSelected: onTapSort,
              itemBuilder: (BuildContext context) {
                return <_Option>[
                  _Option(
                    enabled: vm.sortFn != ContactsSortType.jobs,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.jobs)),
                    text: 'Sort by Jobs',
                    type: ContactsSortType.jobs,
                  ),
                  _Option(
                    enabled: vm.sortFn != ContactsSortType.names,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.names)),
                    text: 'Sort by Name',
                    type: ContactsSortType.names,
                  ),
                  _Option(
                    enabled: vm.sortFn != ContactsSortType.completed,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.completed)),
                    text: 'Sort by Completed',
                    type: ContactsSortType.completed,
                  ),
                  _Option(
                    enabled: vm.sortFn != ContactsSortType.pending,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.pending)),
                    text: 'Sort by Pending',
                    type: ContactsSortType.pending,
                  ),
                  _Option(
                    enabled: vm.sortFn != ContactsSortType.recent,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.recent)),
                    text: 'Sort by Recent',
                    type: ContactsSortType.recent,
                  ),
                  _Option(
                    enabled: vm.sortFn != ContactsSortType.reset,
                    style: optionTheme.copyWith(color: _colorTestFn(ContactsSortType.reset)),
                    text: 'No Sort',
                    type: ContactsSortType.reset,
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

  Color _colorTestFn(ContactsSortType type) => vm.sortFn == type ? kAccentColor : Colors.black87;
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
