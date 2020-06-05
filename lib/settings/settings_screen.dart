import 'package:bloc_communication/app/country/country_bloc.dart';
import 'package:bloc_communication/app/country/country_events.dart';
import 'package:bloc_communication/app/country/country_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  void _setCanada(BuildContext context) {
    BlocProvider.of<CountryBloc>(context)
      .add(SetCountryEvent(country: 'canada'));
  }

  void _setUS(BuildContext context) {
    BlocProvider.of<CountryBloc>(context)
      .add(SetCountryEvent(country: 'us'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo')
      ),
      body: BlocConsumer<CountryBloc, CountryState>(
        listener: (context, state) {
          if (state is CountrySetState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
                (route) => false,
            );
          }
        },
        buildWhen: (previous, current) => false, // Do not update the UI because we leave the screen
        builder: (context, state) {
          if (state.country == null) {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Set country:'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Canada',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _setCanada(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'US',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _setUS(context),
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Current country is ${state.country}. Switch to:'),
                  ),
                ),
                if (state.country != "canada")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Canada',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _setCanada(context),
                    ),
                  ),
                if (state.country != 'us')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'US',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _setUS(context),
                    ),
                  )
              ],
            );
          }
        },
      ),
    );
  }
}
