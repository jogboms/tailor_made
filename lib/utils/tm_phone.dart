import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

Future<void> _launch(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void call(int phone) => _launch('tel:$phone');

void sms(int phone) => _launch('sms:$phone');

void email(String subject) =>
    _launch('mailto:jeremiahogbomo@gmail.com?subject=$subject');
