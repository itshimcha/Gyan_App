import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' show Lottie;

class Announce extends StatefulWidget {
  const Announce({super.key});

  @override
  State<Announce> createState() => _AnnounceState();
}

class _AnnounceState extends State<Announce> {
  Future<List<Announcement>>? _announcements;

  @override
  void initState() {
    super.initState();
    _announcements = getAnnouncement();
  }

  Future<List<Announcement>> getAnnouncement() async {
    final response = await http.get(
        Uri.parse(apiConfig.AnnouncementEndpoint),
        headers: apiConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Announcement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
              opacity: 0.4,child: StarBg()),
          Padding(
            padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10,top: 40),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false);
                            },
                            child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle
                                ),
                                child: Center(child: Icon(Icons.home,color: Colors.white,))),
                          )
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Announcement", style:
                            GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                color: Color(0xffe6e6fa)
                            ),),
                            Text("Stay Updated with latest events",
                                style:
                                GoogleFonts.poppins(
                                    height: 0.7,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0x88e6e6fa)))
                          ],
                        ),
                      )
                    ],),
                  ),
                  SizedBox(height: 20,),
                  SingleChildScrollView(
                    child: Positioned.fill(
                      child: FutureBuilder<List<Announcement>>(
                        future: _announcements,
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator());
                          } else if(snapshot.hasError){
                            return Center(child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty){
                            return Center(child: Text("No Announcements"));
                          }
                          final ann = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            itemCount: ann.length,
                            itemBuilder: (context, index) {
                              final item = ann[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white12,
                                  collapsedBackgroundColor: Colors.transparent,
                                  minTileHeight: 60,
                                  title: Text(
                                    item.title,
                                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        item.details,
                                        style:  GoogleFonts.poppins(color: Colors.white70,fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  MainTxt(text: "nkt")
                ],
              ),
            ),
          )
          // Lottie.asset("assets/lottie/SpaceCat.json",
          //     fit: BoxFit.cover,width: double.infinity, height: double.infinity, repeat: false),

        ],
      )
    );
  }
}
