import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/pages/USER/drawer.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/Gyan%20tabs/Extras.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/Gyan%20tabs/Notes.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/Gyan%20tabs/PYQs.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/Gyan%20tabs/Playlists.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' show Lottie;
import 'dart:convert';

import 'Gyan tabs/syallbus.dart' show Syallbus;

class Category extends StatefulWidget {
  final int sub_id;
  final String branchCode;
  final int semesterNumber;
  final String subjectName;
  const Category({super.key, required this.sub_id, required this.branchCode, required this.semesterNumber, required this.subjectName});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  late Future<List<Categories>> _categoryFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryFuture = getCategory();
  }

  Future<List<Categories>> getCategory() async {
    final String url = "${apiConfig.baseURl}/api/study-materials/subjects/${widget.sub_id}/categories/";
    final response = await http.get(
      Uri.parse(url),
      headers: apiConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Categories> categories = data.map((item)   => Categories.fromJson(item)).toList();
      return categories;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = getCategory();
    return Scaffold(
        drawer: CustomDrawer(),
      body: FutureBuilder<List<Categories>>(
          future: _categoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return earthrotate();
            }
            else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot
                  .error}",
                  style: const TextStyle(color: Colors.white)));
            }
            else
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text(
                  "No data found.",
                  style: TextStyle(color: Colors.white)));
            }
            final CategoryList = snapshot.data!;
            var notesCategory = CategoryList.where((item) => item.category_type == 'notes').firstOrNull;
            var PYQsCategory = CategoryList.where((item) => item.category_type == 'pyqs').firstOrNull;
            var booksCategory = CategoryList.where((item) => item.category_type == 'books').firstOrNull;
            var PMCategory = CategoryList.where((item) => item.category_type == 'practice material').firstOrNull;
            var syllabusCategory = CategoryList.where((item) => item.category_type == 'syllabus').firstOrNull;
            var PracticalCategory = CategoryList.where((item) => item.category_type == 'practical').firstOrNull;
            var PlaylistCategory = CategoryList.where((item) => item.category_type == 'Playlists').firstOrNull;
            return Stack(
                children: [
                  Image.asset("assets/images/categorybg.jpg",
                    fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
                  Container(
                    height:500,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.transparent
                            ],
                            stops: [0,1],
                            begin: AlignmentGeometry.topCenter,
                            end: AlignmentGeometry.bottomCenter
                        )
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height:500,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.transparent
                              ],
                              stops: [0,1],
                              begin: AlignmentGeometry.bottomCenter,
                              end: AlignmentGeometry.topCenter
                          )
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40,),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 25,)),
                          Row(
                            mainAxisAlignment:MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text("Explore",
                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 40,color: Color(0xffe6e6fa))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: SizedBox(height: 10,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          children: [
                                            SizedBox(width:5,),
                                            Text(widget.branchCode , style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xffe6e6fa)),),
                                            SizedBox(width: 5,),
                                            Icon(Icons.keyboard_double_arrow_right, color: Color(0xffe6e6fa),size: 18,),
                                            SizedBox(width: 5,),
                                            Text("Sem " + widget.semesterNumber.toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xffe6e6fa)),),
                                            SizedBox(width: 5,),
                                            Icon(Icons.keyboard_double_arrow_right, color: Color(0xffe6e6fa),size: 18,),
                                            SizedBox(width: 5,),
                                            Expanded(
                                              child: Text(widget.subjectName,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xffe6e6fa)),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(95),
                                    color: Colors.white12,),
                                  child: Lottie.asset("assets/lottie/Astronaut&.json", ))
                            ],
                          ),
                          SizedBox(height: 20,),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: 400,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(45),
                                    color: Color(0xffe6e6fa),
                                  ),
                                ),
                                DefaultTabController(
                                    length: 4,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[
                                          TabBar(
                                            dividerColor: Colors.transparent,
                                            overlayColor: WidgetStateProperty.all(Colors.transparent),
                                            indicatorSize: TabBarIndicatorSize.tab,
                                            indicatorPadding: const EdgeInsets.all(4),
                                            indicator: BoxDecoration(
                                              border: Border.all(color: Colors.black26, width: 1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black38,
                                                  blurRadius: 4,

                                                ),
                                              ],
                                            ),
                                            labelColor: const Color(0xFF013650),
                                            unselectedLabelColor: const Color(0xFF678D9B),
                                            labelStyle: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                            unselectedLabelStyle: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                            tabs: [
                                              Tab(text: "Notes",),
                                              Tab(text: "PYQs",),
                                              Tab(text: "Playlist",),
                                              Tab(text: "Extras",)
                                            ],
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              children: [
                                                Notes(cat_id: notesCategory?.id ?? -1,),
                                                PYQs(cat_id: PYQsCategory?.id ?? -1,),
                                                Playlists(cat_id: PlaylistCategory?.id ?? -1,),
                                                Extras(
                                                    cat_id: booksCategory?.id ?? -1,
                                                    cat_id2: PracticalCategory?.id ?? -1,
                                                    cat_id3: PMCategory?.id ?? -1
                                                ),
                                              ],
                                            ),)
                                          ,
                                        ]
                                    )
                                )
                              ],
                            ),
                          )
                        ]
                    ),
                  ),
                  Syallbus(cat_id: syllabusCategory?.id ?? -1,)
                ]
            );
          }
      )
    );
  }
}










