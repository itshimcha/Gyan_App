import 'package:flutter/material.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:gyansutra/pages/USER/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'package:google_nav_bar/google_nav_bar.dart';



class Cosmicfeed extends StatefulWidget {
  const Cosmicfeed({super.key});

  @override
  State<Cosmicfeed> createState() => _CosmicfeedState();
}

class _CosmicfeedState extends State<Cosmicfeed> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Color(0x770d0552),
                    Color(0x882c9ee5)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter
                )
              )
            ),
            Opacity(
              opacity: 0.6,
                child: StarBg()),
            DefaultTabController(
                length: 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      SizedBox(height: 50,),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: GestureDetector(
                                      onTap: (){
                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false);
                                      },
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle
                                          ),
                                          child: Center(child: Icon(Icons.home,color: Colors.white,))))
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(left: 27.0),
                                child: Text("Galaxify", style: GoogleFonts.alegreya(fontSize: 50, height: 1,fontWeight: FontWeight.w600,color: Colors.white),),
                              ),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Expanded(
                            child: Container(
                              height: 130,
                              child:
                              Lottie.asset("assets/lottie/Nice.json"),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child:
                        TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          physics: BouncingScrollPhysics(),
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey.withOpacity(0.7),
                          indicatorColor: Color(0xffe6e6fa),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.only(left: 20, right: 20) ,
                          tabs: [
                            Tab(text: "News For You",),
                            Tab(text: "On Air",)
                          ],
                        ),


                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            NewsForYou(),
                            OnAir(),
                          ],
                        ),)
                      ,
                    ]
                )
            ),


          ]
        )
      )
    ;
  }
}

class NewsForYou extends StatefulWidget {
  const NewsForYou({super.key});

  @override
  State<NewsForYou> createState() => _NewsForYouState();
}

class _NewsForYouState extends State<NewsForYou> {
  late final Future<CosmicFeednews> _futureArticles = fetchCosmicFeednews();

  Future <CosmicFeednews> fetchCosmicFeednews() async {
    final response = await http.get(
        Uri.parse(apiConfig.CosmicFeednewsEndpoint),
        headers: apiConfig.headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> featuredData = data['featured'];
      final List<dynamic> topStoriesData = data['top_stories'];
      final List<dynamic> newsTodayData = data['news_today'];
      List<Article> featured = featuredData.map((item) => Article.fromJson(item)).toList();
      List<Article> topStories = topStoriesData.map((item) => Article.fromJson(item)).toList();
      List<Article> newsToday = newsTodayData.map((item) => Article.fromJson(item)).toList();
      return CosmicFeednews(
        featured: featured,
        topStories: topStories,
        newsToday: newsToday,
      );
    }else{
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CosmicFeednews>(
      future: _futureArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return earthrotate();
        }
        else if (snapshot.hasError) {
          return No_internet();
        }
        else if (!snapshot.hasData) {
          return const Center(child: Text('No news available right now.'));
        }

        final CosmicFeednews FeedData = snapshot.data!;
        final List<Article> featured = FeedData.featured;
        final List<Article> topStories = FeedData.topStories;
        final List<Article> newsToday = FeedData.newsToday;

        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayAnimationDuration: Duration(seconds: 2),
                  autoPlayInterval: Duration(seconds: 7),
                  viewportFraction: 0.8,
                  enlargeFactor: 0.3,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  scrollPhysics: BouncingScrollPhysics()
                ),
                items: featured.map((article) {
                  return Builder(
                    builder: (BuildContext context) {
                      return
                        Container(
                            width: 315,
                            height: 300,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                final Uri url = Uri.parse(article.url);
                                if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                                  CustomSnackbar.show(context, "Could not open the article");
                                }
                              },
                              child: Stack(
                                  children:[
                                    Positioned.fill(
                                        child: Image.network(
                                          article.image_url,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => const Center(
                                            child: Icon(Icons.broken_image, color: Colors.white54),
                                          ),
                                        ),
                                      ),
                                    Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Colors.black,
                                              Colors.transparent,
                                            ],
                                                stops: [0.2, 1.0],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter
                                            )

                                        )
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient:
                                        RadialGradient(colors: [
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                            radius: 1,
                                            center: Alignment.topRight),
                                      ),

                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient:
                                        RadialGradient(colors: [
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                            radius: 1,
                                            center: Alignment.topLeft),
                                      ),

                                    ),
                                    Positioned(
                                        bottom: 50,
                                        left: 20,
                                        right: 80,
                                        child: Text(article.title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.jost(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500,))),
                                    Positioned(
                                        bottom: 20,
                                        left: 20,
                                        right: 20,
                                        child: Text(article.summary,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 10, fontWeight: FontWeight.w400,))),
                                    Positioned(
                                        top: 20,
                                        left: 20,

                                        child: Text(article.authors,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.jost(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900,))),
                                    Positioned(
                                        top: 15,
                                        right: 15,
                                        child: Icon(Icons.arrow_circle_right, color: Colors.white.withOpacity(0.7),size: 23))
                                  ]
                              ),
                            )
                        )

                      ;
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text("Top Stories", style: GoogleFonts.jost(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.white),),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: topStories.length,
                  itemBuilder: (context, index) {
                    final topstory = topStories[index];
                    return Container(
                      width:155,
                      height: 220,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black,
                      ),
                      margin: const EdgeInsets.all(8),
                      child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(topstory.url);
                            if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                              CustomSnackbar.show(context, "Could not open the article");;
                            }
                          },
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(topStories[index].image_url,
                                fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.broken_image, color: Colors.white),)
                              )
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.black,

                                      Colors.transparent,
                                    ],
                                        stops: [0.0, 1.0],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter
                                    )

                                )
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient:
                                RadialGradient(colors: [
                                  Colors.black,
                                  Colors.transparent
                                ],
                                    radius: 2,
                                    center: Alignment.bottomLeft),

                              ),

                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient:
                                RadialGradient(colors: [
                                  Colors.black,
                                  Colors.transparent
                                ],
                                    radius: 0.7,
                                    center: Alignment.topRight),

                              ),

                            ),
                            Positioned(
                              left: 10,
                              right: 30,
                              bottom: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(topStories[index].authors,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: GoogleFonts.jost(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800,)),
                                  SizedBox(height: 8),
                                  Text(topStories[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: GoogleFonts.jost(color: Colors.white, height: 1.2 ,fontSize: 13, fontWeight: FontWeight.w500,)),

                                ],
                              ),
                            ),
                            Positioned(
                                top: 10,
                                right: 10,
                                child: Icon(Icons.arrow_circle_right, color: Colors.white.withOpacity(0.7),size: 20))

                          ]

                        )
                      )

                    );

                  }
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text("News Today", style: GoogleFonts.jost(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.white),),
              ),
              SizedBox(height: 10),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: newsToday.length,
                  itemBuilder: (context, index) {
                    final newstoday = newsToday[index];
                    return Container(
                        width:400,
                        height: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        margin: const EdgeInsets.only(left: 8,right: 8,bottom:5, top: 5),
                        child: GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(newstoday.url);
                              if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                                CustomSnackbar.show(context, "Could not open the article");
                              }
                            },
                            child: Stack(
                                children: [
                                  Container(
                                    width:400,
                                    height: 120,
                                    child: Image.network(
                                      alignment: Alignment.topCenter,
                                      newstoday.image_url,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Center(
                                        child: Icon(Icons.broken_image, color: Colors.white54),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Colors.black,
                                            Colors.transparent,
                                          ],
                                              stops: [0.0, 1.0],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter
                                          )

                                      )
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient:
                                      RadialGradient(colors: [
                                        Colors.black,
                                        Colors.transparent
                                      ],
                                          radius: 2,
                                          center: Alignment.topLeft),

                                    ),

                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient:
                                      RadialGradient(colors: [
                                        Colors.black,
                                        Colors.transparent
                                      ],
                                          radius: 0.7,
                                          center: Alignment.topRight),

                                    ),

                                  ),
                                  Positioned(
                                    left: 15,
                                    right: 70,
                                    bottom: 15,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(newsToday[index].title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,

                                            style: GoogleFonts.jost(
                                              color: Colors.white, height: 1.2 ,fontSize: 13, fontWeight: FontWeight.w800,)
                                        ),
                                        SizedBox(height: 2),
                                        Text(newsToday[index].summary,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.jost(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500,)),

                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 15,
                                      right: 15,
                                      left: 15,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(newsToday[index].authors,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: GoogleFonts.jost(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800,)),
                                          Icon(
                                          Icons.arrow_circle_right, color: Colors.white.withOpacity(0.7),size: 20)
                                        ]
                                      )
                                  )
                                ]

                            )
                        )

                    );

                  }
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: MainTxt(text: "Nakshatra")
              ),
            ],
          ),
        );
      },
    );
  }
}

