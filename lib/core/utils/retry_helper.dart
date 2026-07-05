import 'dart:math';

class RetryHelper {
  static Future<T> withRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    double backoffFactor = 2.0,
    bool Function(T result)? shouldRetry,
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        final result = await operation();
        if (shouldRetry != null && shouldRetry(result)) {
          attempts++;
          await Future.delayed(delay * pow(backoffFactor, attempts));
          continue;
        }
        return result;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) rethrow;
        await Future.delayed(delay * pow(backoffFactor, attempts));
      }
    }
    throw StateError('Max retries exceeded');
  }

  static Future<T?> withRetryOrNull<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    try {
      return await withRetry(
        operation,
        maxRetries: maxRetries,
        delay: delay,
      );
    } catch (e) {
      return null;
    }
  }
}
