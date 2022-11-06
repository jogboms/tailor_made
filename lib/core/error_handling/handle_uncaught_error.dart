import 'dart:async' show Zone;

void Function(Object error, StackTrace stackTrace) get handleUncaughtError => Zone.current.handleUncaughtError;
