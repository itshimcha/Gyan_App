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
            LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                return SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/nakshatrabg.png"),
                        fit: BoxFit.cover,
                        opacity: 0.4,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.2, 1.0],
                            ),
                          ),
                          child: SafeArea(
                            bottom: false,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Color(0xffe6e6fa),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            children: [
                              Text(
                                StaticData.aboutNakt["title"]!,
                                style: GoogleFonts.gloock(
                                  color: const Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 35,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                StaticData.aboutNakt["intro"]!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: const Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20 ),
                          child: Text(
                            StaticData.initat["title"]!,
                            style: GoogleFonts.gloock(
                              color: const Color(0xffe6e6fa),
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: screenWidth * 0.28, top: 10, bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Aboutgyan()));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      StaticData.initat["subtitle"]!,
                                      style: GoogleFonts.gloock(
                                        color: const Color(0xffe6e6fa),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.arrow_circle_right, color: Color(0xffe6e6fa), size: 15)
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  StaticData.initat["detail"]!,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0x88e6e6fa),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: screenWidth * 0.45,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StaticData.SpaceCon["title"]!,
                                style: GoogleFonts.gloock(
                                  color: const Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                StaticData.SpaceCon["intro"]!,
                                style: GoogleFonts.poppins(
                                  color: const Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.2, right: 20, ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                StaticData.scienceComm["title"]!,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.gloock(
                                  color: const Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                StaticData.scienceComm["detail"]!,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  color: const Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: screenWidth * 0.4,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StaticData.achievements["title"]!,
                                style: GoogleFonts.gloock(
                                  color: const Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                StaticData.achievements["detail"]!,
                                style: GoogleFonts.poppins(
                                  color: const Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,

                                  fontSize: 9,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: screenWidth * 0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StaticData.faculty["title"]!,
                                style: GoogleFonts.gloock(
                                  color: const Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                StaticData.faculty["detail"]!,
                                style: GoogleFonts.poppins(
                                  color: const Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.2, right: 20,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                StaticData.lookingBeyond["title"]!,
                                style: GoogleFonts.gloock(
                                  color: const Color(0xffe6e6fa),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                StaticData.lookingBeyond["intro"]!,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  color: const Color(0x88e6e6fa),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20, bottom: 30),
                          child: MainTxt(text: "nakshatra"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