class OnAir extends StatefulWidget {
  const OnAir({super.key});

  @override
  State<OnAir> createState() => _OnAirState();
}

class _OnAirState extends State<OnAir> {
  late Future<List<CosmicFeedOnAir>> futureEvents= fetchCosmicFeedOnAir();
  Future<List<CosmicFeedOnAir>> fetchCosmicFeedOnAir() async {
    final response = await http.get(
        Uri.parse(apiConfig.CosmicFeedOnAirEndpoint),
        headers: apiConfig.headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> onairData = data['events'] ?? [];
      List<CosmicFeedOnAir> onair = onairData.map((item) => CosmicFeedOnAir.fromJson(item)).toList();
      return onair;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget _buildPremiumTag({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFE6E6FA).withOpacity(0.7),
            size: 13,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.jost(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.85),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CosmicFeedOnAir>>(
      future: futureEvents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return earthrotate();
        }
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
        }
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No events on air right now.', style: TextStyle(color: Colors.white)));
        }

        else {
          final List<CosmicFeedOnAir> events = snapshot.data!;
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  itemCount: events.length,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(event.video_url);
                            if(!await launchUrl(url, mode: LaunchMode.inAppWebView)){
                              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                CustomSnackbar.show(context, "Could not open the article");
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  right: -10,
                                  top: -10,
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white12
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.92,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          width: 1.2,
                                          color: Colors.white.withOpacity(0.12),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.07),
                                            const Color(0xFF004984).withOpacity(0.05),
                                            Colors.black.withOpacity(0.2),
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    event.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.jost(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white.withOpacity(0.08),
                                                    border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                                                  ),
                                                  child: Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: Colors.white.withOpacity(0.9),
                                                    size: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: Text(
                                                event.description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.jost(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.4,
                                                  color: Colors.white.withOpacity(0.6),
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 14),

                                            // BOTTOM ROW: Clean Pill Tags
                                            Row(
                                              children: [
                                                _buildPremiumTag(
                                                  icon: Icons.calendar_today_rounded,
                                                  text: event.date.length == 8
                                                      ? "${event.date.substring(6, 8)}/${event.date.substring(4, 6)}/${event.date.substring(0, 4)}"
                                                      : event.date,
                                                ),
                                                const SizedBox(width: 10),
                                                _buildPremiumTag(
                                                  icon: Icons.schedule_rounded,
                                                  text: event.time,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    );
                  },
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: MainTxt(text: "Nakshatra")
                ),
              ],
            )
          );
        }
      }
    );
  }
}