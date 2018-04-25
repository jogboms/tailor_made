import 'package:flutter/material.dart';

class ReferencesGridWidget extends StatelessWidget {
  @override
  build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      crossAxisSpacing: 2.0,
      mainAxisSpacing: 2.0,
      children: List.generate(40, (i) {
        onTapImage() {
          print("onTapImage");
        }

        return Container(
          padding: EdgeInsets.zero,
          color: Colors.grey[100],
          child: new InkResponse(
            onTap: onTapImage,
            radius: 300.0,
            child: Text(""),
          ),
        );
      }).toList(),
    );
  }
}
