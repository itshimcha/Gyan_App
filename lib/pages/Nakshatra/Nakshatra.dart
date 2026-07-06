import 'package:flutter/material.dart';
import 'package:gyansutra/pages/Nakshatra/Astro/Astrocalender.dart';
import 'package:gyansutra/pages/Nakshatra/Explore.dart';
import 'package:gyansutra/pages/Nakshatra/blogs.dart';
import 'package:gyansutra/pages/Nakshatra/cosmicFeed.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/exploreGyan.dart';



class NakshatraMain extends StatefulWidget {
  const NakshatraMain({super.key});

  @override
  State<NakshatraMain> createState() => _NakshatraMainState();
}

class _NakshatraMainState extends State<NakshatraMain> {
  int selectedIndex = 0;

  List<Widget> _pages = const [
    Cosmicfeed(),
    Explore(),
    Astrocalender(),
    Blogs()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[selectedIndex],
          Positioned(
              top: 0,
            child: Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [
                        Color(0x88000000),
                        Colors.transparent,
                      ],
                      stops: [0,1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color(0xff000000)
                  ],
                  stops: [0,0.7],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              ),
            ),
          ),
          NavBar(
            selectedIndex: selectedIndex,
            onTabChange: (index) => setState(() => selectedIndex = index),
          )
        ],
      )

    );
  }
}


class NakNavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double radius = h / 2;
    Path path = Path();
    path.moveTo(radius, 0);
    double pinchStartX = w - (h *1.6);
    path.lineTo(pinchStartX, 0);
    path.cubicTo(
      w - (h * 1.3), 0,
      w - (h * 1.3), h * 0.40,
      w - (h * 1.1), h * 0.40,
    );
    path.cubicTo(
      w - (h * 0.9), h * 0.40,
      w - (h * 0.9), 0.40,
      w - radius, 0,
    );
    path.arcToPoint(
        Offset(w - radius, h),
        radius: Radius.circular(radius),
        largeArc: true
    );
    path.cubicTo(
      w - (h * 0.9), h,
      w - (h * 0.9), h * 0.6,
      w - (h * 1.1), h * 0.6,
    );
    path.cubicTo(
      w - (h * 1.3), h * 0.6,
      w - (h * 1.3), h,
      pinchStartX, h,
    );
    path.lineTo(radius, h);
    path.arcToPoint(
        Offset(radius, 0),
        radius: Radius.circular(radius),
        largeArc: true
    );
    path.close();


    final Paint fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xffe6e6fa),
          Color(0xff3971d8),

        ],
        stops: [0.0,0.6],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;


    canvas.drawShadow(path,Colors.black,15,false);
    canvas.drawPath(path, fillPaint);

    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF6a00ff),
          Color(0xFFc5f0ff),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(path, borderPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  const NavBar({super.key, required this.selectedIndex, required this.onTabChange});

  @override
  State<NavBar> createState() => _NavBarState();
}


class _NavBarState extends State<NavBar> {

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width*0.9;
    final double h = 60;
    final double radius = h / 2;
    return Positioned(
        bottom: 60,
        left: 20,
        right: 20,
        child: Container(
          height: h,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: NakNavBarPainter(),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                       padding: const EdgeInsets.only(left: 10, right: 10),
                       child: GNav(
                        iconSize:25,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        gap: 8,
                        color: Color(0xff1b003f).withOpacity(0.5),
                        activeColor: Color(0xffe6e6fa),
                        tabBackgroundColor: Color(0xff1b003f),
                        tabBorderRadius: 40,
                        selectedIndex: widget.selectedIndex,
                        onTabChange: widget.onTabChange,
                        tabs: [
                          GButton(icon: Icons.newspaper, text: 'News'),
                          GButton(icon: Icons.camera, text: 'Explore'),
                          GButton(icon: Icons.calendar_month, text: 'Astro'),
                          GButton(icon: Icons.book, text: 'Blogs'),

                        ],
                      )
                    ),
                  ),
                  SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left:0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Exploregyan()));
                      },
                      child: Container(
                        width: radius*2,
                        height: radius*2,
                        alignment: Alignment.center,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(

                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/images/translogo2.png',height: 40,width: 40,),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
}