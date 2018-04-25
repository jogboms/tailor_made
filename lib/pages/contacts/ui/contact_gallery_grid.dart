import 'package:flutter/material.dart';

class GalleryGridWidget extends StatelessWidget {
  @override
  build(BuildContext context) {
    // return new Padding(
    //   padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
    //   child: new LayoutBuilder(
    //     builder: (BuildContext context, BoxConstraints box) {
    //       int crossCount = 3;
    //       double crossSpacing = 2.0;
    //       double boxSize = (box.maxWidth - ((crossCount - 1) * crossSpacing)) / crossCount;
    //       return new Wrap(
    //         spacing: crossSpacing,
    //         runSpacing: crossSpacing,
    //         children: new List.generate(
    //           30,
    //           (int index) {
    //             onTapImage() {
    //               print("onTapImage");
    //             }

    //             return Container(
    //               padding: EdgeInsets.zero,
    //               color: Colors.grey[300],
    //               width: boxSize,
    //               height: boxSize,
    //               child: new InkResponse(
    //                 onTap: onTapImage,
    //                 radius: 300.0,
    //                 child: Text(""),
    //               ),
    //             );
    //           },
    //         ).toList(),
    //       );
    //     },
    //   ),
    // );
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
