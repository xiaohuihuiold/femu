import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:logger/logger.dart';

/// 自定义简单日志
class MySimplePrinter extends SimplePrinter {
  static const grey = AnsiColor.fg(8);
  static final timeFormat = [HH, ':', nn, ':', ss];

  MySimplePrinter({super.printTime, super.colors});

  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    var timeStr = printTime
        ? (colors
            ? grey(formatDate(event.time, timeFormat))
            : formatDate(event.time, timeFormat))
        : '';
    return ['${_labelFor(event.level)} $timeStr $messageStr$errorStr'];
  }

  String _labelFor(Level level) {
    var prefix = SimplePrinter.levelPrefixes[level]!;
    var color = SimplePrinter.levelColors[level]!;
    return colors ? color(prefix) : prefix;
  }

  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = const JsonEncoder.withIndent(null);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}
