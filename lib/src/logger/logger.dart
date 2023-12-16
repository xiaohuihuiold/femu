import 'package:femu/src/logger/printer.dart';
import 'package:logger/logger.dart';

final logger = LoggerWrapper();

/// 自定义日志
class LoggerWrapper {
  final logger = Logger(
    printer: HybridPrinter(
      MySimplePrinter(
        printTime: true,
        colors: true,
      ),
    ),
    // output: FileOutput(file: File('./test.log')),
  );

  void nope() {}

  void v(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    log(Level.trace, message, error: error, stackTrace: stackTrace);
  }

  void d(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    log(Level.debug, message, error: error, stackTrace: stackTrace);
  }

  void i(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    log(Level.info, message, error: error, stackTrace: stackTrace);
  }

  void w(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    log(Level.warning, message, error: error, stackTrace: stackTrace);
  }

  void e(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    log(Level.error, message, error: error, stackTrace: stackTrace);
  }

  void fatal(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    log(Level.fatal, message, error: error, stackTrace: stackTrace);
  }

  void log(
    Level level,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    logger.log(level, message, error: error, stackTrace: stackTrace);
  }
}
