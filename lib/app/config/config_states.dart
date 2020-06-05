import 'package:bloc_communication/app/config/models.dart';
import 'package:flutter/foundation.dart';

abstract class ConfigState {
  final AppConfig appConfig;

  const ConfigState({@required this.appConfig}): assert(appConfig != null);
}

/// Default config is Remote Config is not fetched yet or unreachable
class ConfigDefaultState extends ConfigState {
  const ConfigDefaultState()
      : super(
          appConfig: const AppConfig(
            key1: "default_value1",
            key2: "default_value2",
          ),
        );
}

/// Config fetched from Firebase Remote Config
class ConfigFetchedState extends ConfigState {
  const ConfigFetchedState({appConfig}) : super(appConfig: appConfig);
}
