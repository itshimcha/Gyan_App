import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/Varfile.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DayAstro extends StatefulWidget {
  final DateTime Date;
  const DayAstro({super.key, required this.Date});
  @override
  State<DayAstro> createState() => _DayAstroState();
}

class _DayAstroState extends State<DayAstro> {

  Future <List<Astro>> _fatchAllday() async{
    var response = await http.get(
      Uri.parse("${apiConfig.AstrodayEndpoint}${DateFormat('dd-MM-yyyy').format(widget.Date)}"),
      headers: apiConfig.headers,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((json) => Astro.fromJson(json)).toList();
    } else {
      print("SERVER ERROR BODY: ${response.body}");
      throw Exception('Failed to load user profile: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fatchAllday(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            heightFactor: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Failed to load data. Try again later.",
              style: TextStyle(color: Colors.red[300]),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              children: [
                Text("There Is No Event Today 🙁 If You Want TO Know More,\nJUST CHECKOUT OUR Social Media ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    )
                ),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final Uri url = Uri.parse(Varfile.instagram_url);
                          if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not open the article.')),
                            );
                          }
                        },
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color:Colors.white
                            ),
                            child: Image.asset("assets/images/instagram.png", width: 40,height: 40,)),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () async {
                          final Uri url = Uri.parse(Varfile.medium_url);
                          if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not open the article.')),
                            );
                          }
                        },
                        child: Image.asset("assets/images/medium.png", width: 40,height: 40,),
                      ),
                    ]
                ),
              ],
            )
          );
        }
        final events = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("No. Events as on Date ${DateFormat('dd MMMM yyyy').format(widget.Date).toString()} : ${events.length}", style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            )),
            SizedBox(height: 20,),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                for (var event in events)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) {
                                return const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.black,
                                    Colors.black,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.4, 0.8],
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.network(
                                event.image,
                                fit: BoxFit.cover,

                                alignment: Alignment.center,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.8,1],
                                  colors: [
                                    Colors.transparent,
                                    Colors.black,
                                  ],
                                )
                              )
                            ),
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Image.asset(
                                "assets/images/translogo2.png",
                                height: 40,
                                width: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              left: 20,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    event.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    event.short_description,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      height: 0.7,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Start Date: ${DateFormat('dd MMMM yyyy').format(event.start_date).toString()}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (event.end_date != event.start_date) ...[
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "End Date: ${DateFormat('dd MMMM yyyy').format(event.end_date).toString().substring(0, 10)}",
                                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14,fontWeight: FontWeight.w500,),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (event.time_text.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(Icons.access_time, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    event.time_text,
                                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14,fontWeight: FontWeight.w500,),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (event.location.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      event.location,
                                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14,fontWeight: FontWeight.w500,),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (event.visibility_info.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(Icons.visibility, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      event.visibility_info,
                                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14,fontWeight: FontWeight.w500,),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (event.day_names_short.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(Icons.update, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Repeated Day: ${event.day_names_short.replaceAll('[', '').replaceAll(']', '')}",
                                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14,fontWeight: FontWeight.w500,),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                            Text(
                              "About this Event",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.detailed_description.isNotEmpty
                                  ? event.detailed_description
                                  : "JUST USE GOOGLE SOMETIME BRO",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ]
              )
            ),
            SizedBox(height: 40,),
          ],
        );
      },
    );
  }
}
