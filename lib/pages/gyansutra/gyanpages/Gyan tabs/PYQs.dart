import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class PYQs extends StatefulWidget {
  final int cat_id;
  const PYQs({super.key, required this.cat_id});
  @override
  State<PYQs> createState() => _PYQsState();
}

class _PYQsState extends State<PYQs> {
  late Future<List<Files>> _pyqsFuture;

  @override
  void initState() {
    super.initState();
    _pyqsFuture = getPYQs();
  }

  Future<List<Files>> getPYQs() async {
    final String url = "${apiConfig.baseURl}/api/study-materials/categories/${widget.cat_id}/files/";
    final response = await http.get(
        Uri.parse(url),
        headers: apiConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Files> pyqs = data.map((item) => Files.fromJson(item)).toList();
      return pyqs;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<List<Files>>(
              future: _pyqsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }
                else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
                }
                else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data found.", style: TextStyle(color: Colors.white)));
                }
                final pyqsList = snapshot.data!;
                final eseList = pyqsList.where((file) => file.name.contains("ESE")).toList();
                final mseList = pyqsList.where((file) => file.name.contains("MSE")).toList();
                return ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        Text("MSE PYQs", style: GoogleFonts.poppins(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w600)),
                        SizedBox(width: 10,),
                        Expanded(child: Divider(height: 2,color: Colors.white54,))
                      ],
                    ),
                    SizedBox(height: 10,),
                    mseList.isEmpty ? Center(child:
                    Text("No MSE files found",
                        style: GoogleFonts.poppins(fontStyle: FontStyle.italic,color: Colors.white54, fontSize: 10))
                    ) :
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: mseList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final notes = mseList[index];
                        return GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(notes.web_view_link);
                              if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not open the article.')),
                                );
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
                                          child: IconButton(onPressed:() async {
                                            final Uri url = Uri.parse(notes.download_link);
                                            if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Could not open the article.')),
                                              );
                                            }
                                            }, icon: Icon(Icons.more_horiz,color: Colors.black,size: 30)),),
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
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text("ESE PYQs", style: GoogleFonts.poppins(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w600)),
                        SizedBox(width: 10,),
                        Expanded(child: Divider(height: 2,color: Colors.white54,))
                      ],
                    ),
                    SizedBox(height: 10,),
                    eseList.isEmpty ? Center(child:
                    Text("No ESE files found",
                        style: GoogleFonts.poppins(fontStyle: FontStyle.italic,color: Colors.white54, fontSize: 10)),) :
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: eseList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final notes = eseList[index];
                        return GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(notes.web_view_link);
                              if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not open the article.')),
                                );
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
                      },
                    ),


                  ],
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