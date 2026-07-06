import 'package:flutter/material.dart';
import 'package:gyansutra/pages/Nakshatra/Nakshatra.dart';
import 'package:gyansutra/pages/gyansutra/GyanComm.dart';
import 'package:gyansutra/pages/gyansutra/gyanpages/exploreGyan.dart';
import 'package:gyansutra/pages/gyansutra/peer2peer.dart';
import 'package:gyansutra/pages/gyansutra/sandbox.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GyanMain extends StatefulWidget {
  const GyanMain({super.key});

  @override
  State<GyanMain> createState() => _GyanMainState();
}

class _GyanMainState extends State<GyanMain> {
  int selectedIndex = 0;

  List<Widget> _pages = const [
    Exploregyan(),
    Sandbox(),
    Gyancomm(),
    Advicepage()
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
                height: 200,
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
            GyanNav(
              selectedIndex: selectedIndex,
              onTabChange: (index) => setState(() => selectedIndex = index),
            )
          ],
        )

    );
  }
}

class GyanNavBarPainter extends CustomPainter {
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
          Color(0xffedd8df),
          Color(0xffeba328),
        ],
        stops: [0.0,0.8],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;


    canvas.drawShadow(path,Colors.black,15,false);
    canvas.drawPath(path, fillPaint);

    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF233436),
          Color(0xFFe6e6fa),
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

class GyanNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  const GyanNav({super.key, required this.selectedIndex, required this.onTabChange});

  @override
  State<GyanNav> createState() => _GyanNavState();
}

class _GyanNavState extends State<GyanNav> {
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
          width: w,
          height: h,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: GyanNavBarPainter(),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      color: Colors.transparent,
                      width: 290,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              GButton(icon: Icons.menu_book, text: 'Gyan'),
                              GButton(icon: Icons.explore_outlined, text: 'SandBox'),
                              GButton(icon: Icons.people, text:"Chat"),
                              GButton(icon: Icons.note_add_outlined, text: 'P2P'),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NakshatraMain()));
                    },
                    child: Container(
                      width: radius*2,
                      height: radius*2,
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(

                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('assets/images/translogo2bk.png',height: 40,width: 40,),
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

