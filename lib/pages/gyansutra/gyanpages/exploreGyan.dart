import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:gyansutra/pages/Nakshatra/Nakshatra.dart';
import 'package:gyansutra/pages/USER/drawer.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/Subjects.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/pages/gyansutra/peer2peer.dart';
import 'package:http/http.dart'as http;
import 'package:lottie/lottie.dart';

class Exploregyan extends StatefulWidget {
  const Exploregyan({super.key});

  @override
  State<Exploregyan> createState() => _ExploregyanState();
}

class _ExploregyanState extends State<Exploregyan> {
  int? selectedSem ;
  String? selectedBranch;

  Future<List<Subjects>> getSubjects(String branchCode, int semesterNumber) async {
    final String url = "${apiConfig.baseURl}/api/study-materials/subjects/?branch_code=$branchCode&semester=$semesterNumber";
    final response = await http.get(
        Uri.parse(url),
        headers: apiConfig.headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['subjects'] as List).map((item) => Subjects.fromJson(item)).toList()     ;
    }else{
      print("SERVER ERROR BODY: ${response.body}");
      throw Exception('Failed to load subjects');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors:[Color(0xffab8fef), Color(0xffc9d7e8)]
                  ,center: Alignment.topLeft,radius: 3),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NakshatraMain()));
                  },
                  icon: Image.asset('assets/images/translogo2bk.png', height: 35, width: 35),
                ),
                Container(
                  width: 2,
                  height: 30,
                  color: Colors.black.withOpacity(0.4),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Advicepage()));
                  },
                  icon: const Icon(Icons.people_alt_outlined, color: Colors.black, size: 24),
                ),
              ],
            ),
          ),
        ),
      body:Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset("assets/images/Wallpaper1.jpg",
              fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Align(
              alignment: AlignmentGeometry.topLeft,
              child: Padding(
              padding: const EdgeInsets.only(left: 20,top: 50),
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
                SizedBox(height: MediaQuery.of(context).size.height*0.03),
                Column(
                  children: [
                    Image.asset("assets/images/translogo2.png", width: 50, height: 50),
                    Text("Gyansutra".toUpperCase(), style: GoogleFonts.poppins(fontWeight: FontWeight.w700,letterSpacing: 3,fontSize: 35,color: Colors.white, height:0.9)),
                    Text("Your Best Study Guide", style: GoogleFonts.poppins(fontWeight: FontWeight.w500,letterSpacing: 2,fontSize: 13,color: Colors.white54)),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.025),
                Column(
                  children: [
                    Lottie.asset("assets/lottie/STUDENT.json", width: 250, height: 250),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: BackdropFilter(
                            filter:ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.only(left:10, right: 10, bottom: 15, top: 15),
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [Color(0xffffffff).withOpacity(0.5), Color(0xff000000).withOpacity(0.3)],
                                    center: Alignment.topLeft,
                                    radius: 1.5,
                                  ),
                                  border: Border.all(color: Colors.white.withOpacity(0.3),width: 2),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Select the Field From the Dropdown", style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.white70),),
                                        SizedBox(height: 15,),
                                        Container(
                                          width: 290,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Color(0xff1b003f),
                                            border: Border.all(color: Color(0xffBEB8CD)),
                                            borderRadius: BorderRadius.circular(40.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,right: 10),
                                                child: Icon(Icons.school_outlined, color: Color(0xffBEB8CD),size: 30,),
                                              ),
                                              Container(
                                                  width: 233,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    gradient: RadialGradient(
                                                        colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                                        ,center: Alignment.topLeft,radius: 3),
                                                    borderRadius: BorderRadius.circular(40.0),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4,left: 18,right: 6),
                                                    child:
                                                    DropdownButtonFormField(
                                                      menuMaxHeight: 300,
                                                      dropdownColor: Colors.grey.shade300,
                                                      style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400),
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                      ),
                                                      hint: Text("Select",
                                                        style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w400),
                                                      ),
                                                      value: selectedBranch,
                                                      items: Varfile.Branch_Name.map((branch) {
                                                        return DropdownMenuItem(
                                                          value: branch,
                                                          child: Text(branch),
                                                        );
                                                      }).toList(),
                                                      validator: (value) {
                                                        if(value == null){
                                                          return "Please select a campus";
                                                        }
                                                        return null;
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedBranch = value;
                                                        });
                                                      },
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          width: 290,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Color(0xff1b003f),
                                            border: Border.all(color: Color(0xffBEB8CD)),
                                            borderRadius: BorderRadius.circular(40.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,right: 10),
                                                child: Icon(Icons.layers_outlined, color: Color(0xffBEB8CD),size: 30,),
                                              ),
                                              Container(
                                                  width: 233,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    gradient: RadialGradient(
                                                        colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                                        ,center: Alignment.topLeft,radius: 3),
                                                    borderRadius: BorderRadius.circular(40.0),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4,left: 18,right: 6),
                                                    child:
                                                    DropdownButtonFormField(
                                                      menuMaxHeight: 300,
                                                      dropdownColor: Colors.grey.shade300,
                                                      style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400),
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                      ),
                                                      hint: Text("Select",
                                                        style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w400),
                                                      ),
                                                      value: selectedSem,
                                                      items: Varfile.AvSem.map((AvSem) {
                                                        return DropdownMenuItem(
                                                          value: AvSem,
                                                          child: Text(AvSem.toString()),
                                                        );
                                                      }).toList(),
                                                      validator: (value) {
                                                        if(value == null){
                                                          return "Please select a Semester";
                                                        }
                                                        return null;
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedSem = value;
                                                        });
                                                      },

                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        ElevatedButton(onPressed: (selectedBranch != null && selectedSem != null) ? () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectsPage(branchCode: selectedBranch!, semesterNumber: selectedSem!,),),);
                                        } : null,
                                            style: ElevatedButton.styleFrom(
                                              disabledBackgroundColor: Colors.white.withOpacity(0.6),
                                              disabledForegroundColor: Colors.white70,
                                            ), child: Text("Explore",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff1b003f)),))
                                      ],
                                    )
                                ),
                              ),
                            )
                        )
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: MainTxt(text: "gyansutra"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}