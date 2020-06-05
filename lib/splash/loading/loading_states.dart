enum CountryLoaded {
  /* Country has not been loaded yet */
  unknown,
  /* Country has been loaded but is not set (first launch) */
  unset,
  /* Country is loaded */
  set,
}

abstract class LoadingState {
  final CountryLoaded countryLoaded;
  final bool isConfigLoaded;
  final bool isMinimumTimeElapsed;

  const LoadingState({
    this.countryLoaded,
    this.isConfigLoaded,
    this.isMinimumTimeElapsed,
  });
}

/// Initial state of the loading sequence
class InitialState extends LoadingState {
  InitialState()
    : super(
    countryLoaded: CountryLoaded.unknown,
    isConfigLoaded: false,
    isMinimumTimeElapsed: false,
  );
}

/// Loading sequence has started but is not complete
class PartialLoadingState extends LoadingState {
  PartialLoadingState({
    countryLoaded,
    isConfigLoaded,
    isMinimumTimeElapsed,
  }) : super(
    countryLoaded: countryLoaded,
    isConfigLoaded: isConfigLoaded,
    isMinimumTimeElapsed: isMinimumTimeElapsed,
  );

  bool isComplete() {
    return countryLoaded != CountryLoaded.unknown &&
      isConfigLoaded &&
      isMinimumTimeElapsed;
  }

  factory PartialLoadingState.fromState(
    LoadingState previousState, {
      CountryLoaded countryLoaded,
      bool isConfigLoaded,
      bool isMinimumTimeElapsed,
      String navigateTo,
    }) {
    return PartialLoadingState(
      countryLoaded: countryLoaded ?? previousState.countryLoaded,
      isConfigLoaded: isConfigLoaded ?? previousState.isConfigLoaded,
      isMinimumTimeElapsed:
      isMinimumTimeElapsed ?? previousState.isMinimumTimeElapsed,
    );
  }
}

/// Loading sequence is complete, we can navigate to the
class CompleteLoadingState extends LoadingState {
  final String navigateTo;

  CompleteLoadingState({
    this.navigateTo,
    countryLoaded,
    isConfigLoaded,
    isMinimumTimeElapsed,
  }) : super(
    countryLoaded: countryLoaded,
    isConfigLoaded: isConfigLoaded,
    isMinimumTimeElapsed: isMinimumTimeElapsed,
  );

  factory CompleteLoadingState.fromState(
    LoadingState previousState, {
      bool isCountryLoaded,
      bool isConfigLoaded,
      bool isMinimumTimeElapsed,
      String navigateTo,
    }) {
    return CompleteLoadingState(
      countryLoaded: previousState.countryLoaded,
      isConfigLoaded: previousState.isConfigLoaded,
      isMinimumTimeElapsed: previousState.isMinimumTimeElapsed,
      navigateTo: navigateTo,
    );
  }
}