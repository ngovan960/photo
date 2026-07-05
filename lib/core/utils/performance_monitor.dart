import 'package:flutter/foundation.dart';

class PerformanceMonitor {
  static final Map<String, Stopwatch> _timers = {};

  static void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }

  static Duration stopTimer(String name) {
    final timer = _timers.remove(name);
    if (timer == null) return Duration.zero;
    timer.stop();
    
    final duration = timer.elapsed;
    
    if (kDebugMode) {
      print('[Performance] $name: ${duration.inMilliseconds}ms');
    }
    
    return duration;
  }

  static Duration getTimerDuration(String name) {
    final timer = _timers[name];
    if (timer == null) return Duration.zero;
    return timer.elapsed;
  }

  static void clearAll() {
    _timers.clear();
  }

  static Map<String, Duration> getAllTimers() {
    final result = <String, Duration>{};
    for (final entry in _timers.entries) {
      result[entry.key] = entry.value.elapsed;
    }
    return result;
  }
}
