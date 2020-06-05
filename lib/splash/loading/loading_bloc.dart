import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_communication/app/config/config_bloc.dart';
import 'package:bloc_communication/app/config/config_events.dart';
import 'package:bloc_communication/app/config/config_states.dart';
import 'package:bloc_communication/app/country/country_bloc.dart';
import 'package:bloc_communication/app/country/country_events.dart';
import 'package:bloc_communication/app/country/country_states.dart';
import 'package:bloc_communication/splash/loading/loading_events.dart';
import 'package:bloc_communication/splash/loading/loading_states.dart';

/// To avoid Splash screen flickering when the loading is too fast, we ensure
/// that the SplashScreen widget stays visible for a minimum amount of time.
const _minimumTime = Duration(seconds: 2);

/// This Bloc implements the loading sequence of the app (while the
/// SplashPage widget is displayed).
/// - country detection/loading
/// - remote configuration
/// - navigate to the next page
class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  final CountryBloc _countryBloc;
  final ConfigBloc _configBloc;
  StreamSubscription _listenCountryChangeSubscription;
  StreamSubscription _listenConfigLoadedSubscription;
  StreamSubscription _listenLoadingCompleteSubscription;
  Timer _minimumTimeElapsedTimer;

  LoadingBloc(this._countryBloc, this._configBloc) : super() {
    _listenCountryChangeSubscription = _countryBloc.listen(
      _handleCountryChange,
    );
    _listenConfigLoadedSubscription = _configBloc.listen(
      _handleConfigLoaded,
    );
    _listenLoadingCompleteSubscription = listen(
      _handleLoadingComplete,
    );

    _minimumTimeElapsedTimer = Timer(
      _minimumTime,
      _handleMinimumTimeElapsed,
    );

    // Trigger the loading sequence, starting from the first step: country
    _handleCountryChange(_countryBloc.state);
  }

  @override
  void onEvent(LoadingEvent event) {
    print('[Loading bloc] ' + event.toString());
    super.onEvent(event);
  }

  void _handleCountryChange(CountryState state) {
    if (state is CountryUnknownState) {
      // App start: Country is unknown
      _countryBloc.add(ReadCountryEvent());
    } else if (state is CountrySetState) {
      // Country read from local storage
      add(EndLoadingCountryEvent(isCountrySet: true));
      _configBloc.add(FetchConfigEvent(country: state.country));
    } else if (state is CountryUnsetState) {
      // First launch: end loading sequence and navigate to settings
      add(EndLoadingCountryEvent(isCountrySet: false));
      add(EndLoadingConfigEvent());
    }
  }

  void _handleConfigLoaded(ConfigState state) {
    if (state is ConfigFetchedState) {
      add(EndLoadingConfigEvent());
    }
  }

  void _handleMinimumTimeElapsed() {
    add(MinimumTimeElapsedEvent());
  }

  void _handleLoadingComplete(LoadingState state) {
    if (state is PartialLoadingState && state.isComplete()) {
      add(CompleteLoadingEvent());
    }
  }

  @override
  LoadingState get initialState {
    return InitialState();
  }

  @override
  Stream<LoadingState> mapEventToState(LoadingEvent event) async* {
    if (event is EndLoadingCountryEvent) {
      yield PartialLoadingState.fromState(
        state,
        countryLoaded:
            event.isCountrySet ? CountryLoaded.set : CountryLoaded.unset,
      );
    } else if (event is EndLoadingConfigEvent) {
      yield PartialLoadingState.fromState(
        state,
        isConfigLoaded: true,
      );
    } else if (event is MinimumTimeElapsedEvent) {
      yield PartialLoadingState.fromState(
        state,
        isMinimumTimeElapsed: true,
      );
    } else if (event is CompleteLoadingEvent) {
      var navigateTo;
      if (state.countryLoaded == CountryLoaded.set) {
        navigateTo = '/home';
      } else if (state.countryLoaded == CountryLoaded.unset) {
        navigateTo = '/settings';
      }

      yield CompleteLoadingState.fromState(state, navigateTo: navigateTo);
    }
  }

  @override
  Future<void> close() async {
    _minimumTimeElapsedTimer.cancel();
    await Future.wait([
      _listenCountryChangeSubscription.cancel(),
      _listenConfigLoadedSubscription.cancel(),
      _listenLoadingCompleteSubscription.cancel(),
    ]);
    await super.close();
  }
}
