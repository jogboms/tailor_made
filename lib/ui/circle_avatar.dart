import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

CircleAvatar circleAvatar({double radius, bool useAlt = false, String imageUrl}) {
  final iconColor = useAlt ? kPrimaryColor : Colors.white;
  final backgroundColor = useAlt ? Colors.white : kPrimaryColor;
  return new CircleAvatar(
    radius: radius,
    backgroundColor: imageUrl != null ? Colors.grey.shade400 : backgroundColor,
    backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
    child: imageUrl != null
        ? null
        : Center(
            child: Icon(
              Icons.person_outline,
              color: iconColor,
            ),
          ),
  );
}
