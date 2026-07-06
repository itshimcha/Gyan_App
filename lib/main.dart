import 'package:flutter/material.dart';
import 'package:gyansutra/pages/splashScreen.dart';
import 'package:flutter/services.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nakshatra App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: .fromSeed(seedColor: Colors.black),
      ),
      home: const splashScreen(),
    );
  }
}

