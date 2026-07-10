import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/Category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:lottie/lottie.dart';


class SubjectsPage extends StatefulWidget {
  final String branchCode;
  final int semesterNumber;

  const SubjectsPage({super.key, required this.branchCode, required this.semesterNumber,});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  List<int> random =[];
  late Future<List<Subjects>> _subjectsFuture;
  @override
  void initState() {
    super.initState();
    _subjectsFuture = getSubjects();
    for (int i =0; i<10; i++){
      random.add(randomgen(1,7));
    }
  }

  Future<List<Subjects>> getSubjects() async {
    final String url = "${apiConfig.baseURl}/api/study-materials/subjects/?branch_code=${widget.branchCode}&semester=${widget.semesterNumber}";
    final response = await http.get(
        Uri.parse(url),
        headers: apiConfig.headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['subjects'] as List).map((item) => Subjects.fromJson(item)).toList();
    }else{
      print("SERVER ERROR BODY: ${response.body}");
      throw Exception('Failed to load subjects');
    }
  }

  @override
  Widget build(BuildContext context) {
    final getsubject = getSubjects();
    return Scaffold(
      body: 
      Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: Image.asset("assets/images/Subjectsbg.jpg",
              fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40,),
                              IconButton(
                                  onPressed:(){
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xffe6e6fa),size: 20,)
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text("Subjects",
                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize:35,color: const Color(0xffe6e6fa)))
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: [
                                          const SizedBox(width:5,),
                                          Text(widget.branchCode , style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 13,color: const Color(0xffe6e6fa)),),
                                          const SizedBox(width: 5,),
                                          const Icon(Icons.keyboard_double_arrow_right, color: Color(0xffe6e6fa),size: 18,),
                                          const SizedBox(width: 5,),
                                          Text("Sem ${widget.semesterNumber}", style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 13,color: const Color(0xffe6e6fa)),),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: Lottie.asset("assets/lottie/SpaceTour.json", width: 170, height: 170,animate: true,repeat: true, reverse: true))
                      ],
                    ),
                    const SizedBox(height: 30,),
                    FutureBuilder<List<Subjects>>(
                      future: _subjectsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return earthrotate();
                        }
                        else if (snapshot.hasError) {
                          return Center(child: No_internet());
                        }
                        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No subjects found.", style: const TextStyle(color: Colors.white)));
                        }
                        final subjectList = snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 0),
                              itemCount: subjectList.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 15,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  childAspectRatio: 1.1
                              ),
                              itemBuilder: (context, index) {
                                final subject = subjectList[index];
                                return GestureDetector(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Category(sub_id: subject.id,branchCode: widget.branchCode,semesterNumber: widget.semesterNumber,subjectName: subject.name,)));
                                    },
                                    child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(18),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xffe6e6fa).withOpacity(0.1),
                                                blurStyle: BlurStyle.outer,
                                                spreadRadius: 2,
                                                blurRadius: 20,
                                              )
                                            ],
                                            border: Border.all(color: const Color(0xffc29242), width: 3),
                                            image: DecorationImage(
                                                image: AssetImage("assets/images/folder/${random[index]}.jpg"), fit: BoxFit.cover
                                            )
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(colors: [
                                                    Colors.black,
                                                    Colors.transparent,
                                                  ],
                                                      stops: [0.0, 1.0],
                                                      begin: Alignment.bottomCenter,
                                                      end: Alignment.topCenter
                                                  ),
                                                ),),
                                              const Positioned(
                                                  top: 10,
                                                  left: -19,
                                                  child: Icon(Icons.folder_rounded, color: Color(0xffc29242),size: 216)),
                                              const Positioned(
                                                  bottom: 60,
                                                  right: 10,
                                                  child: Icon(Icons.more_horiz,color: Colors.black,size: 30)),
                                              Positioned(
                                                  left: 10,
                                                  bottom: 15,
                                                  right: 10,
                                                  child: Text(
                                                    subject.name ,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: GoogleFonts.poppins(
                                                        height: 1,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 15,
                                                        color: Colors.black
                                                    ),
                                                  )
                                              ),
                                              Positioned(
                                                  left:-16,
                                                  bottom: -35,
                                                  child: Text(
                                                    '${index + 1}' , style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 170,
                                                      height: 0.8,
                                                      color: Colors.black12
                                                  ),
                                                  )
                                              )
                                            ],
                                          ),
                                        )
                                    )
                                );
                              }
                          ),
                        );
                      },
                    ),
                    MainTxt(text: "gyansutra")
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
