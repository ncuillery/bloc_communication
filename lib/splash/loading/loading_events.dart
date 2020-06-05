import 'package:flutter/foundation.dart';

abstract class LoadingEvent {}

/// Country is loaded
class EndLoadingCountryEvent extends LoadingEvent {
  final bool isCountrySet;

  EndLoadingCountryEvent({@required this.isCountrySet})
    : assert(isCountrySet != null);

  @override
  String toString() {
    return 'EndLoadingCountryEvent{isCountrySet: $isCountrySet}';
  }
}

/// Config is loaded
class EndLoadingConfigEvent extends LoadingEvent {
  @override
  String toString() {
    return 'EndLoadingConfigEvent{}';
  }
}

/// The splash screen has been shown enough time.
class MinimumTimeElapsedEvent extends LoadingEvent {
  @override
  String toString() {
    return 'MinimumTimeElapsedEvent{}';
  }
}

/// The loading sequence is complete. We can navigate to the next screen.
class CompleteLoadingEvent extends LoadingEvent {
  @override
  String toString() {
    return 'CompleteLoadingEvent{}';
  }
}

