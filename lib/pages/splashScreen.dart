import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gyansutra/pages/signIn.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

final FStorage = const FlutterSecureStorage();

class _splashScreenState extends State<splashScreen> {
  var islaunched = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          islaunched = true;
        });
      }
    });
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 4720));
    if (!mounted) return;

    String? access_token = await FStorage.read(key: 'access_token');
    String? is_profile_complete = await FStorage.read(key: 'is_profile_complete');

    if (access_token != null && is_profile_complete == 'true') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signIn()));
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
              top: islaunched ? -1000: 1000,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Transform.rotate(
                    angle: math.pi/-4,
                    child: Icon(Icons.rocket_launch,color: Colors.white,size: 120,),),
                  CustomPaint(
                    size: Size(1000, 1800),
                    painter: ElongatedSmokePainter(),
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

class ElongatedSmokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rect = Offset.zero & size;
    paint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        Colors.black
      ],
      stops: [0.0, 0.3],
    ).createShader(rect);

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.cubicTo(
      size.width * 0.2, size.height * 0.08,
      -50, size.height * 0.25,
      -50, size.height,
    );
    path.lineTo(size.width + 50, size.height);
    path.cubicTo(
      size.width + 50, size.height * 0.25,
      size.width * 0.8, size.height * 0.08,
      size.width / 2, 0,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}