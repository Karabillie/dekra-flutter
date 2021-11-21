import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dekra Lichtschranke',
      home: HomePageWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class HomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: ('SPEED')),
              Tab(text: ('SETTINGS')),
            ],
          ),
          title: const Text('Dekra Lichtschranke'),
        ),
        body: const TabBarView(
          children: [
            SettingsWidget(),
            SettingsWidget(),
          ],
        ),
      ),
    );
  }
}
