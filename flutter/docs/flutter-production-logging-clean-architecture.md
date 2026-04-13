# Flutter Production Logging แบบ Clean Architecture

เอกสารนี้สรุปเวอร์ชันที่แนะนำสำหรับ **Flutter production logging แบบ Clean Architecture** โดยต่อยอดจากแนวคิด `Failure + Logger + Result` เพื่อให้ระบบรองรับทั้งการพัฒนาในเครื่อง, การ debug production, และการแสดงข้อความ error ที่เหมาะสมกับผู้ใช้

---

## เป้าหมายของระบบ

ระบบ logging ที่ดีควรทำได้ 5 อย่าง:

1. ผู้ใช้เห็นข้อความ error ที่สุภาพและเข้าใจง่าย
2. นักพัฒนาเห็นรายละเอียด debug ครบพอสำหรับแก้ปัญหา
3. dev และ prod ใช้ปลายทาง log คนละแบบ
4. error ถูก map เป็นชนิดที่ชัดเจน
5. UI และ use case ไม่ต้องรู้เรื่อง Crashlytics หรือ crash reporter โดยตรง

---

## แนวคิดหลัก

ระบบนี้มีแกนอยู่ 4 ส่วน:

- `Failure` สำหรับแทนความล้มเหลวแบบมีโครงสร้าง
- `FailureMapper` สำหรับแปลง exception ดิบให้เป็น `Failure`
- `AppLogger` สำหรับส่ง log ไปยัง sink ต่าง ๆ
- `Result<T>` สำหรับทำให้ success/failure explicit

แนวคิดสำคัญคือการแยก:

- **message** → สำหรับผู้ใช้
- **debugMessage** → สำหรับนักพัฒนา / crash report

ตัวอย่าง:

- `message`: `Please check your internet connection.`
- `debugMessage`: `GET /movies -> https://api.example.com/movies -> SocketException`

---

## โครงสร้างไฟล์ที่แนะนำ

```text
lib/
└── core/
    ├── error/
    │   ├── failure.dart
    │   ├── failures.dart
    │   ├── result.dart
    │   └── failure_mapper.dart
    ├── logging/
    │   ├── app_logger.dart
    │   ├── log_level.dart
    │   ├── log_context.dart
    │   ├── log_sink.dart
    │   ├── console_log_sink.dart
    │   └── crash_report_log_sink.dart
    └── bootstrap/
        └── app_error_bootstrap.dart
```

---

## 1) Failure model

### `failure.dart`

```dart
abstract class Failure implements Exception {
  final String message; // สำหรับ user
  final String? debugMessage; // สำหรับ dev / crash report
  final int? statusCode;
  final Object? cause;
  final StackTrace? stackTrace;

  const Failure(
    this.message, {
    this.debugMessage,
    this.statusCode,
    this.cause,
    this.stackTrace,
  });
}
```

### `failures.dart`

```dart
import 'failure.dart';

class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Please check your internet connection.',
    String? debugMessage,
    int? statusCode,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message,
          debugMessage: debugMessage,
          statusCode: statusCode,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Server error. Please try again later.',
    String? debugMessage,
    int? statusCode,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message,
          debugMessage: debugMessage,
          statusCode: statusCode,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Your session has expired.',
    String? debugMessage,
    int? statusCode,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message,
          debugMessage: debugMessage,
          statusCode: statusCode,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'Requested content was not found.',
    String? debugMessage,
    int? statusCode,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message,
          debugMessage: debugMessage,
          statusCode: statusCode,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    String message = 'Some information is invalid.',
    String? debugMessage,
    int? statusCode,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message,
          debugMessage: debugMessage,
          statusCode: statusCode,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    String message = 'Unexpected error occurred.',
    String? debugMessage,
    int? statusCode,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message,
          debugMessage: debugMessage,
          statusCode: statusCode,
          cause: cause,
          stackTrace: stackTrace,
        );
}
```

---

## 2) Result type

`Result<T>` ช่วยให้ call site บังคับ handle ทั้ง success และ failure แบบ explicit

### `result.dart`

