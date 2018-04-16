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
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 8.0),
        child: InkResponse(
          child: new Icon(icon, size: 18.0, color: theme.textColor),
          onTap: onTap,
          radius: 20.0,
          splashColor: accentColor.withOpacity(.25),
        ),
      );
    }

    return Material(
      elevation: 1.5,
      color: theme.scaffoldColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: onTapCard,
              highlightColor: Colors.transparent,
              splashColor: accentColor.withOpacity(.25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  new Hero(
                    tag: widget.contact,
                    child: new CircleAvatar(
                      backgroundColor: theme.scaffoldColor.withOpacity(.5),
                      backgroundImage: NetworkImage(widget.contact.image),
                      radius: 48.5,
                      child: new Align(
                        alignment: Alignment.topRight,
                        child: widget.contact.pending > 0
                            ? new Container(
                                width: 22.5,
                                height: 22.5,
                                decoration: new BoxDecoration(
                                  color: accentColor,
                                  border: Border.all(color: theme.scaffoldColor, style: BorderStyle.solid, width: 3.5),
                                  shape: BoxShape.circle,
                                ),
                              )
                            : new Container(),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
                    child: new Text(
                      widget.contact.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(color: theme.textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Container(
            decoration: new BoxDecoration(
              color: Colors.grey.withOpacity(.35),
              border: new Border(
                top: new BorderSide(color: Colors.grey.withOpacity(.5), style: BorderStyle.solid, width: 1.0),
              ),
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                iconCircle(Icons.call, onTapCall),
                iconCircle(Icons.message, onTapChat),
                iconCircle(Icons.more_vert, onTapMore),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
