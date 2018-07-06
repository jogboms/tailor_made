import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/contact.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_phone.dart';
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

    Widget iconCircle(IconData icon, VoidCallback onTap) {
      return IconButton(
        icon: new Icon(icon, size: 20.0, color: theme.textColor),
        onPressed: onTap,
      );
    }

    Hero avatar() {
      return new Hero(
        tag: contact.documentID,
        child: new CircleAvatar(
          radius: 28.0,
          backgroundColor: theme.scaffoldColor.withOpacity(.5),
          backgroundImage: contact.imageUrl != null ? NetworkImage(contact.imageUrl) : null,
          child: contact.imageUrl != null
              ? new Align(
                  alignment: Alignment(1.25, -1.25),
                  child: contact.hasPending > 0
                      ? new Container(
                          width: 15.5,
                          height: 15.5,
                          decoration: new BoxDecoration(
                            color: accentColor,
                            border: Border.all(
                              color: theme.scaffoldColor,
                              style: BorderStyle.solid,
                              width: 2.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                )
              : Center(child: Icon(Icons.person_outline)),
        ),
      );
    }

    Row icons = new Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        iconCircle(Icons.call, () => call(int.parse(contact.phone))),
        iconCircle(Icons.message, () => sms(int.parse(contact.phone))),
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
      contentPadding: EdgeInsets.only(left: 16.0),
      onTap: onTapContact ?? () => TMNavigate(context, Contact(contact: contact)),
      leading: avatar(),
      title: title,
      subtitle: pending > 1 ? Text("$pending wear-ables") : Text("No pending wear-ables"),
      trailing: showActions ? icons : null,
    );

    return new Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(),
      margin: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: list,
      ),
    );
  }
}
