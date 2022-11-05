import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/theme.dart';

class AppCircleAvatar extends StatelessWidget {
  const AppCircleAvatar({super.key, this.radius, this.useAlt = false, this.imageUrl});

  final double? radius;
  final bool useAlt;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = useAlt ? kPrimaryColor : Colors.white;
    final Color backgroundColor = useAlt ? Colors.white : kPrimaryColor;
    return CircleAvatar(
      radius: radius,
      backgroundColor: imageUrl != null ? Colors.grey.shade400 : backgroundColor,
      backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl!) : null,
      child: imageUrl != null ? null : Center(child: Icon(Icons.person_outline, color: iconColor)),
    );
  }
}