```dart
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(Object failure) failure,
  });
}

final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Object failure) failure,
  }) {
    return success(data);
  }
}

final class Err<T> extends Result<T> {
  final Object error;

  const Err(this.error);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Object failure) failure,
  }) {
    return failure(error);
  }
}
```

> ถ้าต้องการ strict กว่านี้ เปลี่ยน `Object` เป็น `Failure` ได้เลย

---

## 3) Failure mapper

อย่าเขียน mapping `DioException -> Failure` ซ้ำหลายที่ ให้มีจุดรวมเดียว

### `failure_mapper.dart`

```dart
import 'dart:io';
import 'package:dio/dio.dart';

import 'failures.dart';
import 'failure.dart';

class FailureMapper {
  const FailureMapper();

  Failure map(
    Object error, {
    StackTrace? stackTrace,
    String? endpoint,
  }) {
    if (error is Failure) return error;

    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final uri = error.requestOptions.uri.toString();
      final debug = endpoint != null
          ? '$endpoint -> $uri -> ${error.message}'
          : '$uri -> ${error.message}';

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return NetworkFailure(
            debugMessage: debug,
            statusCode: statusCode,
            cause: error,
            stackTrace: stackTrace,
          );

        case DioExceptionType.badResponse:
          if (statusCode == 401 || statusCode == 403) {
            return UnauthorizedFailure(
              debugMessage: debug,
              statusCode: statusCode,
              cause: error,
              stackTrace: stackTrace,
            );
          }

          if (statusCode == 404) {
            return NotFoundFailure(
              debugMessage: debug,
              statusCode: statusCode,
              cause: error,
              stackTrace: stackTrace,
            );
          }

          if (statusCode != null && statusCode >= 500) {
            return ServerFailure(
              debugMessage: debug,
              statusCode: statusCode,
              cause: error,
              stackTrace: stackTrace,
            );
          }

          return UnexpectedFailure(
            debugMessage: debug,
            statusCode: statusCode,
            cause: error,
            stackTrace: stackTrace,
          );

        case DioExceptionType.cancel:
          return UnexpectedFailure(
            message: 'Request was cancelled.',
            debugMessage: debug,
            statusCode: statusCode,
            cause: error,
            stackTrace: stackTrace,
          );

        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
          return UnexpectedFailure(
            debugMessage: debug,
            statusCode: statusCode,
            cause: error,
            stackTrace: stackTrace,
          );
      }
    }

    if (error is SocketException) {
      return NetworkFailure(
        debugMessage: error.toString(),
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (error is FormatException) {
      return UnexpectedFailure(
        message: 'Data format is invalid.',
        debugMessage: error.toString(),
        cause: error,
        stackTrace: stackTrace,
      );
    }

    return UnexpectedFailure(
      debugMessage: error.toString(),
      cause: error,
      stackTrace: stackTrace,
    );
  }
}
```

---

## 4) Logging abstraction

### `log_level.dart`

```dart
enum LogLevel {
  info,
  warning,
  error,
}
```

### `log_context.dart`

```dart
class LogContext {
  final String? feature;
  final String? action;
  final String? route;
  final String? requestId;
  final Map<String, Object?> extra;

  const LogContext({
    this.feature,
    this.action,
    this.route,
    this.requestId,
    this.extra = const {},
  });

  Map<String, Object?> toMap() {
    return {
      'feature': feature,
      'action': action,
      'route': route,
      'requestId': requestId,
      ...extra,
    }..removeWhere((key, value) => value == null);
  }
}
```

### `log_sink.dart`

```dart
import '../error/failure.dart';
import 'log_context.dart';

abstract class LogSink {
  Future<void> info(String message, {LogContext? context});
  Future<void> warning(String message, {LogContext? context});
  Future<void> error(
    Failure failure, {
    LogContext? context,
  });
}
```

---

## 5) Console sink

### `console_log_sink.dart`

