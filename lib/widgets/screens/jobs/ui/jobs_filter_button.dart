import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/rebloc/actions/jobs.dart';
import 'package:tailor_made/rebloc/view_models/jobs.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class JobsFilterButton extends StatelessWidget {
  const JobsFilterButton({
    Key key,
    @required this.vm,
    @required this.onTapSort,
  }) : super(key: key);

  final JobsViewModel vm;
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
                    text: "Sort by Active",
                    type: SortType.active,
                    enabled: vm.sortFn != SortType.active,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.active),
                    ),
                  ),
                  _Option(
                    text: "Sort by Name",
                    type: SortType.name,
                    enabled: vm.sortFn != SortType.name,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.name),
                    ),
                  ),
                  _Option(
                    text: "Sort by Owed",
                    type: SortType.owed,
                    enabled: vm.sortFn != SortType.owed,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.owed),
                    ),
                  ),
                  _Option(
                    text: "Sort by Payments",
                    type: SortType.payments,
                    enabled: vm.sortFn != SortType.payments,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.payments),
                    ),
                  ),
                  _Option(
                    text: "Sort by Price",
                    type: SortType.price,
                    enabled: vm.sortFn != SortType.price,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.price),
                    ),
                  ),
                  _Option(
                    text: "Sort by Recent",
                    type: SortType.recent,
                    enabled: vm.sortFn != SortType.recent,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.recent),
                    ),
                  ),
                  _Option(
                    text: "No Sort",
                    type: SortType.reset,
                    enabled: vm.sortFn != SortType.reset,
                    style: _optionTheme.copyWith(
                      color: _colorTestFn(SortType.reset),
                    ),
                  ),
                ];
              },
            ),
          ),
          Align(
            alignment: const Alignment(0.75, -0.5),
            child: vm.hasSortFn
                ? Container(
                    width: 15.5,
                    height: 15.5,
                    decoration: BoxDecoration(
                      color: kAccentColor,
                      border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
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
