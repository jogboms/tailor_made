import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCircleAvatar extends StatelessWidget {
  const AppCircleAvatar({super.key, this.radius, this.useAlt = false, this.imageUrl});

  final double? radius;
  final bool useAlt;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color iconColor = useAlt ? colorScheme.primary : colorScheme.onPrimary;
    final Color backgroundColor = useAlt ? colorScheme.onPrimary : colorScheme.primary;

    return CircleAvatar(
      radius: radius,
      backgroundColor: imageUrl != null ? colorScheme.outlineVariant : backgroundColor,
      backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl!) : null,
      child: imageUrl != null ? null : Center(child: Icon(Icons.person_outline, color: iconColor)),
    );
  }
}
