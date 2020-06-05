import 'package:flutter/foundation.dart';

abstract class ConfigEvent {
  const ConfigEvent();
}

/// Fetch the config from Firebase Remote Config for the given country.
class FetchConfigEvent extends ConfigEvent {
  final String country;

  const FetchConfigEvent({@required this.country}) : assert(country != null);

  @override
  String toString() {
    return 'FetchConfigEvent{country: $country}';
  }
}