import 'dart:math' as math;
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
    await Future.delayed(const Duration(seconds: 4));
    String? access_token =await FStorage.read(key: 'access_token');
    String? refresh_token =await FStorage.read(key: 'refresh_token');
    String? is_profile_complete =await FStorage.read(key: 'is_profile_complete');

    if (access_token != null) {
      if ( is_profile_complete == 'true'){
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
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.black,
              )
            ),
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/images/logo.png',
                  fit: BoxFit.contain
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(seconds: 2),
              top: islaunched ? -200: 1000,
              left: 0,
              right: 0,
              child: Column(
                    children: [
                      Transform.rotate(
                          angle: math.pi/-4,
                          child: Icon(Icons.rocket_launch,color: Colors.white,size: 120,),),
                      Container(
                        width: 450,
                        height:1600,
                        color: Colors.white,

                      )
                    ],
                  )
              ,
            )
          ],
        )
    );
  }
}

