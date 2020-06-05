import 'package:bloc/bloc.dart';
import 'package:bloc_communication/app/config/config_events.dart';
import 'package:bloc_communication/app/config/config_states.dart';
import 'package:bloc_communication/app/config/models.dart';

Future<AppConfig> mockFirebaseRemoteConfigFetch(String country) async {
  await Future.delayed(Duration(milliseconds: 500));

  return AppConfig(
    key1: '${country}_value1',
    key2: '${country}_value2',
  );
}

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  @override
  ConfigState get initialState => ConfigDefaultState();

  @override
  void onEvent(ConfigEvent event) {
    print('[Config bloc] ' + event.toString());
    super.onEvent(event);
  }

  @override
  Stream<ConfigState> mapEventToState(ConfigEvent event) async* {
    if (event is FetchConfigEvent) {
      AppConfig appConfig = await mockFirebaseRemoteConfigFetch(event.country);
      yield ConfigFetchedState(appConfig: appConfig);
    }
  }
}
