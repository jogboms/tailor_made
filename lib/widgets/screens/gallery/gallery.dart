import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/gallery/_partials/gallery_grid.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({
    Key key,
    this.images,
  }) : super(key: key);

  final List<ImageModel> images;

  @override
  GalleryPageState createState() {
    return GalleryPageState();
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
    final MkTheme theme = MkTheme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Gallery", style: theme.appBarTitle),
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
            backgroundColor: kAppBarBackgroundColor,
            automaticallyImplyLeading: false,
            leading: MkBackButton(),
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

  Widget getContent() {
    return images.isEmpty
        ? SliverFillRemaining(
            child: const EmptyResultView(message: "No images available"),
          )
        : SliverPadding(
            padding: EdgeInsets.only(top: 3.0),
            sliver: GalleryGrid(images: images),
          );
  }

  Widget getBody() {
    if (images == null) {
      return StreamBuilder(
        stream: CloudDb.gallery.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return SliverFillRemaining(
              child: const MkLoadingSpinner(),
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
