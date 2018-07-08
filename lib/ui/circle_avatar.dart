import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CircleAvatar circleAvatar({double radius, String imageUrl}) {
  return new CircleAvatar(
    radius: radius ?? null,
    backgroundColor: imageUrl != null ? Colors.grey.shade400 : Colors.white,
    backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
    child: imageUrl != null ? null : Center(child: Icon(Icons.person_outline)),
  );
}
