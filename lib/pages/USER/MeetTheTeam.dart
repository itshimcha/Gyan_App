import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/com_wid.dart';

class Meettheteam extends StatefulWidget {
  const Meettheteam({super.key});

  @override
  State<Meettheteam> createState() => _MeettheteamState();
}

class _MeettheteamState extends State<Meettheteam> {

  Widget Card(String image, String Name, String Designation, String Detail){
    return Expanded(
        child: SizedBox(
          height: 280,
          child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 170,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(image,fit: BoxFit.cover,),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff010101),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: [0.0,0.2]
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff010101),
                                  Colors.transparent,
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                stops: [0.0,0.2]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                        height: 135,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${Name}",style: GoogleFonts.forum(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 0.8
                            ),
                            ),
                            SizedBox(height: 2,),
                            Text(
                                Designation,
                                style: GoogleFonts.forum(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    height: 1.1)
                            ),
                            SizedBox(height: 5,),
                            Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 0),
                                child: Text(
                                  Detail,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 8,
                                  style: GoogleFonts.forum(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      height: 1
                                  ),
                                )
                            )// Designation
                          ],
                        )
                    )
                )
              ]
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(0xff010101)
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 230,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          "assets/images/Firefly.png",
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [0.0,0.8]
                            ),
                          ),
                        ),
                        Positioned(
                          top: 35,
                          left: 10,
                          child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              }, icon: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xffe6e6fa),size: 20,)),
                        ),
                        Positioned(
                          top: 70,
                          left: 20,
                          right: 20,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Meet The Team", style: GoogleFonts.gloock(color: Color(0xffe6e6fa),fontWeight: FontWeight.w700,fontSize: 35),),
                                SizedBox(height: 10),
                                Text.rich(
                                    textAlign: TextAlign.center,
                                    TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Nakshatra " ,
                                            style: GoogleFonts.poppins(
                                                color: Color(0xaae6e6fa),
                                                fontWeight: FontWeight.w800,
                                                fontSize: 10
                                            ),
                                          ),
                                          TextSpan(
                                            text: "features a sleek, space-inspired design for effortless navigation. Whether exploring the cosmos or hunting for lab files, exactly what you need is just a tap away." ,
                                            style: GoogleFonts.poppins(
                                                color: Color(0x88e6e6fa),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10
                                            ),
                                          ),
                                        ]
                                    )
                                ),
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 25, left: 25, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card("assets/images/Team/himcha.png",
                        "Himanshu Chaurasia",
                        "App Developer",
                      "Hi! This is Himcha. I spent like ten minutes typing and deleting this, so... this is what we're going with ig hehe"
                      ),
                      SizedBox(width: 10,),
                      Card("assets/images/Team/coco.png",
                        "Pratyaksh",
                        "Backend Developer",
                        "Yo , me Coco aur Data, APIs aur crash ka dukh me akele jhelta hoon. Mera code sirf chai aur bhagwan ke bharose chalta hai. Agar app band ho jaye toh mera fix reply: 'Bhai, mere laptop pe chal raha hai!'"
                      ),
                    ]
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 25, left: 25, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card("assets/images/Team/akash.png",
                          "Akash",
                          "Backend Developer",
                          "Hi, I’m akash from ICE,"
                        ),
                        SizedBox(width: 10,),
                        Card("assets/images/Team/atharv.png",
                          "Atharv",
                          "Backend Developer",
                            "Hi, I’m Atharv from ICE and proudly i can say ICE is not so cool,"
                        ),
                      ]
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 25, left: 25, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card("assets/images/Team/diya.png",
                          "Diya",
                          "Resource Manager",
                          "Meet Diya Gautam, an ITNS student (Batch of 2029) at NSUT. A confident speaker with endless energy. she channels her creativity into reading, writing, dancing and sports.",
                        ),
                        SizedBox(width: 10,),
                        Card("assets/images/Team/vidita.png",
                          "Vidita",
                          "Resource Manager",
                          "Hey, I'm Vidita! CSAI student, my life currently revolves around code, coffee, dance and convincing myself I'll finish all 14 side projects someday. Always up for learning, building cool things, and meeting new people!",
                        ),
                      ]
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 25, left: 25, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card("assets/images/Team/ishit.png",
                          "Ishit Ninawat",
                          "Content Writter",
                          "Ishit Ninawat is a student from Mathematics and Computing, batch of 2029. His main focus lies in software development, and as his side activities, carries out writing, public speaking, debating and photography. ",
                        ),
                        SizedBox(width: 10,),
                        Card("assets/images/Team/Ekansh.png",
                          "Ekansh",
                          "Content writter",
                          "Ekansh Miglani is a student of Instrumentation and Control Engineering, batch of 2029, at NSUT. His interests include technology, finance, and writing. Outside academics, he enjoys playing sports and writing poetry."
                        ),
                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(23.0),
                  child: MainTxt(text: "gyan"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
