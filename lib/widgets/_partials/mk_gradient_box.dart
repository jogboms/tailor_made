import 'package:flutter/widgets.dart';
import 'package:tailor_made/constants/mk_colors.dart';

class MkGradientBox extends StatelessWidget {
  const MkGradientBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: const BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: const [
            MkColors.gradient_end,
            MkColors.gradient_start,
          ],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}
