import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class Contact extends StatefulWidget {
  final ContactModel contact;

  Contact({this.contact});

  @override
  _ContactState createState() => new _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    void onTapGoBack() {
      Navigator.pop(context);
    }

    Widget appBar = new PreferredSize(
      preferredSize: new Size.fromHeight(kToolbarHeight),
      child: Material(
        elevation: 4.0,
        color: theme.appBarBackgroundColor,
        child: SafeArea(
          top: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                child: new Row(
                  children: <Widget>[
                    new Icon(
                      Icons.arrow_back,
                      color: theme.appBarColor,
                    ),
                    const SizedBox(width: 4.0),
                    new Hero(
                      tag: widget.contact,
                      child: new CircleAvatar(
                        backgroundColor: Colors.grey.shade400,
                        // backgroundImage: NetworkImage("https://placeimg.com/640/640/people"),
                        // backgroundImage: NetworkImage(widget.contact.image),
                        backgroundImage: NetworkImage("https://placeimg.com/640/640/people"),
                      ),
                    ),
                  ],
                ),
                onPressed: onTapGoBack,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      widget.contact.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: theme.appBarColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    widget.contact.pending > 1
                        ? new Text.rich(
                            new TextSpan(
                              children: [
                                new TextSpan(
                                  text: widget.contact.pending.toString(),
                                  style: new TextStyle(fontWeight: FontWeight.w600),
                                ),
                                new TextSpan(
                                  text: " pending wear-ables",
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 13.0,
                              color: theme.appBarColor,
                            ),
                          )
                        : new Container(),
                  ],
                ),
              ),
              new IconButton(
                icon: new Icon(
                  Icons.more_vert,
                  color: theme.appBarColor,
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: appBar,
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }
}
