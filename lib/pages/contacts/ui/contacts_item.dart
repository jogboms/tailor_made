import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ContactsItem extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTapContact;
  final bool showActions;

  ContactsItem({
    Key key,
    this.contact,
    this.onTapContact,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    void onTapCard() {
      if (onTapContact != null) {
        onTapContact();
        return;
      }
      TMNavigate(context, Contact(contact: contact));
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
        tag: contact.imageUrl,
        child: new CircleAvatar(
          backgroundColor: theme.scaffoldColor.withOpacity(.5),
          backgroundImage: NetworkImage(contact.imageUrl),
          child: new Align(
            alignment: Alignment(1.25, -1.25),
            child: contact.hasPending > 0
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        iconCircle(Icons.call, onTapCall),
        iconCircle(Icons.message, onTapChat),
        iconCircle(Icons.more_vert, onTapMore),
      ],
    );

    Text title = new Text(
      contact.fullname,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: new TextStyle(color: theme.textColor),
    );

    int pending = contact.hasPending;

    ListTile list = ListTile(
      dense: true,
      onTap: onTapCard,
      leading: avatar(),
      title: title,
      subtitle: pending > 1 ? Text("$pending wear-ables") : Text("No pending wear-ables"),
      trailing: showActions ? icons : null,
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