```dart
import 'package:flutter/foundation.dart';

import '../error/failure.dart';
import 'log_context.dart';
import 'log_sink.dart';

class ConsoleLogSink implements LogSink {
  const ConsoleLogSink();

  @override
  Future<void> info(String message, {LogContext? context}) async {
    if (!kDebugMode) return;
    debugPrint('[INFO] $message');
    if (context != null) debugPrint('Context: ${context.toMap()}');
  }

  @override
  Future<void> warning(String message, {LogContext? context}) async {
    if (!kDebugMode) return;
    debugPrint('[WARN] $message');
    if (context != null) debugPrint('Context: ${context.toMap()}');
  }

  @override
  Future<void> error(Failure failure, {LogContext? context}) async {
    if (!kDebugMode) return;

    debugPrint('');
    debugPrint('━━━ FAILURE ━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('Type    : ${failure.runtimeType}');
    debugPrint('Message : ${failure.message}');
    if (failure.statusCode != null) {
      debugPrint('Status  : ${failure.statusCode}');
    }
    if (failure.debugMessage != null) {
      debugPrint('Debug   : ${failure.debugMessage}');
    }
    if (context != null) {
      debugPrint('Context : ${context.toMap()}');
    }
    if (failure.stackTrace != null) {
      debugPrint('Stack   :');
      debugPrint('${failure.stackTrace}');
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
```

---

## 6) Crash report sink

ถ้ายังไม่อยากผูกกับ Firebase Crashlytics ตรง ๆ ให้ห่อผ่าน abstraction ก่อน

### `crash_report_log_sink.dart`

```dart
import '../error/failure.dart';
import 'log_context.dart';
import 'log_sink.dart';

abstract class CrashReporter {
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?> information = const {},
  });
}

class CrashReportLogSink implements LogSink {
  final CrashReporter reporter;

  const CrashReportLogSink(this.reporter);

  @override
  Future<void> info(String message, {LogContext? context}) async {
    // ปกติไม่ส่ง info ไป crash reporter
  }

  @override
  Future<void> warning(String message, {LogContext? context}) async {
    // จะส่งหรือไม่ส่งก็ได้ ตาม policy
  }

  @override
  Future<void> error(Failure failure, {LogContext? context}) async {
    await reporter.recordError(
      failure,
      failure.stackTrace ?? StackTrace.current,
      reason: failure.debugMessage ?? failure.message,
      information: {
        'type': failure.runtimeType.toString(),
        'statusCode': failure.statusCode,
        ...?context?.toMap(),
      },
    );
  }
}
```

---

## 7) Logger กลาง

### `app_logger.dart`

```dart
import '../error/failure.dart';
import 'log_context.dart';
import 'log_sink.dart';

class AppLogger {
  final List<LogSink> sinks;

  const AppLogger(this.sinks);

  Future<void> info(String message, {LogContext? context}) async {
    for (final sink in sinks) {
      await sink.info(message, context: context);
    }
  }

  Future<void> warning(String message, {LogContext? context}) async {
    for (final sink in sinks) {
      await sink.warning(message, context: context);
    }
  }

  Future<void> failure(Failure failure, {LogContext? context}) async {
    for (final sink in sinks) {
      await sink.error(failure, context: context);
    }
  }
}
```

ข้อดีของวิธีนี้คือ test ง่ายกว่า static logger และขยาย sink ได้โดยไม่กระทบ call site

---

## 8) ใช้ใน repository

```dart
class MovieRepositoryImpl implements MovieRepository {
  final Dio dio;
  final AppLogger logger;
  final FailureMapper failureMapper;

  MovieRepositoryImpl({
    required this.dio,
    required this.logger,
    required this.failureMapper,
  });

  @override
  Future<Result<List<Movie>>> getMovies() async {
    try {
      final response = await dio.get('/movies');
      final movies = (response.data as List)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();

      await logger.info(
        'Fetched movies successfully',
        context: const LogContext(
          feature: 'movies',
          action: 'getMovies',
        ),
      );

      return Success(movies);
    } catch (error, stackTrace) {
      final failure = failureMapper.map(
        error,
        stackTrace: stackTrace,
        endpoint: 'GET /movies',
      );

      await logger.failure(
        failure,
        context: const LogContext(
          feature: 'movies',
          action: 'getMovies',
        ),
      );

      return Err(failure);
    }
  }
}
```

---

## 9) ใช้ใน Riverpod

```dart
final movieListProvider = FutureProvider<List<Movie>>((ref) async {
  final repo = ref.watch(movieRepositoryProvider);
  final result = await repo.getMovies();

  return result.when(
    success: (movies) => movies,
    failure: (failure) {
      if (failure is Failure) {
        throw Exception(failure.message);
      }
      throw Exception('Unexpected error');
    },
  );
});
```

