import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/gallery_grid.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/ui/back_button.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class GalleryPage extends StatefulWidget {
  final List<ImageModel> images;

  GalleryPage({
    Key key,
    this.images,
  }) : super(key: key);

  @override
  GalleryPageState createState() {
    return new GalleryPageState();
  }
}

class GalleryPageState extends State<GalleryPage> {
  List<ImageModel> images;

  @override
  void initState() {
    images = widget.images;
    super.initState();
  }

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
                Text("Gallery", style: theme.appBarStyle),
                images != null
                    ? Text(
                        "${images.length} Photos",
                        style: TextStyle(
                          fontSize: 11.0,
                          color: kTextBaseColor,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            backgroundColor: theme.appBarBackgroundColor,
            automaticallyImplyLeading: false,
            leading: backButton(context),
            brightness: Brightness.light,
            forceElevated: true,
            elevation: 1.0,
            centerTitle: false,
            floating: true,
          ),
          getBody()
        ],
      ),
    );
  }

  getContent() {
    return images.isEmpty
        ? SliverFillRemaining(
            child: TMEmptyResult(message: "No images available"),
          )
        : SliverPadding(
            padding: EdgeInsets.only(top: 3.0),
            sliver: GalleryGrid(images: images),
          );
  }

  getBody() {
    if (images == null) {
      return new StreamBuilder(
        stream: CloudDb.gallery.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return SliverFillRemaining(
              child: loadingSpinner(),
            );
          }
          images = snapshot.data.documents
              .map(
                (item) => ImageModel.fromJson(item.data),
              )
              .toList();
          return getContent();
        },
      );
    }
    return getContent();
  }
}
