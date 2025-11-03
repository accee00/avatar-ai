import 'dart:developer' as developer;

import 'package:logging/logging.dart';

final Logger logger = Logger('AvatarAi');

void initLogger({required Level level}) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((LogRecord record) {
    developer.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
}

void logInfo(Object message) => logger.info(message);
void logWarning(Object message) => logger.warning(message);
void logError(Object message, [Object? error, StackTrace? stackTrace]) =>
    logger.severe(message, error, stackTrace);
