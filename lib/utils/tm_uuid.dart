import 'dart:math' show Random;

String uuid() {
  var rnd = new Random.secure();

  var bytes = new List<int>.generate(16, (_) => rnd.nextInt(256));
  bytes[6] = (bytes[6] & 0x0F) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  var chars = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join().toUpperCase();

  return '${chars.substring(0, 8)}-${chars.substring(8, 12)}-'
      '${chars.substring(12, 16)}-${chars.substring(16, 20)}-${chars.substring(20, 32)}';
}
