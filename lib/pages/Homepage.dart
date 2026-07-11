import 'package:flutter/material.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gyansutra/pages/Nakshatra/Astro/Astrocalender.dart';
import 'package:gyansutra/pages/Nakshatra/blogs.dart';
import 'package:gyansutra/pages/USER/MeetTheTeam.dart';
import 'package:gyansutra/pages/Nakshatra/Nakshatra.dart';
import 'package:gyansutra/pages/USER/aboutgyan.dart';
import 'package:gyansutra/pages/USER/aboutnkt.dart';
import 'package:gyansutra/pages/USER/abtapp.dart';
import 'package:gyansutra/pages/USER/drawer.dart';
import 'package:gyansutra/pages/gyansutra/peer2peer.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/exploreGyan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final Fstorage = const FlutterSecureStorage();

class _HomePageState extends State<HomePage> {
  final UserName = Fstorage.read(key: 'username');
  double _alignment = 0.0;
  bool _isDragging = false;
  int _animationTrigger = 0;

  @override
  Widget build(BuildContext context) {
    final double widthnav = 350;
    final double heightnav = 60;
    return Scaffold(
      drawer: CustomDrawer(),
      body:Stack(
        children: [
          StarBg(),
          Lottie.asset("assets/lottie/SpaceCat.json",
              key: ValueKey(_animationTrigger),
              fit: BoxFit.cover,width: double.infinity, height: double.infinity, repeat: false),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  Colors.black,

                ],begin: Alignment.topCenter,
                    end: Alignment.bottomLeft
                )
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05, top: 50),
                child: Column(
                  spacing: 3,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserSettingNav(IconColor: Color(0xffE6E6FA),),
                    SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 0,
                      children: [
                        FutureBuilder<String?>(
                          future: Fstorage.read(key: 'username'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text('Loading...');
                            }
                            if (snapshot.hasData && snapshot.data != null) {
                              return Text('Hello, ${snapshot.data}', style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffE6E6FA)));
                            }
                            return Text("Hello", style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffE6E6FA)));
                          },
                        ),
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [Color(0xffCDCDFF), Color(0xffE6E6FA)],
                              stops: [0.0, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: Text(
                            "Explore\nThe\nSpace!", style: GoogleFonts.poppins(
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                            letterSpacing: 1.5,

                          ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Most visited", style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xffE6E6FA),
                    ),
                    ),
                    Divider(color: Color(0xffE6E6FA), thickness: 1,),
                    SizedBox(height: 10),
                    StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 4,
                      children: [
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 3,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: RadialGradient(colors: [
                                Color(0xffB3B3FF),
                                Color(0xff030322),
                                Color(0xff09093b),
                              ],
                                  radius: 3,center: Alignment.topLeft),
                            ),
                            child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Astrocalender()));
                            },
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 20,
                                  right:1,
                                  child: Transform.rotate(
                                      angle : 0.2,
                                      child: Icon(Icons.calendar_month,color: Color(0x22ffffff), size: 300,)),
                                ),
                                Positioned(
                                    top:12,
                                    right: 10,
                                    child: Icon(Icons.arrow_circle_right, color: Colors.white.withOpacity(0.6),size:25 )
                                ),
                                Positioned(
                                    bottom: 20,
                                    left: 10,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Astro Calendar", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 18, fontWeight: FontWeight.w700,height: 1)),
                                        Text("Stay Updated with latest events", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 10, fontWeight: FontWeight.w500)),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                          )
                        ), //Astrocalender
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: RadialGradient(colors: [
                                  Color(0xffEAE2B7),
                                  Color(0xffF77F00),
                                  Color(0xffFFC34F),
                                ],
                                    radius: 2,center: Alignment.topLeft),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Exploregyan()));
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 10,
                                      left: 0,
                                      child: Transform.rotate(
                                          angle : 0.2,
                                          child: Icon(Icons.sticky_note_2_outlined,color: Color(0x221b003f), size: 300,)),
                                    ),
                                    Positioned(
                                        top:12,
                                        right: 10,
                                        child: Icon(Icons.arrow_circle_right, color: Colors.white.withOpacity(0.7),size: 25)
                                    ),
                                    Positioned(
                                        bottom: 15,
                                        left: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Study Materials", style: GoogleFonts.jost(color: Color(0xff1b003f), fontSize: 20, fontWeight: FontWeight.w700,height: 0.7),),
                                            Text("Gyansutra", style: GoogleFonts.jost(color: Color(0xff1b003f), fontSize: 10, fontWeight: FontWeight.w500)),

                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ), //Notes
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: RadialGradient(colors: [
                                  Color(0xff15151c),
                                  Color(0xff323291),
                                  Color(0xffb66f3f),
                                ],
                                    radius: 3,center: Alignment.topLeft),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Advicepage()));
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 10,
                                      left: 0,
                                      child: Transform.rotate(
                                          angle : 0.2,
                                          child: Icon(Icons.sticky_note_2_outlined,color: Color(0x22000000), size: 200,)),
                                    ),
                                    Positioned(
                                        top:12,
                                        right: 10,
                                        child: Icon(Icons.arrow_circle_right, color: Colors.white.withOpacity(0.6),size: 25)
                                    ),
                                    Positioned(
                                        bottom: 15,
                                        left: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Campus Share", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 20, fontWeight: FontWeight.w600,height: 0.7),),
                                            Text("Your Thought", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 10, fontWeight: FontWeight.w500)),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ), //PYQs
                        StaggeredGridTile.count(
                          crossAxisCellCount: 3,
                          mainAxisCellCount: 1,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: RadialGradient(colors: [
                                    Color(0xff09093b),
                                  Color(0xff030322),
                                    Color(0xffB3B3FF),

                                ],
                                    radius: 4,center: Alignment.topLeft),
                              ),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Blogs()));
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 150,
                                        child: Transform.rotate(
                                            angle : 0.2,
                                            child: Icon(Icons.scanner_outlined,color: Color(0x220ffffff), size: 120,)),
                                      ),
                                      Positioned(
                                          top:12,
                                          right: 10,
                                          child: Icon(Icons.arrow_circle_right, color: Colors.white.withOpacity(0.6),size: 25)
                                      ),
                                      Positioned(
                                          bottom: 20,
                                          left: 20,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Blogs", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 20, fontWeight: FontWeight.w600,height: 0.9),),
                                              Text("NKT Special", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 10, fontWeight: FontWeight.w500)),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ), //Announcement
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: RadialGradient(colors: [
                                  Color(0xffB3B3FF),
                                  Color(0xff030322),
                                  Color(0xff09093b),
                                ],
                                    radius: 3,center: Alignment.topLeft),
                              ),
                              child:GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutGyanScreen()));
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 150,
                                      child: Transform.rotate(
                                          angle : 0.2,
                                          child: Icon(Icons.scanner_outlined,color: Color(0x220ffffff), size: 120,)),
                                    ),
                                    Positioned(
                                        top:12,
                                        right: 10,
                                        child: Icon(Icons.arrow_circle_right, color: Colors.white.withOpacity(0.6),size: 25)
                                    ),
                                    Positioned(
                                        bottom: 15,
                                        left: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("About", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 18, fontWeight: FontWeight.w600,height: 0.7),),
                                            Text("The App", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 10, fontWeight: FontWeight.w500)),

                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ), //About the app
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: RadialGradient(colors: [
                                  Color(0xff000000),
                                  Color(0xff3B038A),

                                ],
                                    radius: 2,center: Alignment.topLeft),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Aboutnkt()));
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                        right: 20,
                                        bottom: 0,
                                        child: Transform.rotate(
                                            angle: 0.7,
                                            child: Opacity(opacity: 0.3,
                                                child: Image.asset("assets/images/translogo2.png",width: 240, height: 240,)))
                                    ),
                                    Positioned(
                                        bottom:15,
                                        right: 10,
                                        child: Icon(Icons.arrow_circle_right, color: Colors.white.withOpacity(0.7),size: 25)
                                    ),
                                    Positioned(
                                        bottom: 15,
                                        left: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Nakshatra", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 20, fontWeight: FontWeight.w700,height: 0.7),),
                                            Text("Know More...", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 10, fontWeight: FontWeight.w500)),

                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ), // Nakshatra
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: RadialGradient(colors: [
                                  Color(0xff818532),
                                  Color(0xff2B2B88),
                                  Color(0xff535391)
                                ],
                                    radius: 4,center: Alignment.topLeft),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Aboutgyan()));
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                        left: 40,
                                        top: 0,
                                        child: Transform.rotate(
                                            angle: 0.7,
                                            child: Opacity(opacity: 0.4,
                                                child: Image.asset("assets/images/translogo2.png",width: 240, height: 240,color: Colors.black, )))
                                    ),
                                    Positioned(
                                        top:12,
                                        right: 10,
                                        child: Icon(Icons.arrow_circle_right, color: Color(0xff1B003F).withOpacity(1),size: 25)
                                    ),
                                    Positioned(
                                        top: 15,
                                        left: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Gyansutra", style: GoogleFonts.jost(color: Color(0xff1B003F), fontSize: 20, fontWeight: FontWeight.w700,height: 0.7),),
                                            Text("Know More...", style: GoogleFonts.jost(color: Color(0xff1B003F), fontSize: 10, fontWeight: FontWeight.w500)),

                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),

                            ),
                          ),
                        ), // Gyansutra
                        StaggeredGridTile.count(
                          crossAxisCellCount: 4,
                          mainAxisCellCount: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: RadialGradient(colors: [
                                  Color(0xffFFc34f),
                                  Color(0xffeae2b7),

                                ],
                                    radius: 9,center: Alignment.topLeft),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Meettheteam()));
                                  },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                        left: -15,

                                        bottom: -40,
                                        child: Transform.rotate(
                                            angle: 0,
                                            child: Icon(Icons.groups_rounded,color: Color(0x111b003f), size: 150,))

                                    ),
                                    Center(child: Text("MEET THE TEAM", style: GoogleFonts.jost(color: Color(0xff1B003F), fontSize: 25, fontWeight: FontWeight.w800,height: 0.7),)),

                                  ],
                                ),
                              ),

                            ),
                          )
                        ), // Meet the creator
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: RadialGradient(colors: [
                                    Color(0xffB3B3FF),
                                  Color(0xff030322),
                                  Color(0xff09093b),

                                ],
                                    radius: 4,center: Alignment.bottomRight),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse(Varfile.instagram_url);
                                  if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Could not open the article.')),
                                    );
                                  }
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                        right: -30,
                                        bottom: 0,
                                        child: Transform.rotate(
                                            angle: 0.7,
                                            child: Opacity(opacity: 0.6,
                                                child: Image.asset("assets/images/instagram.png",width: 130, height: 130,)))
                                    ),
                                    Positioned(
                                        top:15,
                                        right: 10,
                                        child: Icon(Icons.arrow_circle_right, color: Colors.white.withOpacity(0.7),size: 25)
                                    ),
                                    Positioned(
                                        bottom: 15,
                                        left: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Social", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 20, fontWeight: FontWeight.w700,height: 0.7),),
                                            Text("Follow to Stay Update", style: GoogleFonts.jost(color: Color(0xffe6e6fa), fontSize: 10, fontWeight: FontWeight.w500)),

                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )

                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    MainTxt( text: "GYANSUTRA")
                  ]
                ),
              )
            )
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height*0.06,
            left:0,
            right:0,
            child: Center(
              child: Container(
                width: widthnav,
                height: heightnav,
                decoration: (
                BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [

                      BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 20,
                          blurStyle: BlurStyle.outer
                      )
                    ]
                )
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY:5),
                    child: Container(
                      width: widthnav,
                      height: heightnav,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 10,
                            blurRadius: 100,
                            blurStyle: BlurStyle.outer
                          )
                        ],
                        gradient: LinearGradient(colors: [
                          Color(0x88003049),
                          Color(0x88ffc34f),
                        ],)
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:25.0),
                                child: Text("Nakshatra", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(width: 3,),
                              Icon(Icons.keyboard_double_arrow_left_rounded,color: Colors.white.withOpacity(0.5),size: 20,),
                              Transform.translate(offset: Offset(-8, 0),
                                child: Icon(Icons.keyboard_double_arrow_left_rounded,color: Colors.white.withOpacity(0.5),size: 20,)),
                              SizedBox(width: heightnav,),
                              Icon(Icons.keyboard_double_arrow_right_rounded,color: Colors.white.withOpacity(0.5),size: 20,),
                              Transform.translate(offset: Offset(-8, 0),
                                  child: Icon(Icons.keyboard_double_arrow_right_rounded,color: Colors.white.withOpacity(0.5),size: 20,)),
                              Padding(
                                padding: const EdgeInsets.only(right:25.0),
                                child: Text("Gyansutra", style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          AnimatedAlign(duration: Duration(milliseconds: _isDragging ? 0:500),
                          alignment: Alignment(_alignment, 0),
                          child: GestureDetector(
                              onHorizontalDragStart:(details){
                                  setState(() {
                                    _isDragging = true;
                                  });
                                },
                              onHorizontalDragUpdate: (details){
                                  setState(() {
                                    double maxdistance = (widthnav - heightnav)/2;
                                    double distance = details.delta.dx/maxdistance;
                                    _alignment += distance;
                                    _alignment = _alignment.clamp(-1.0, 1.0);
                                  });
                                },
                              onHorizontalDragEnd: (details){
                                  setState(() {
                                    _isDragging = false;
                                  });
                                  if(_alignment <= -0.5){
                                    _alignment = -1.0;
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> NakshatraMain())).then((_){
                                      setState(() {
                                        _alignment = 0.0;
                                        _animationTrigger++;
                                      });
                                    });

                                  }
                                  else if(_alignment >= 0.5){
                                    _alignment = 1.0;
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Exploregyan())).then((_){
                                      setState(() {
                                        _alignment = 0.0;
                                        _animationTrigger++;
                                      });
                                    });
                                  }
                                  else {
                                    setState(() {
                                      _alignment = 0.0;
                                    });
                                  }
                                },
                              child: Container(
                                  height: heightnav,
                                  width: heightnav,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey
                                  ),
                                  child: Container(
                                      height: heightnav-10,
                                      width: heightnav-10,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white
                                      ),
                                      child:Lottie.asset("assets/lottie/Rocket.json",width: 60, height: 60)
                                  )
                              )


                          )
                    ),

                        ],
                      )
                      ),
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