สำหรับโปรเจกต์จริง แนะนำให้ทำ state model แทนการ `throw` กลับจาก provider

ตัวอย่าง:

```dart
class MovieListState {
  final bool isLoading;
  final List<Movie> movies;
  final String? errorMessage;

  const MovieListState({
    this.isLoading = false,
    this.movies = const [],
    this.errorMessage,
  });

  MovieListState copyWith({
    bool? isLoading,
    List<Movie>? movies,
    String? errorMessage,
  }) {
    return MovieListState(
      isLoading: isLoading ?? this.isLoading,
      movies: movies ?? this.movies,
      errorMessage: errorMessage,
    );
  }
}
```

---

## 10) ใช้ใน GetX

```dart
class MovieController extends GetxController {
  final MovieRepository repository;

  MovieController(this.repository);

  final isLoading = false.obs;
  final movies = <Movie>[].obs;
  final errorMessage = RxnString();

  Future<void> fetchMovies() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await repository.getMovies();

    result.when(
      success: (data) {
        movies.assignAll(data);
      },
      failure: (failure) {
        if (failure is Failure) {
          errorMessage.value = failure.message;
        } else {
          errorMessage.value = 'Unexpected error';
        }
      },
    );

    isLoading.value = false;
  }
}
```

---

## 11) Global error bootstrap

ระบบนี้จะสมบูรณ์ขึ้นมากเมื่อดัก uncaught error ด้วย

### `app_error_bootstrap.dart`

```dart
import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../error/failures.dart';
import '../logging/app_logger.dart';
import '../logging/log_context.dart';

class AppErrorBootstrap {
  final AppLogger logger;

  AppErrorBootstrap(this.logger);

  void setup() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);

      logger.failure(
        UnexpectedFailure(
          message: 'Unexpected UI error occurred.',
          debugMessage: details.exceptionAsString(),
          cause: details.exception,
          stackTrace: details.stack,
        ),
        context: const LogContext(
          feature: 'flutter',
          action: 'FlutterError.onError',
        ),
      );
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      logger.failure(
        UnexpectedFailure(
          debugMessage: error.toString(),
          cause: error,
          stackTrace: stackTrace,
        ),
        context: const LogContext(
          feature: 'platform',
          action: 'PlatformDispatcher.onError',
        ),
      );
      return true;
    };
  }

  Future<void> run(Future<void> Function() appRunner) async {
    runZonedGuarded(
      () async {
        setup();
        await appRunner();
      },
      (error, stackTrace) async {
        await logger.failure(
          UnexpectedFailure(
            debugMessage: error.toString(),
            cause: error,
            stackTrace: stackTrace,
          ),
          context: const LogContext(
            feature: 'app',
            action: 'runZonedGuarded',
          ),
        );
      },
    );
  }
}
```

