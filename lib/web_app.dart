import 'package:air_pollution_app/widgets/pages/charts_page.dart';
import 'package:air_pollution_app/widgets/pages/home_page.dart';
import 'package:flutter/material.dart';

class WebApp extends StatelessWidget {
  const WebApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Air pollution',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Air pollution'),
          ),
          body: const HomePage(),
        ),
        routes: {
          '/home': (context) => const HomePage(),
          '/charts': (context) => const ChartsPage(),
        });
  }
}
