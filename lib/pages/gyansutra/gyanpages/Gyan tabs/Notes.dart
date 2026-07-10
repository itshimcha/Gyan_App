import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class Notes extends StatefulWidget {
  final int cat_id;
  const Notes({super.key, required this.cat_id});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  late Future<List<Files>> _notesFuture;

    @override
    void initState() {
      super.initState();
      _notesFuture = getNotes();
    }

  Future<List<Files>> getNotes() async {
    final String url = "${apiConfig.baseURl}/api/study-materials/categories/${widget.cat_id}/files/";
    final response = await http.get(
        Uri.parse(url),
        headers: apiConfig.headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Files> notes = data.map((item) => Files.fromJson(item)).toList();
      return notes;
    } else {
      throw Exception('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),
          FutureBuilder<List<Files>>(
            future: _notesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return earthrotate();
              }
              else if (snapshot.hasError) {
                return Center(child: No_internet());
              }
              else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No notes for this subject", style: TextStyle(color: Colors.white)));
              }
              final notesList = snapshot.data!;

              return GridView.builder(
                padding: EdgeInsets.only(left: 10,right: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notesList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.1
                  ),
                  itemBuilder: (context, index) {
                    final notes = notesList[index];
                    return GestureDetector(
                        onTap: () async {
                          final Uri url = Uri.parse(notes.web_view_link);
                          if(!await launchUrl(url, mode: LaunchMode.externalApplication)){
                            if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not open the video.')),
                              );
                            }
                          }
                        },
                        child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffe6e6fa).withOpacity(0.1),
                                    blurStyle: BlurStyle.outer,
                                    spreadRadius: 2,
                                    blurRadius: 20,

                                  )
                                ],
                                border: Border.all(color: Color(0xffc29242), width: 3),

                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.black,
                                        Colors.transparent,
                                      ],
                                          stops: [0.0, 1.0],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter
                                      ),
                                    ),),
                                  Positioned(
                                      top: 10,
                                      left: -19,
                                      child: Icon(Icons.folder_rounded, color: Color(0xffc29242),size: 216)),
                                  Positioned(
                                      bottom: 60,
                                      right: 10,
                                      child: Icon(Icons.more_horiz,color: Colors.black,size: 30)),
                                  Positioned(
                                      left: 10,
                                      bottom: 15,
                                      right: 10,
                                      child: Text(
                                        notes.name,
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
              );

            }
          ),
          MainTxt(text: "Gyansutra"),
          SizedBox(height: 50,),
        ],
      ),
    );
  }
}