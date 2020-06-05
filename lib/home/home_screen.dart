import 'package:bloc_communication/app/config/config_bloc.dart';
import 'package:bloc_communication/app/config/config_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo')),
      body: Center(
        child: BlocBuilder<ConfigBloc, ConfigState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Home screen',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text('key1: ${state.appConfig.key1}'),
                Text('key2: ${state.appConfig.key2}'),
              ],
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(children: [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/settings');
            },
          ),
        ]),
      ),
    );
  }
}
