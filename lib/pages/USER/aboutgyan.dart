import 'package:flutter/material.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/com_wid.dart';

class Aboutgyan extends StatefulWidget {
  const Aboutgyan({super.key});

  @override
  State<Aboutgyan> createState() => _AboutgyanState();
}

class _AboutgyanState extends State<Aboutgyan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
              opacity: 0.5,
              child: Image.asset("assets/images/profilebg.jpg",fit: BoxFit.cover,width: double.infinity,height: double.infinity,)
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0,1]
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40,),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xffe6e6fa),
                      size: 20,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Center(
                    child: Text(StaticData.Gyan["title"]!,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.gloock(
                          color: Color(0xffe6e6fa),
                          fontWeight: FontWeight.w700,
                          fontSize: 35),),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(StaticData.Gyan["paragraph_1"]!,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                            color: Color(0x88e6e6fa),
                            fontWeight: FontWeight.w500,
                            fontSize: 10),),
                    ),
                  ),
                  SizedBox(height:2,),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                              child: Text.rich(
                                  textAlign: TextAlign.justify,
                                  TextSpan(
                                      children: [
                                        TextSpan(text: StaticData.Gyan["paragraph_5"]!, style: GoogleFonts.poppins(
                                          color: Color(0xeee6e6fa),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,)),
                                        TextSpan(text: StaticData.Gyan["paragraph_2"]!, style: GoogleFonts.poppins(
                                          color: Color(0x88e6e6fa),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,))
                                      ]
                                  )
                              )


                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.asset("assets/images/Team/tarun.jpg",fit: BoxFit.cover,),
                                ),
                              ),
                              Text(StaticData.Gyan["founder1"]!, style:
                              GoogleFonts.poppins(
                                color: Color(0xeee6e6fa),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,)
                              ),
                              SizedBox(height: 20,),
                              Container(
                                width: 120,
                                height: 120,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.asset("assets/images/Team/ashu.jpg",fit: BoxFit.cover,),
                                ),
                              ),
                              Text(StaticData.Gyan["founder2"]!, style:
                              GoogleFonts.poppins(
                                color: Color(0xeee6e6fa),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,)
                              ),
                              SizedBox(height: 20,),
                            ],
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                        child: Text
                          (StaticData.Gyan["paragraph_4"]!,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.poppins(
                              color: Color(0x88e6e6fa),
                              fontWeight: FontWeight.w500,
                              fontSize: 10,))
                    ),
                  ),
                  MainTxt(text: "Gyansutra"),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
