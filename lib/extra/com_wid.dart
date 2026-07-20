import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class homenav extends StatelessWidget {
  const homenav({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));},
        icon: Icon(Icons.home,color: Colors.white,size: 30,));
    }
  }

class UserSettingNav extends StatelessWidget {
  final Color IconColor;
  const UserSettingNav({super.key, required this.IconColor });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: (){
          Scaffold.of(context).openDrawer();
        }, icon: Icon(Icons.drag_handle_rounded,color: Color(IconColor.value),size: 35,)),
      ],
    );
  }
}



class StarBg extends StatefulWidget {
  const StarBg({super.key});

  @override
  State<StarBg> createState() => _StarBgState();
}

class _StarBgState extends State<StarBg> with TickerProviderStateMixin{
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 1000));
  }
  @override
  Widget build(BuildContext context) {
    final random = Random();
    return Stack(
        children:[
          Stack(
            children: List.generate(200, (index) {
              return Positioned(
                left: random.nextDouble() * MediaQuery.of(context).size.width,
                top: random.nextDouble() * MediaQuery.of(context).size.height,
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        ]
    );
  }
}

class MainTxt extends StatelessWidget {
  final String text;
  const MainTxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Stack(
            children: [
            Container(
            height: 180,
            width: 200,
            child: Lottie.asset("assets/lottie/catlove.json",
              fit: BoxFit.cover,
            ),),
            SizedBox(height: 5),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
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
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:Colors.white
                          ),
                          child: Image.asset("assets/images/instagram.png", width: 30,height: 30,)),
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
                      child: Image.asset("assets/images/medium.png", width: 30,height: 30,),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(Varfile.linkdin_url);
                        if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open the article.')),
                          );
                        }
                      },
                      child: Image.asset("assets/images/linkedin.png", width: 30,height: 30,),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(Varfile.whatapp_url);
                        if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open the article.')),
                          );
                        }
                      },
                      child: Image.asset("assets/images/whatsapplogo.png", width: 35,height: 35,),
                    )
                  ]
              ),
            )
            ],
          ),
          // Text(
          //   "I LOVE ${text.toUpperCase()}", style: GoogleFonts.poppins(
          //     fontWeight: FontWeight.w800,
          //     fontSize: 50,
          //     color: Color(0xffE6E6FA).withOpacity(0.3),
          //     height: 1
          // ),
          //   overflow: TextOverflow.fade,
          // ),

          SizedBox(height: 20,),
          Text("Made by Himcha,Coco,Atharv,Akku\nPowered by Nakshatra NSUT and Team", style: GoogleFonts.poppins(color: Colors.white38.withOpacity(0.3),fontSize: 8, fontWeight: FontWeight.w600)),
          SizedBox(height: 140,)
        ],
      ),
    );
  }
}

class earthrotate extends StatelessWidget {
  const earthrotate({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset("assets/lottie/Earth.json", width: 80, height: 80),
    );
  }
}

class CustomSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

class No_internet extends StatelessWidget {
  final double size ;
  final double fontsize;
  const No_internet({super.key, this.size = 300, this.fontsize = 20});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: size/4.5,),
        Container(
          width: size ?? 300,
            height: size ?? 300,
          child: Lottie.asset("assets/lottie/Nointer.json"),
        ),
        Text("OOPS! No Internet Connection", style: GoogleFonts.poppins(color: Colors.white70, fontSize: fontsize ?? 20, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
