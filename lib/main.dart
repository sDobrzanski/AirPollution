import 'package:air_pollution_app/global_providers.dart';
import 'package:air_pollution_app/web_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const WebApp());
}
