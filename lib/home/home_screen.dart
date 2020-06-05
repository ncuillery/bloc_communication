import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo')),
      body: Center(
        child: Text('Home screen'),
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
