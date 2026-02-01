import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

/// Wraps a stream factory with retry logic for transient errors.
///
/// Useful for handling intermittent Firestore permission-denied errors
/// that can occur during auth token refresh.
Stream<T> retryStream<T>(
  Stream<T> Function() streamFactory, {
  int maxRetries = 3,
  Duration initialDelay = const Duration(milliseconds: 500),
  bool Function(Object error)? shouldRetry,
}) {
  final controller = StreamController<T>.broadcast();
  int retryCount = 0;
  StreamSubscription<T>? subscription;

  // Default: retry on permission-denied errors
  final retryCheck = shouldRetry ?? (error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('permission-denied') ||
           errorString.contains('permission_denied');
  };

  // Debug: Log auth state when retry is created
  final currentUser = FirebaseAuth.instance.currentUser;
  print('[RetryStream] Stream created. Auth user: ${currentUser?.uid ?? 'NULL'}');

  void subscribe() {
    subscription?.cancel();

    try {
      subscription = streamFactory().listen(
        (data) {
          retryCount = 0; // Reset on success
          if (!controller.isClosed) {
            controller.add(data);
          }
        },
        onError: (error, stackTrace) {
          final authUser = FirebaseAuth.instance.currentUser;
          print('[RetryStream] ERROR received. Auth user: ${authUser?.uid ?? 'NULL'}');
          print('[RetryStream] Error type: ${error.runtimeType}, shouldRetry: ${retryCheck(error)}');

          if (retryCheck(error) && retryCount < maxRetries) {
            retryCount++;
            final delay = initialDelay * retryCount;
            print('[RetryStream] Retry $retryCount/$maxRetries after ${delay.inMilliseconds}ms - Error: $error');

            Future.delayed(delay, () {
              if (!controller.isClosed) {
                final retryAuthUser = FirebaseAuth.instance.currentUser;
                print('[RetryStream] Retrying now. Auth user: ${retryAuthUser?.uid ?? 'NULL'}');
                subscribe();
              }
            });
          } else {
            print('[RetryStream] NOT retrying. retryCount=$retryCount, maxRetries=$maxRetries');
            if (!controller.isClosed) {
              controller.addError(error, stackTrace);
            }
          }
        },
        onDone: () {
          if (!controller.isClosed) {
            controller.close();
          }
        },
      );
    } catch (e, st) {
      if (retryCheck(e) && retryCount < maxRetries) {
        retryCount++;
        final delay = initialDelay * retryCount;
        print('[RetryStream] Retry $retryCount/$maxRetries after ${delay.inMilliseconds}ms - Error: $e');

        Future.delayed(delay, () {
          if (!controller.isClosed) {
            subscribe();
          }
        });
      } else {
        controller.addError(e, st);
      }
    }
  }

  controller.onListen = subscribe;
  controller.onCancel = () {
    subscription?.cancel();
  };

  return controller.stream;
}
