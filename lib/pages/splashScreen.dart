import 'dart:math' as math;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:gyansutra/pages/signIn.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:gyansutra/pages/Userinput.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:gyansutra/extra/backEndSup.dart';


class splashScreen extends StatefulWidget{
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}
final FStorage = const FlutterSecureStorage();

class _splashScreenState extends State<splashScreen> {

  var islaunched = false;
  void initState() {
    super.initState();
    checkLoginStatus();
    Future.delayed(const Duration(seconds:1), () {
      setState(() {
        islaunched = true;
      });
    });
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 6500));
    String? access_token =await FStorage.read(key: 'access_token');
    String? refresh_token =await FStorage.read(key: 'refresh_token');
    String? is_profile_complete =await FStorage.read(key: 'is_profile_complete');

    if (access_token != null) {
      if ( is_profile_complete == 'true' && is_profile_complete == 'true'){
        Navigator.pushReplacement(context,MaterialPageRoute (builder: (context) => HomePage()));
      }else{
        Navigator.pushReplacement(context,MaterialPageRoute (builder: (context) => signIn()));
      }
    } else {
      Navigator.pushReplacement(context,MaterialPageRoute (builder: (context) => signIn()));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Image.asset(
          "assets/gifs/splashscreen.gif",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

