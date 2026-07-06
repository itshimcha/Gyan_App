import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/pages/Nakshatra/Nakshatra.dart';
import 'package:gyansutra/pages/USER/drawer.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/Subjects.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/pages/gyansutra/peer2peer.dart';
import 'package:http/http.dart'as http;

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
            color: const Color(0xff1b003f),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NakshatraMain()));
                },
                icon: Image.asset('assets/images/translogo2.png', height: 35, width: 35),
              ),
              Container(
                width: 1,
                height: 24,
                color: Colors.white.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Advicepage()));
                },
                icon: const Icon(Icons.people_alt_outlined, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
      drawer: CustomDrawer(),
      body:Stack(
        children: [
          Image.asset("assets/images/Wallpaper1.jpg",
            fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20,top: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: homenav(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: BackdropFilter(
                        filter:ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                        child: Center(
                          child: Container(
                            height: 500,
                            width: 340,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [Color(0xffffffff).withOpacity(0.5), Color(0xff000000).withOpacity(0.3)],
                                center: Alignment.topLeft,
                                radius: 1,
                              ),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/translogo2.png",fit: BoxFit.contain,width: 170,),
                                    SizedBox(height: 70,),
                                    Text("Select the Field From the Dropdown", style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 12,color: Colors.white),),
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
                                          disabledBackgroundColor: Colors.grey.withOpacity(0.2),
                                          disabledForegroundColor: Colors.white70,
                                        ), child: Text("Explore",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff1b003f)),))
                                  ],
                                )
                            ),
                          ),
                        )
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
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