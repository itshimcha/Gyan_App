import 'package:flutter/material.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StarBg(),
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                 color: Colors.black38,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10,top: 50),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false);
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Icon(Icons.home,color: Colors.black,))),
                        )
                    ),
                  ),
                  SizedBox(height: 100,),
                  Text("Explore your space".toUpperCase(), style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w700,color: Colors.white),),
                  SizedBox(height: 150,),
                  Lottie.asset("assets/lottie/Crying.json", height: 300,width: 300,),
                  Text("Will be Introduce Soon", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.white),),
                ],
              ),
          )
    ]
      ),
    );
  }
}
