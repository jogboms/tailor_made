import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';

class MkCircleAvatar extends StatelessWidget {
  const MkCircleAvatar({
    Key key,
    this.radius,
    this.useAlt = false,
    this.imageUrl,
  }) : super(key: key);

  final double radius;
  final bool useAlt;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final iconColor = useAlt ? kPrimaryColor : Colors.white;
    final backgroundColor = useAlt ? Colors.white : kPrimaryColor;
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          imageUrl != null ? Colors.grey.shade400 : backgroundColor,
      backgroundImage:
          imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
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
}
