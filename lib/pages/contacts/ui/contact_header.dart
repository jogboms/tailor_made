import 'package:carousel/carousel.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/contacts/ui/contact_appbar.dart';

class ContactHeaderWidget extends StatelessWidget {
  final ContactModel contact;

  ContactHeaderWidget({this.contact});

  @override
  build(BuildContext context) {
    return new Stack(
      children: [
        ContactHeaderCarouselWidget(),
        ContactAppBar(contact: contact),
      ],
    );
  }
}

class ContactHeaderCarouselWidget extends StatelessWidget {
  // ContactHeaderCarouselWidget({this.contact});

  @override
  build(BuildContext context) {
    Widget carouselContainer = new SizedBox(
      child: new Carousel(
        displayDuration: const Duration(seconds: 2),
        children: [
          new NetworkImage("https://placeimg.com/640/640/animals"),
          new NetworkImage("https://placeimg.com/640/640/nature"),
          new NetworkImage("https://placeimg.com/640/640/arch"),
          new NetworkImage("https://placeimg.com/640/640/people"),
          new NetworkImage("https://placeimg.com/640/640/animals"),
          new NetworkImage("https://placeimg.com/640/640/tech"),
          new NetworkImage("https://placeimg.com/640/640/arch"),
        ].map((netImage) => new Image(fit: BoxFit.cover, width: 1500.0, height: 1500.0, image: netImage)).toList(),
      ),
    );

    Widget overlayContainer = Container(
      color: Colors.black.withOpacity(.4),
      height: double.infinity,
      width: double.infinity,
    );

    return Stack(
      children: [
        Container(color: Colors.grey[400]),
        carouselContainer,
        overlayContainer,
      ],
    );
  }
}
