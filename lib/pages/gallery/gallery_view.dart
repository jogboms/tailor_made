import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';

class GalleryView extends StatelessWidget {
  final String imageUrl;

  GalleryView({
    Key key,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: Colors.grey[900],
        child: new SafeArea(
          child: Stack(
            children: [
              new Hero(
                tag: imageUrl,
                child: new PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  loadingChild: loadingSpinner(),
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
