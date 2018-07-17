import 'package:url_launcher/url_launcher.dart';

_launch(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

call(int phone) => _launch('tel:$phone');

sms(int phone) => _launch('sms:$phone');

email(String subject) => _launch('mailto:jeremiahogbomo@gmail.com?subject=$subject');
