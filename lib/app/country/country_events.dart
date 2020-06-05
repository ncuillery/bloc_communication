import 'package:flutter/foundation.dart';

abstract class CountryEvent {}

/// Read the country from shared preferences
class ReadCountryEvent extends CountryEvent {
  @override
  String toString() {
    return 'ReadCountryEvent{}';
  }
}

/// Save the country in shared preferences
class SetCountryEvent extends CountryEvent {
  final String country;

  SetCountryEvent({@required this.country}) : assert(country != null);

  @override
  String toString() {
    return 'SetCountryEvent{country: $country}';
  }
}
