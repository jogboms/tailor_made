import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/redux/actions/jobs.dart';
import 'package:tailor_made/redux/view_models/jobs.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class JobsFilterButton extends StatelessWidget {
  const JobsFilterButton({
    Key key,
    @required this.vm,
  }) : super(key: key);

  final JobsViewModel vm;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);
    return SizedBox.fromSize(
      size: Size.square(48.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PopupMenuButton<SortType>(
              icon: Icon(
                Icons.filter_list,
                color: theme.appBarTitle.color,
              ),
              onSelected: onTapSort(vm),
              itemBuilder: (BuildContext context) => [
                    buildTextOption(
                      "Sort by Active",
                      SortType.active,
                    ),
                    buildTextOption(
                      "Sort by Name",
                      SortType.name,
                    ),
                    buildTextOption(
                      "Sort by Owed",
                      SortType.owed,
                    ),
                    buildTextOption(
                      "Sort by Payments",
                      SortType.payments,
                    ),
                    buildTextOption(
                      "Sort by Price",
                      SortType.price,
                    ),
                    buildTextOption(
                      "Sort by Recent",
                      SortType.recent,
                    ),
                    buildTextOption(
                      "No Sort",
                      SortType.reset,
                    ),
                  ],
            ),
          ),
          Align(
            alignment: Alignment(0.75, -0.5),
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

  Widget buildTextOption(String text, SortType type) {
    return PopupMenuItem<SortType>(
      value: type,
      enabled: vm.sortFn != type,
      child: Text(
        text,
        style: mkFontRegular(
          14.0,
          vm.sortFn == type ? kAccentColor : Colors.black87,
        ),
      ),
    );
  }

  Function(SortType) onTapSort(JobsViewModel vm) =>
      (SortType type) => vm.setSortFn(type);
}
