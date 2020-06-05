import 'package:bloc_communication/app/config/config_bloc.dart';
import 'package:bloc_communication/app/country/country_bloc.dart';
import 'package:bloc_communication/splash/loading/loading_bloc.dart';
import 'package:bloc_communication/splash/loading/loading_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoadingBloc>(
      create: (_) => LoadingBloc(
        BlocProvider.of<CountryBloc>(context),
        BlocProvider.of<ConfigBloc>(context),
      ),
      child: BlocListener<LoadingBloc, LoadingState>(
        listener: (context, state) {
          if (state is CompleteLoadingState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              state.navigateTo,
              (route) => false,
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              child: Text(
                'Splash screen',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
