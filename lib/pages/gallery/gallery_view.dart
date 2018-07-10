import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/contacts.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';

class GalleryView extends StatelessWidget {
  final ImageModel image;

  GalleryView({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<ReduxState, ContactsViewModel>(
      converter: (store) => ContactsViewModel(store)..contactID = image.contactID,
      builder: (BuildContext context, ContactsViewModel vm) {
        final contact = vm.selected;
        return new Scaffold(
          backgroundColor: Colors.black87,
          appBar: MyAppBar(contact: contact),
          body: new Hero(
            tag: image.src,
            child: new PhotoView(
              imageProvider: NetworkImage(image.src),
              loadingChild: loadingSpinner(),
            ),
          ),
        );
      },
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ContactModel contact;

  MyAppBar({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: Colors.black26,
        child: new SafeArea(
          bottom: false,
          child: Row(
            children: <Widget>[
              new IconButton(
                color: Colors.white,
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(Icons.arrow_back),
              ),
              Expanded(child: SizedBox()),
              IconButton(
                icon: Icon(
                  Icons.work,
                  color: Colors.white,
                ),
                // TODO
                onPressed: null,
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                // onPressed: () => TMNavigate(context, Contact(contact: contact)),
                onPressed: null,
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                // TODO
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
