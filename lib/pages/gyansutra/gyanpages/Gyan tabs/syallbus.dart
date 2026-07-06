import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Syallbus extends StatefulWidget {
  final int cat_id;
  const Syallbus({super.key, required this.cat_id});

  @override
  State<Syallbus> createState() => _SyallbusState();
}

class _SyallbusState extends State<Syallbus> {
  late Future<List<Files>> _syallbusFuture;

  @override
  void initState() {
    super.initState();
    _syallbusFuture = getsyallbus();
  }

  Future<List<Files>> getsyallbus() async {
    final String url = "${apiConfig.baseURl}/api/study-materials/categories/${widget.cat_id}/files/";
    final response = await http.get(
        Uri.parse(url),
        headers: apiConfig.headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Files> syallbus = data.map((item) => Files.fromJson(item)).toList();
      return syallbus;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Files>>(
        future: _syallbusFuture,
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
          final syallbus = snapshot.data!;
          return Positioned(
              bottom: 100,
              right: 30,
              child: GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(syallbus[0].web_view_link);
                  if(!await launchUrl(url, mode: LaunchMode.externalApplication)){
                    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open the video.')),
                      );
                    }
                  }
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0xffe6e6fa).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(45),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        spreadRadius: 2,
                      )
                    ],

                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf_outlined, color: Colors.black,size: 25,),
                        SizedBox(height: 2,),
                        Text("Syllabus", style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 10,color: Colors.black))
                      ]
                  ),
                ),
              ),

          );

        }
    );
  }
}
