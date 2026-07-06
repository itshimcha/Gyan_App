import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/pages/USER/aboutgyan.dart';


class Aboutnkt extends StatefulWidget {
  const Aboutnkt({super.key});

  @override
  State<Aboutnkt> createState() => _AboutnktState();
}

class _AboutnktState extends State<Aboutnkt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),

            LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double h = 1700;
                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          "assets/images/nakshatrabg.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: h,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          width: screenWidth,
                          height: h * 0.16,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.2,1]
                            ),
                          ),

                        ),
                      ),
                      Positioned(
                        top: h * 0.000,
                        child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Color(0xffe6e6fa),
                                      size: 20,
                                    ),
                                  ),
                      ),
                      Positioned(
                        top: h * 0.021,
                        left: 25,
                        right: 25,
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Text(StaticData.aboutNakt["title"]!,
                                style: GoogleFonts.gloock(
                                    color: Color(0xffe6e6fa),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 35),),
                              SizedBox(height: 10,),
                              Text(StaticData.aboutNakt["intro"]!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    color: Color(0x88e6e6fa),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9),)
                            ],
                          )
                        ),
                      ), // abtnkt
                      Positioned(
                        top: h * 0.14,
                        left: 0,
                        right: 0,

                        child: Container(
                          width: screenWidth*0.3,
                          height: h * 0.04,
                          child: Column(

                            children: [
                              Text(StaticData.initat["title"]!,
                                style: GoogleFonts.gloock(
                                    color: Color(0xffe6e6fa),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30),),

                            ],
                          ),
                        ),
                      ), // initiative
                      Positioned(
                        top: h * 0.175,
                        left: 20,
                        right: screenWidth*0.28,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Aboutgyan()));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(StaticData.initat["subtitle"]!,
                                    style: GoogleFonts.gloock(
                                        color: Color(0xffe6e6fa),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),),
                                  SizedBox(width: 10,),
                                  Icon(Icons.arrow_circle_right, color: Color(0xffe6e6fa), size: 15,)
                                ],
                              ),
                              SizedBox(height: 2,),
                              Text(StaticData.initat["detail"]!,
                                style: GoogleFonts.poppins(
                                    color: Color(0x88e6e6fa),
                                    fontWeight: FontWeight.w500,
                                    fontSize:9),)
                            ],
                          ),
                        ),
                      ), // gyansutra
                      Positioned(
                        top: h * 0.27,
                        left: 20,
                        right: screenWidth*0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(StaticData.SpaceCon["title"]!,
                              style: GoogleFonts.gloock(
                                  color: Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),),
                            SizedBox(height: 2,),
                            Text(StaticData.SpaceCon["intro"]!,
                              style: GoogleFonts.poppins(
                                  color: Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize:9),)
                          ],
                        ),
                      ), // spacecon
                      Positioned(
                        top: h * 0.46,
                        left: screenWidth*0.2,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(StaticData.scienceComm["title"]!,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.gloock(
                                  color: Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),),
                            SizedBox(height: 2,),
                            Text(StaticData.scienceComm["detail"]!,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                  color: Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize:9),)
                          ],
                        ),
                      ), // sciececom
                      Positioned(
                        top: h * 0.56,
                        left: 20,
                        right: screenWidth*0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(StaticData.achievements["title"]!,
                              style: GoogleFonts.gloock(
                                  color: Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),),
                            SizedBox(height: 2,),
                            Text(StaticData.achievements["detail"]!,
                              style: GoogleFonts.poppins(
                                  color: Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize:9),)
                          ],
                        )
                      ), // achievement
                      Positioned(
                        top: h * 0.7,
                        left: 20,
                        right: screenWidth*0.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(StaticData.faculty["title"]!,
                              style: GoogleFonts.gloock(
                                  color: Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),),
                            SizedBox(height: 2,),
                            Text(StaticData.faculty["detail"]!,
                              style: GoogleFonts.poppins(
                                  color: Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize:9),)
                          ],
                        )
                      ), // faculty
                      Positioned(
                        top: h * 0.81,
                        left: screenWidth*0.2,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(StaticData.lookingBeyond["title"]!,
                              style: GoogleFonts.gloock(
                                  color: Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),),
                            SizedBox(height: 2,),
                            Text(StaticData.lookingBeyond["intro"]!,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                  color: Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize:9),)
                          ],
                        ),
                      ), // looking beyond
                      Positioned(
                        top: h * 0.84,
                        left: 10,
                        right: 20,
                        child: MainTxt(text: "nakshatra"),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
