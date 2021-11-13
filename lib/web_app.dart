import 'package:air_pollution_app/maps_widget.dart';
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
        body: const MapsWidget(),
      ),
    );
  }
}
