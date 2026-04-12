import 'dart:developer' as developer;

class AppLogger {
  static void info(String message) => developer.log(message, name: 'INFO');
  static void error(String message, [Object? error]) =>
      developer.log(message, name: 'ERROR', error: error);
}
