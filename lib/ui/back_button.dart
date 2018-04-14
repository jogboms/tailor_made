import 'package:flutter/material.dart';

IconButton backButton(BuildContext context) {
  return new IconButton(
    icon: new Icon(
      Icons.arrow_back,
      color: Colors.grey.shade800,
    ),
    onPressed: () {
      Navigator.maybePop(context);
    },
  );
}
