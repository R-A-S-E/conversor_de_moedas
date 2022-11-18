import 'package:conversor_de_moedas/src/home/page/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Home(),
        theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white));
  }
}
