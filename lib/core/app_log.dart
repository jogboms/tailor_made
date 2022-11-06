import 'package:logging/logging.dart';

class AppLog {
  AppLog._();

  static final Logger _logger = Logger.root;

  static void init({
    required LogFilter logFilter,
    required ExceptionLogFilter exceptionFilter,
    required ExceptionLogBuilder onException,
    required LogBuilder onLog,
  }) {
    _logger.level = Level.ALL;
    _logger.onRecord.listen(_logListener(logFilter, exceptionFilter, onException, onLog));
  }

  static void e(Object error, StackTrace stackTrace, {Object? message}) => _logger.log(
        Level.SEVERE,
        message ?? error.toString(),
        error,
        error is Error && error.stackTrace != null ? error.stackTrace! : stackTrace,
      );

  static void i(Object message) => _logger.info(message);
}

typedef LogFilter = bool Function();
typedef LogBuilder = void Function(Object? message);
typedef ExceptionLogFilter = bool Function(Object error);
typedef ExceptionLogBuilder = void Function(Object error, StackTrace stackTrace, Object extra);

void Function(LogRecord) _logListener(
  LogFilter logFilter,
  ExceptionLogFilter exceptionFilter,
  ExceptionLogBuilder onException,
  LogBuilder onLog,
) =>
    (LogRecord record) {
      final LogBuilder logger = logFilter() ? onLog : (_) {};
      if (record.level != Level.SEVERE) {
        logger(record.message);
        return;
      }

      logger(record.error);
      logger(record.stackTrace);

      final Object error = record.error!;
      if (!exceptionFilter(error)) {
        return;
      }

      onException(
        error,
        record.stackTrace ?? StackTrace.current,
        record.object ?? <String, dynamic>{},
      );
    };
