abstract class CountryState {
  final String country;

  const CountryState({this.country});
}

/// Country has not been read yet (app start)
class CountryUnknownState extends CountryState {
  const CountryUnknownState() : super(country: null);

  @override
  String toString() {
    return 'UnknownCountryState{}';
  }
}

/// Country has been read but is null (first launch)
class CountryUnsetState extends CountryState {
  const CountryUnsetState() : super(country: null);

  @override
  String toString() {
    return 'CountryUnsetState{}';
  }
}

/// Country is read
class CountrySetState extends CountryState {
  const CountrySetState(String country) : super(country: country);

  @override
  String toString() {
    return 'CountrySetState{country: $country}';
  }
}