### `main.dart`

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = AppLogger([
    const ConsoleLogSink(),
    // CrashReportLogSink(crashReporter),
  ]);

  final bootstrap = AppErrorBootstrap(logger);

  await bootstrap.run(() async {
    runApp(const MyApp());
  });
}
```

---

## 12) Logging policy ที่แนะนำ

### `info`
ใช้กับเหตุการณ์ปกติที่มีประโยชน์ต่อการ trace flow เช่น

- navigation
- cache hit
- token refresh success
- feature milestone

### `warning`
ใช้กับสิ่งที่ผิดปกติแต่ผู้ใช้ยังไปต่อได้ เช่น

- cache parse fail
- image load fail
- retry happened
- optional dependency unavailable

### `failure`
ใช้กับปัญหาที่กระทบประสบการณ์ผู้ใช้จริง เช่น

- API ใช้งานไม่ได้
- parsing พังจนแสดงข้อมูลไม่ได้
- auth หมดอายุ
- uncaught exception
- payment / order / save action fail

---

## 13) สิ่งที่ห้ามทำ

### อย่าใช้ `print()` เป็น logging strategy หลัก
เพราะไม่ตอบโจทย์ production logging และควบคุมโครงสร้าง log ได้ไม่ดี

### อย่า log ข้อมูลลับ
ห้ามส่งข้อมูลพวกนี้ลง log ตรง ๆ

- access token
- refresh token
- password
- phone number
- email เต็ม
- address
- raw response body ที่มีข้อมูลส่วนตัว

ควร mask ก่อน เช่น

- `de***@gmail.com`
- token แสดงเฉพาะ 6 ตัวแรก

### อย่า map exception ซ้ำหลายที่
ให้มี `FailureMapper` จุดเดียว

### อย่า spam crash reporter
ไม่ใช่ทุก warning ต้องส่งเข้า Crashlytics

---

## 14) แนวทาง integration กับ Crashlytics

เมื่อพร้อมใช้ Crashlytics ให้สร้าง implementation ของ `CrashReporter` เช่น

```dart
class FirebaseCrashReporter implements CrashReporter {
  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?> information = const {},
  }) async {
    // ตัวอย่างแนวทาง
    // await FirebaseCrashlytics.instance.recordError(
    //   error,
    //   stackTrace,
    //   reason: reason,
    //   information: information.entries
    //       .map((e) => DiagnosticsNode.message('${e.key}: ${e.value}'))
    //       .toList(),
    // );
  }
}
```

แล้ว inject เข้า `CrashReportLogSink`

```dart
final logger = AppLogger([
  const ConsoleLogSink(),
  CrashReportLogSink(FirebaseCrashReporter()),
]);
```

---

## 15) ทำไมโครงนี้ถึงเหมาะกับ Clean Architecture

เพราะมันแยก responsibility ชัด:

- **Data source**: โยน exception ดิบ
- **Repository**: map exception เป็น `Failure`
- **Use case / service**: คืน `Result<T>`
- **Presentation**: ใช้ `failure.message`
- **Logger**: เป็น cross-cutting concern กลาง

ผลคือ UI ไม่ต้องรู้จัก Dio, StackTrace, หรือ Crashlytics เลย

---

## 16) เวอร์ชันที่แนะนำจริงสำหรับโปรเจกต์ production

สำหรับโปรเจกต์ Flutter production ผมแนะนำสูตรนี้:

- ใช้ `Failure`
- ใช้ `FailureMapper`
- ใช้ `Result<T>`
- ใช้ injected `AppLogger`
- ใช้ `ConsoleLogSink` + `CrashReportLogSink`
- มี global bootstrap สำหรับ uncaught error
- ห้ามใช้ `print()` ใน production code

นี่เป็นจุดสมดุลที่ดีระหว่าง:
- เรียบง่ายพอสำหรับใช้งานจริง
- ขยายต่อได้
- test ได้
- ไม่ผูกกับ vendor เดียวเกินไป

---

## 17) Checklist สำหรับเริ่มใช้

- [ ] สร้าง `Failure` และ subtype หลัก
- [ ] สร้าง `FailureMapper`
- [ ] สร้าง `Result<T>`
- [ ] สร้าง `LogSink`
- [ ] สร้าง `ConsoleLogSink`
- [ ] สร้าง `CrashReportLogSink`
- [ ] สร้าง `AppLogger`
- [ ] ต่อ global error bootstrap
- [ ] เปลี่ยน `print()` เดิมเป็น `logger.info/warning/failure`
- [ ] ตรวจ policy เรื่อง PII ก่อนส่ง production log

---

## 18) สรุปสุดท้าย

ถ้าต้องการระบบ Flutter logging ที่ใช้ได้จริงใน production อย่าหยุดแค่ `print()` หรือ `debugPrint()` กระจายทั่วโปรเจกต์

ให้ใช้โครงแบบนี้แทน:

- `Failure` สำหรับ model ของความล้มเหลว
- `FailureMapper` สำหรับแปลง exception
- `Result<T>` สำหรับ flow ที่ explicit
- `AppLogger` สำหรับรวมการ logging
- `LogSink` สำหรับแยกปลายทาง
- `AppErrorBootstrap` สำหรับเก็บ uncaught error

โครงนี้เหมาะมากกับ Flutter + Clean Architecture ไม่ว่าจะใช้ Riverpod หรือ GetX ก็ตาม
