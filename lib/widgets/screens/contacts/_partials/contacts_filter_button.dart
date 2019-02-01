import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/rebloc/actions/contacts.dart';
import 'package:tailor_made/rebloc/view_models/contacts.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_dots.dart';

class ContactsFilterButton extends StatelessWidget {
  const ContactsFilterButton({
    Key key,
    @required this.vm,
    @required this.onTapSort,
  }) : super(key: key);

  final ContactsViewModel vm;
  final ValueSetter<SortType> onTapSort;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);
    final _optionTheme = theme.body3;
    final _colorTestFn = (SortType type) {
      return vm.sortFn == type ? kAccentColor : Colors.black87;
    };
    return SizedBox.fromSize(
      size: const Size.square(48.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PopupMenuButton<SortType>(
              icon: Icon(
                Icons.filter_list,
                color: theme.appBarTitle.color,
              ),
              onSelected: onTapSort,
              itemBuilder: (BuildContext context) {
                return [
                  _Option(
                    enabled: vm.sortFn != SortType.jobs,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.jobs),
                    ),
                    text: "Sort by Jobs",
                    type: SortType.jobs,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.name,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.name),
                    ),
                    text: "Sort by Name",
                    type: SortType.name,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.completed,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.completed),
                    ),
                    text: "Sort by Completed",
                    type: SortType.completed,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.pending,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.pending),
                    ),
                    text: "Sort by Pending",
                    type: SortType.pending,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.recent,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.recent),
                    ),
                    text: "Sort by Recent",
                    type: SortType.recent,
                  ),
                  _Option(
                    enabled: vm.sortFn != SortType.reset,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.reset),
                    ),
                    text: "No Sort",
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
}

class _Option extends PopupMenuItem<SortType> {
  _Option({
    Key key,
    @required bool enabled,
    @required this.text,
    @required this.type,
    @required this.style,
  }) : super(
          key: key,
          enabled: enabled,
          value: type,
          child: Text(text, style: style),
        );

  final String text;
  final SortType type;
  final TextStyle style;
}
