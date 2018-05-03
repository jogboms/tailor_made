import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'gallery_view.dart';

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Gallery"),
                Text("21 Photos", style: TextStyle(fontSize: 11.0, color: textBaseColor)),
              ],
            ),
            floating: true,
          ),
          SliverGrid.count(
            crossAxisCount: 3,
            crossAxisSpacing: 1.5,
            mainAxisSpacing: 1.5,
            children: List.generate(40, (i) {
              Random rand = new Random();
              int id = rand.nextInt(10000);
              int id2 = rand.nextInt(10000);
              const image = "https://placeimg.com/640/640/tech";
              return new Hero(
                tag: "-$image-$id-$id2",
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: new NetworkImage(image),
                    ),
                  ),
                  child: new Material(
                    color: Colors.transparent,
                    child: new InkWell(
                      onTap: () {
                        PageRouteBuilder pageBuilder = new PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) => GalleryView(image, "-$image-$id-$id2"),
                          transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                            return new FadeTransition(opacity: animation, child: child);
                          },
                        );
                        Navigator.of(context).push(pageBuilder);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
