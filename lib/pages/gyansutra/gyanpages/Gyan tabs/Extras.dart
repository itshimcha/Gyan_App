import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Extras extends StatefulWidget {
  final int cat_id;
  final int cat_id2;
  final int cat_id3;

  const Extras({
    super.key,
    required this.cat_id,
    this.cat_id2 = 0,
    this.cat_id3 = 0,
  });

  @override
  State<Extras> createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  late Future<List<Files>> _booksFuture;
  late Future<List<Files>> _practicalFuture;
  late Future<List<Files>> _pmFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchFiles(widget.cat_id);
    _practicalFuture = fetchFiles(widget.cat_id2);
    _pmFuture = fetchFiles(widget.cat_id3);
  }

  Future<List<Files>> fetchFiles(int categoryId) async {
    final String url = "${apiConfig.baseURl}/api/study-materials/categories/$categoryId/files/";
    final response = await http.get(Uri.parse(url), headers: apiConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Files.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data for category $categoryId');
    }
  }

  Widget _buildSection(String title, Future<List<Files>> future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                title,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)
            ),
            SizedBox(width: 10,),
            Expanded(child: Divider(height: 2,color: Colors.white54,))
          ],
        ),
        FutureBuilder<List<Files>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return earthrotate();
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Not found.", style: GoogleFonts.poppins(color: Colors.white54, fontStyle: FontStyle.italic)));
            }
            final ExtraList = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.only(top: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ExtraList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final notes = ExtraList[index];
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
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildSection("Books", _booksFuture),
        _buildSection("Practicals", _practicalFuture),
        _buildSection("PM", _pmFuture),
        MainTxt(text: "Gyansutra")
      ],
    );
  }
}