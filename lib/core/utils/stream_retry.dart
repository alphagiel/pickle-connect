import 'dart:async';

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
          if (retryCheck(error) && retryCount < maxRetries) {
            retryCount++;
            final delay = initialDelay * retryCount;

            Future.delayed(delay, () {
              if (!controller.isClosed) {
                subscribe();
              }
            });
          } else {
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
