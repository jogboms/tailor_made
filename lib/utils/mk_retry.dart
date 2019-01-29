import "dart:async" show Future;

/// Calls [f] repeatedly until it doesn't throw an exception or [tryLimit] is
/// reached (in which case the future completes with the last thrown exception).
/// f is called every [interval] seeconds.

Future<T> mkRetry<T>(
  Future<T> f(), {
  int tryLimit: 6,
  Duration interval,
}) async {
  interval ??= Duration(seconds: 10);

  for (int t = 0; t < tryLimit; t++) {
    try {
      return await f();
    } catch (e) {
      if (t == tryLimit - 1) {
        rethrow;
      }

      await Future<void>.delayed(interval);
    }
  }

  // To prevent static warning
  throw Exception("Retry failed");
}
