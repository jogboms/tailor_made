import 'package:flutter/widgets.dart';

class MkDarkGradientBox extends StatelessWidget {
  const MkDarkGradientBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: const BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            const Color(0x10363B28),
            const Color(0x19363B28),
            const Color(0x39363B28),
            const Color(0x66363B28),
            const Color(0x88363B28),
            const Color(0x99363B28),
            const Color(0xAA363B28),
            const Color(0xBB363B28),
            const Color(0xCC363B28),
            const Color(0xDD363B28),
            const Color(0xEE363B28),
            const Color(0xFF363B28),
          ],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}
