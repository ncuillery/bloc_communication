import 'package:bloc/bloc.dart';
import 'package:bloc_communication/app/country/country_events.dart';
import 'package:bloc_communication/app/country/country_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  @override
  CountryState get initialState => CountryUnknownState();

  @override
  void onEvent(CountryEvent event) {
    print('[Country bloc] ' + event.toString());
    super.onEvent(event);
  }

  @override
  Stream<CountryState> mapEventToState(CountryEvent event) async* {
    if (event is ReadCountryEvent) {
      final deviceStorage = await SharedPreferences.getInstance();
      final country = deviceStorage.getString('country');
      if (country == null) {
        yield CountryUnsetState();
      } else {
        yield CountrySetState(country);
      }
    } else if (event is SetCountryEvent) {
      final deviceStorage = await SharedPreferences.getInstance();
      await deviceStorage.setString('country', event.country);
      yield CountrySetState(event.country);
    }
  }
}
