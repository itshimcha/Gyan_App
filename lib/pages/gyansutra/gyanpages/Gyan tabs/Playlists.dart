import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/Gyan%20tabs/play.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart' show launchUrl, LaunchMode;

class Playlists extends StatefulWidget {
  final int cat_id;
  const Playlists({super.key, required this.cat_id});
  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  late Future<List<Playlist>> _playlistFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _playlistFuture = getlist();
  }

  Future <List<Playlist>> getlist() async{
    final String url = "${apiConfig.baseURl}/api/study-materials/categories/${widget.cat_id}/files/";
    final response = await http.get(
        Uri.parse(url),
        headers: apiConfig.headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Playlist> playlist = data.map((item) => Playlist.fromJson(item)).toList();
      return playlist;
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
          FutureBuilder(
              future: _playlistFuture,
              builder: (context,snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Playlist found.", style: TextStyle(color: Colors.white)));
                }
                final playlists = snapshot.data!;
                print(playlists);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var playlist in playlists)
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YoutubePlaylistWebView(playlistUrl: playlist.url),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8,bottom: 10,left: 10,right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 12,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [Image.network(playlist.thumbnail_url,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => ColoredBox(color: Colors.grey),),
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black87,
                                                  Colors.black45,
                                                  Colors.transparent,
                                                ],
                                                stops: [0.0, 0.4, 1.0],
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            playlist.name,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.poppins(
                                                              color: Colors.white,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              height: 1.2,
                                                              letterSpacing: 0.5,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 8),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),

                                                    Container(
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white.withOpacity(0.2),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.white.withOpacity(0.4),
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.play_arrow_rounded,
                                                        color: Colors.white,
                                                        size: 32,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]
                        )
                    ],
                  ),
                );
              }
          ),
          SizedBox(height: 20,),
          MainTxt(text: "Gyansutra")
        ],
      ),
    );
  }
}