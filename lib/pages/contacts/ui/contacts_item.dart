import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsItem extends StatefulWidget {
  final ContactModel contact;

  ContactsItem({this.contact});

  @override
  _ContactsItemState createState() => new _ContactsItemState();
}

class _ContactsItemState extends State<ContactsItem> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    void onTapCard() {
      TMNavigate(context, Contact(contact: widget.contact));
    }

    void onTapCall() {
      print("onTapCall");
    }

    void onTapChat() {
      print("onTapChat");
    }

    void onTapMore() {
      print("onTapMore");
    }

    Widget iconCircle(IconData icon, VoidCallback onTap) {
      return Padding(
        // padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        child: InkResponse(
          child: new Icon(icon, size: 18.0, color: theme.textColor),
          onTap: onTap,
          radius: 20.0,
          splashColor: accentColor.withOpacity(.25),
        ),
      );
    }

    Hero avatar() {
      return new Hero(
        tag: widget.contact.image,
        child: new CircleAvatar(
          backgroundColor: theme.scaffoldColor.withOpacity(.5),
          backgroundImage: NetworkImage(widget.contact.image),
          child: new Align(
            alignment: Alignment(1.25, -1.25),
            child: widget.contact.pending > 0
                ? new Container(
                    width: 15.5,
                    height: 15.5,
                    decoration: new BoxDecoration(
                      color: accentColor,
                      border: Border.all(color: theme.scaffoldColor, style: BorderStyle.solid, width: 2.5),
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
        ),
      );
    }

    Row icons = new Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        iconCircle(Icons.call, onTapCall),
        iconCircle(Icons.message, onTapChat),
        iconCircle(Icons.more_vert, onTapMore),
      ],
    );

    Text title = new Text(
      widget.contact.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: new TextStyle(color: theme.textColor),
    );

    int pending = widget.contact.pending;

    ListTile list = ListTile(
      dense: true,
      onTap: onTapCard,
      leading: avatar(),
      title: title,
      subtitle: pending > 1 ? Text("$pending wear-ables") : Text("No pending wear-ables"),
      trailing: icons,
    );

    return new Card(
      elevation: 0.5,
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: list,
      ),
    );
  }
}
