import 'package:flutter/material.dart';

class GalleryView extends StatelessWidget {
  final String image;
  final String id;

  GalleryView(this.image, this.id);

  @override
  Widget build(BuildContext context) {
    print(id);
    return new Scaffold(
      body: Container(
        color: Colors.black,
        child: new SafeArea(
          child: Stack(
            children: [
              new Center(
                child: new Hero(
                  tag: image,
                  child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(image),
                  ),
                ),
              ),
              new Align(
                alignment: Alignment.topLeft,
                child: new Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: new IconButton(
                    color: Colors.white,
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
