import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsCreatePage extends StatefulWidget {
  @override
  _ContactsCreatePageState createState() => new _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> {
  String imageUrl;
  bool isLoading = false;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    // FirebaseAuth.instance.signInAnonymously().then((r) {
    //   print(r);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      //   backgroundColor: Colors.grey.shade100,
      appBar: appBar(
        context,
        title: "Create Contacts",
      ),
      body: Center(
        child: CircleAvatar(
          radius: 200.0,
          // backgroundColor: Colors.transparent,
          // backgroundColor: Colors.red,
          backgroundImage: NetworkImage("https://placeimg.com/640/640/animals"),
          // backgroundImage: NetworkImage(imageUrl),
          // child: Image.network(imageUrl),
          // child: Image.network("https://placeimg.com/640/640/animals"),
        ),
      ),
      // SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: <Widget>[
      //       // _buildAvatar(),
      //       CircleAvatar(
      //         backgroundColor: Colors.transparent,
      //         // backgroundColor: Colors.red,
      //         backgroundImage: NetworkImage("https://placeimg.com/640/640/animals"),
      //         // backgroundImage: NetworkImage(imageUrl),
      //         // child: Image.network(imageUrl),
      //         // child: Image.network("https://placeimg.com/640/640/animals"),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Container _buildAvatar() {
    return Container(
      width: 120.0,
      height: 120.0,
      margin: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(.2),
      ),
      child: GestureDetector(
        onTap: _handlePhotoButtonPressed,
        child: !isSuccess
            ? Center(
                child: SizedBox.expand(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    // backgroundColor: Colors.red,
                    backgroundImage: NetworkImage("https://placeimg.com/640/640/animals"),
                    // backgroundImage: NetworkImage(imageUrl),
                    // child: Image.network(imageUrl),
                    // child: Image.network("https://placeimg.com/640/640/animals"),
                  ),
                ),
              )
            // TODO
            // FadeInImage.assetNetwork()
            : Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : CupertinoButton(
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.black.withOpacity(.35),
                        ),
                        onPressed: null,
                      ),
              ),
      ),
    );
  }

  Future<Null> _handlePhotoButtonPressed() async {
    var source = await showChildDialog(
      context: context,
      child: new SimpleDialog(
        children: <Widget>[
          new SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Padding(child: Text("Camera"), padding: EdgeInsets.all(8.0)),
          ),
          new SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Padding(child: Text("Gallery"), padding: EdgeInsets.all(8.0)),
          ),
        ],
      ),
    );
    if (source == null) return;
    var imageFile = await ImagePicker.pickImage(source: source, maxWidth: 200.0, maxHeight: 200.0);
    var random = new Random().nextInt(10000);
    var ref = FirebaseStorage.instance.ref().child('image_$random.jpg');
    var uploadTask = ref.putFile(imageFile);

    setState(() {
      isLoading = true;
      isSuccess = false;
    });
    try {
      imageUrl = (await uploadTask.future).downloadUrl?.toString();
      setState(() {
        isLoading = false;
        isSuccess = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isSuccess = false;
      });
    }
  }
}
