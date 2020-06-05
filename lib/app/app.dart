import 'package:bloc_communication/home/home_screen.dart';
import 'package:bloc_communication/settings/settings_screen.dart';
import 'package:bloc_communication/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}