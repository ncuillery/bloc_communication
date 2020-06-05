import 'package:bloc_communication/app/config/config_bloc.dart';
import 'package:bloc_communication/app/country/country_bloc.dart';
import 'package:bloc_communication/home/home_screen.dart';
import 'package:bloc_communication/settings/settings_screen.dart';
import 'package:bloc_communication/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CountryBloc>(
          create: (_) => CountryBloc(),
        ),
        BlocProvider<ConfigBloc>(
          create: (_) => ConfigBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Bloc communication Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => SplashScreen(),
          '/home': (_) => HomeScreen(),
          '/settings': (_) => SettingsScreen(),
        }
      ),
    );
  }
}