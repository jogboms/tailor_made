import 'dart:async' show Future;

import 'package:url_launcher/url_launcher.dart';

Future<void> _launch(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void open(String link) => _launch(link);

void call(String phone) => _launch('tel:$phone');

void sms(String phone) => _launch('sms:$phone');

void email(String email, String subject) =>
    _launch('mailto:$email?subject=$subject');
