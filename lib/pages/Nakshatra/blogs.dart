import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/pages/USER/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../../extra/Responsive.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key});
  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  String selectedCategory = "ALL";
  late Future<List<fatchBlog>> _blog;

  @override
  void initState() {
    super.initState();
    _blog = _fetchBlog();
  }

  String url = apiConfig.FatchBlogs;

  Future <List<fatchBlog>> _fetchBlog() async {
    var response = await http.get(
      Uri.parse(url),
      headers: apiConfig.headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((json) => fatchBlog.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  void _updateFilter(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "ALL") {
        url = apiConfig.FatchBlogs;
      } else {
        url = "${apiConfig.FatchBlogs}?type=$category";
      }
      _blog = _fetchBlog();
    });
  }

  final Map<int, int> _assignedImages = {};
  List<int> _imagePool = [];
  int _lastUsedImage = -1;

  int _getImageForBlog(int cardIndex) {
    if (_assignedImages.containsKey(cardIndex)) {
      return _assignedImages[cardIndex]!;
    }

    if (_imagePool.isEmpty) {
      _imagePool = List.generate(10, (index) => index + 1);
      _imagePool.shuffle();

      if (_imagePool.first == _lastUsedImage) {
        int temp = _imagePool.first;
        _imagePool[0] = _imagePool.last;
        _imagePool[_imagePool.length - 1] = temp;
      }
    }

    int drawnImage = _imagePool.removeAt(0);
    _lastUsedImage = drawnImage;
    _assignedImages[cardIndex] = drawnImage;

    return drawnImage;
  }

  Widget TinderCard(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10,top: 50),
            child: Align(
              alignment: Alignment.topLeft,
              child: homenav(),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 23,right: 13),
            child: Text("Swipe Right to Explore",
                style:
                GoogleFonts.poppins(
                    height: 0.7,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0x88e6e6fa))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23,right: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nakshtra Blogs", style:
                GoogleFonts.poppins(
                    height: 0.5,
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Color(0xffe6e6fa)
                ),),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.tune, color: Color(0xffe6e6fa)),
                  initialValue: selectedCategory,
                  onSelected: (String value) {
                    _updateFilter(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(value: "ALL", child: Text("ALL")),
                      const PopupMenuItem(value: "ASTRO", child: Text("ASTRO")),
                      const PopupMenuItem(value: "MATH", child: Text("MATH")),
                    ];
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 770,
            child: FutureBuilder(
                future: _blog,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return earthrotate();
                  } if (snapshot.hasError) {
                    return Center(
                        child: No_internet());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No blogs found.",
                        style: TextStyle(color: Colors.red[300]),
                      ),
                    );}
                  final blogs = snapshot.data!;
                  return
                    CardSwiper(
                    allowedSwipeDirection: AllowedSwipeDirection.only(
                        up: false, down: false, left: true, right: true),
                    maxAngle: 0,
                    cardsCount: blogs.length,
                    padding: EdgeInsets.zero,
                    backCardOffset: Offset(0, 15),
                    numberOfCardsDisplayed: 3,
                    onSwipe: (previousIndex, currentIndex, direction) async {
                      final swipedBlog = blogs[previousIndex];
                      if (direction == CardSwiperDirection.right) {

                        String? rawLink = swipedBlog.medium_link;
                        if (rawLink == null || rawLink.trim().isEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          CustomSnackbar.show(context, "No, link for this blog is not available.");
                          return true;
                        }
                        String cleanUrl = rawLink.trim();
                        try {
                          final Uri articleUrl = Uri.parse(cleanUrl);
                          if (!await launchUrl(articleUrl, mode: LaunchMode.inAppBrowserView)) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            CustomSnackbar.show(context, "Could not open the article.");
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          CustomSnackbar.show(context, "Something went wrong. Try again Later");
                        }
                      } else if (direction == CardSwiperDirection.left) {
                      }
                      return true;
                    },
                    cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                      final currentBlog = blogs[index];
                      final int random = _getImageForBlog(index);
                      return
                        Container(
                            height: 300,
                            width: double.infinity,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset("assets/images/${currentBlog.blog_type}/$random.jpg", fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.0, 0.4]
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        stops: [0.3, 1]
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  left: 20,
                                  child: GestureDetector(
                                      onTap: () async {
                                        final Uri url = Uri.parse(Varfile.medium_url);
                                        if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                                          CustomSnackbar.show(context, "Could not open the Article.");
                                        }
                                      },
                                      child: Image.asset("assets/images/medium.png",width: 30,height: 30,)),
                                ),
                                Positioned(
                                  left: 20,
                                  right: 20,
                                  bottom: 195,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(40),
                                              border: Border.all(
                                                color: Color(0xffe6e6fa),
                                                width: 2,
                                              )
                                          ),
                                          child: Center(
                                            child: Text(currentBlog.blog_type,
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 13,
                                                    color: Color(0xffe6e6fa)
                                                )
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Padding(
                                          padding: const EdgeInsets.only(right:60),
                                          child: Text(currentBlog.title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 20,
                                                  color: Color(0xffe6e6fa)
                                              )
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Padding(
                                          padding: const EdgeInsets.only(right:10,),
                                          child: Text(currentBlog.short_description,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xffe6e6fa)
                                              )
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                        );
                    },
                  );
                }
            ),
          )
        ],
      ),
    );
  }

  Widget ForDesktop() {
    return Stack(
      children: [
        StarBg(),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: homenav(),
                  ),
                ),
                const SizedBox(height: 10),
                Align(alignment: AlignmentGeometry.topCenter,
                child: Text(
                  "Nakshtra Blogs",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 50,
                    color: const Color(0xffe6e6fa),
                  ),
                ),),
                Align(
                  alignment: AlignmentGeometry.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 23,right: 13),
                    child: Text("Click to Explore",
                        style:
                        GoogleFonts.poppins(
                            height: 0.7,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0x88e6e6fa))),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: const Color(0xffe6e6fa),
                        width: 2,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        icon: Icon(Icons.arrow_drop_down, color: Color(0xffe6e6fa)),
                        dropdownColor: Color(0xffe6e6fa),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _updateFilter(newValue);
                          }
                        },
                        selectedItemBuilder: (BuildContext context) {
                          final items = ["ALL", "ASTRO", "MATH"];
                          return items.map((String item) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.tune, color: Color(0xffe6e6fa), size: 22),
                                SizedBox(width: 5),
                                Text(
                                  item,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: const Color(0xffe6e6fa),
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                        items: const [
                          DropdownMenuItem(value: "ALL", child: Text("ALL")),
                          DropdownMenuItem(value: "ASTRO", child: Text("ASTRO")),
                          DropdownMenuItem(value: "MATH", child: Text("MATH")),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: SizedBox(
                    height: 770,
                    child: FutureBuilder(
                      future: _blog,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: earthrotate());
                        }
                        if (snapshot.hasError) {
                          return const Center(child: No_internet());
                        }
                        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                          return Center(
                            child: Text(
                              "No blogs found.",
                              style: TextStyle(color: Colors.red[300]),
                            ),
                          );
                        }

                        final blogs = snapshot.data as List;

                        return ListView.builder(
                          itemCount: blogs.length,
                          itemBuilder: (context, index) {
                            final currentBlog = blogs[index];
                            final int random = _getImageForBlog(index);
                            return GestureDetector(
                              onTap: ()async {
                                final Uri url = Uri.parse(Varfile.medium_url);
                                if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                                  CustomSnackbar.show(context, "Could not open the Article.");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Container(
                                  height: 300,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Container(
                                          width: 250,
                                          height: 250,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.asset("assets/images/${currentBlog.blog_type}/$random.jpg", fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 40, bottom: 30,top:30),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(40),
                                                    border: Border.all(
                                                      color: Color(0xffe6e6fa),
                                                      width: 2,
                                                    )
                                                ),
                                                child: Center(
                                                  child: Text(currentBlog.blog_type,
                                                      style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w800,
                                                          fontSize: 13,
                                                          color: Color(0xffe6e6fa)
                                                      )
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Padding(
                                                padding: const EdgeInsets.only(right:60),
                                                child: Text(currentBlog.title,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: 20,
                                                        color: Color(0xffe6e6fa)
                                                    )
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Padding(
                                                padding: const EdgeInsets.only(right:10,),
                                                child: Text(currentBlog.short_description,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(0xffe6e6fa)
                                                    )
                                                ),
                                              )
                                            ]
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (Responsive.isDesktop(context)) ? ForDesktop() : TinderCard()

    );
  }
}
