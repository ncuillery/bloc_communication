# bloc_communication

This is a sample app showing a complex loading sequence, implemented using the [bloc](https://bloclibrary.dev/#/) architecture.

It represents an app supposed to be launched in different countries. Each country has its own configuration, handled remotely with Firebase Remote Config (replaced by a mock in this repo).

## Behavior implemented in this sample app:

- On startup, the app shows a splash screen. The country is read from the device storage, then it loads the appropriate configuration, then we navigate to the home screen.
- On first launch, the country is unknown, so we redirect the user to the settings page instead where he can set the country (US or Canada).
- The country can be changed anytime in the settings screen. When the country is changed, the user is redirected to the splash screen to restart the loading sequence.

![](https://raw.githubusercontent.com/ncuillery/bloc_communication/master/bloc_communication.gif)

## Bloc implementation detail:

There are 3 blocs:
- `CountryBloc` and `ConfigBloc`: global unique "app-level" blocs. They store respectively the current country and the config for this country
- `LoadingBloc`: "route-level" bloc, created each time the splash screen is shown. Depends on the 2 other blocs. It contains the loading sequence business logic.

The `LoadingBloc` declares some 3 listeners in the constructor, inspired by the [bloc documentation](https://bloclibrary.dev/#/architecture?id=bloc-to-bloc-communication):

```dart
_listenCountryChangeSubscription = _countryBloc.listen(
  _handleCountryChange,
);
_listenConfigLoadedSubscription = _configBloc.listen(
  _handleConfigLoaded,
);
_listenLoadingCompleteSubscription = listen(
  _handleLoadingComplete,
);
```

- Listen the `CountryBloc` to fetch the config when the country changes
- Listen the `ConfigBloc` to continue the loading sequence
- Listen itself to trigger the navigation to the next screen when the loading is complete

## Problem:

The app works as expected but there are a lot of interfering events. For example, here is the output when the app starts with country set to "us":

```
[Country bloc] ReadCountryEvent{}
[Country bloc] ReadCountryEvent{}
[Loading bloc] EndLoadingCountryEvent{isCountrySet: true}
[Config bloc] FetchConfigEvent{country: us}
[Loading bloc] EndLoadingCountryEvent{isCountrySet: true}
[Config bloc] FetchConfigEvent{country: us}
[Loading bloc] EndLoadingConfigEvent{}
[Loading bloc] EndLoadingConfigEvent{}
[Loading bloc] MinimumTimeElapsedEvent{}
[Loading bloc] CompleteLoadingEvent{}
```

*When subscribing to a stream, the listener is called immediately with the last item of the stream.* Therefore we have 2 loading sequence in parallel:

- One explicitly triggered in the LoadingConstructor with `_handleCountryChange(_countryBloc.state);`
- One triggered automatically by simply declaring the listeners

### Option 1: going downwind

We can choose to leverage the listener behavior and use this implicit call to trigger the loading sequence. In other words, it means deleting the `_handleCountryChange(_countryBloc.state)` instruction ([this one](https://github.com/ncuillery/bloc_communication/blob/master/lib/splash/loading/loading_bloc.dart#L47)).

It works better. The output above becomes:

```
[Country bloc] ReadCountryEvent{}
[Loading bloc] EndLoadingCountryEvent{isCountrySet: true}
[Config bloc] FetchConfigEvent{country: us}
[Loading bloc] EndLoadingConfigEvent{}
[Loading bloc] MinimumTimeElapsedEvent{}
[Loading bloc] CompleteLoadingEvent{}
```

I exactly have the events that I expected, but there are 2 problems:
- It hurts the global understanding on the whole thing. The loading sequence start became implicit. A developer not familiar with the stream API may asks himself how the loading sequence starts.
- There is a remaining interfering event when switching country from the settings:

_Output when switching from US to Canada in the settings screen:_

```
flutter: [Country bloc] SetCountryEvent{country: canada}
flutter: [Loading bloc] EndLoadingCountryEvent{isCountrySet: true}
flutter: [Config bloc] FetchConfigEvent{country: canada}
flutter: [Loading bloc] EndLoadingConfigEvent{}
flutter: [Loading bloc] EndLoadingConfigEvent{} // This one here
flutter: [Loading bloc] MinimumTimeElapsedEvent{}
flutter: [Loading bloc] CompleteLoadingEvent{}
```

This one is happening because the `ConfigBloc` listener has emit a `ConfigFetchedState`. See [code](https://github.com/ncuillery/bloc_communication/blob/master/lib/splash/loading/loading_bloc.dart#L71-L75). To avoid that, we would have to reset the config state in the settings screen when we change country, which means more code, and it is also bad for the separation of concern.

### Option 2: going upwind

The other way is to keep the explicity loading sequence launch, but ignore the first listener call.

The app works perfectly if I add `skip(1)` to each listener declaration:

```dart
_listenCountryChangeSubscription = _countryBloc.skip(1).listen(
  _handleCountryChange,
);
_listenConfigLoadedSubscription = _configBloc.skip(1).listen(
  _handleConfigLoaded,
);
_listenLoadingCompleteSubscription = skip(1).listen(
  _handleLoadingComplete,
);
```

This `.skip(1)` is the only "weirdness" added to make things work, the rest of the code is understandable and as concise as possible.

Removing the first immediate call makes sense in the way that when we "listen" to something, we want to be notified when something happens AFTER we start listening, not before.

Analogy with the web: when adding a "onclick" handler to a button, we don't expect the handler to be called immediately because we clicked on the button 2 minutes ago.

That also how flutter_bloc works. See [source code](https://github.com/felangel/bloc/blob/4f2631aec288fc2de5ebaef5fddd8948315031b4/packages/flutter_bloc/lib/src/bloc_listener.dart#L191)
