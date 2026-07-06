import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/pages/USER/MeetTheTeam.dart';
import 'package:gyansutra/pages/USER/Settings.dart';
import 'package:gyansutra/pages/USER/UserProfile.dart';
import 'package:gyansutra/pages/USER/aboutgyan.dart';
import 'package:gyansutra/pages/USER/aboutnkt.dart';
import 'package:gyansutra/pages/USER/Feedback.dart';
import 'package:gyansutra/pages/signIn.dart';


class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: CurvedDrawerShape(),
      backgroundColor: Colors.black.withOpacity(0.95),
      shadowColor: Colors.white54,
      elevation: 10,
      width: 250,
      child: Stack(
        children: [
          Opacity(opacity:0.1,
            child: Image.asset("assets/images/drawerbg.png",fit: BoxFit.cover,width: double.infinity,height: double.infinity,alignment: AlignmentGeometry.centerLeft,),),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                Expanded(
                  child: ListView(
                    children: <Widget> [
                      ListTile(
                        title: Text("My Profile", style: GoogleFonts.poppins(color: Colors.white),),
                        contentPadding: EdgeInsets.zero,
                        minTileHeight: 20,
                        hoverColor: Colors.blue,
                        autofocus: true,
                        leading: Icon(Icons.person_2_outlined, color: Color(0xffe6e6fa),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Userpage()));
                        },
                      ),
                      ExpansionTile(
                        tilePadding: EdgeInsets.only(left: 0, right: 40),
                        title: Text("About Us", style: GoogleFonts.poppins(color: Colors.white),),
                        minTileHeight: 20,
                        childrenPadding: EdgeInsets.only(left: 40),
                        leading: Icon(Icons.info_outline, color: Color(0xffe6e6fa),),
                        trailing: Icon(Icons.arrow_drop_down, color: Color(0xffe6e6fa),) ,
                        children: [
                          ListTile(
                            title: Text("Meet The Team", style: GoogleFonts.poppins(color: Colors.white,fontSize: 14),),
                            contentPadding: EdgeInsets.zero,
                            minTileHeight: 10,
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Meettheteam()));
                            }
                          ),
                          ListTile(
                            title: Text("About Nkt", style: GoogleFonts.poppins(color: Colors.white,fontSize: 14),),
                            contentPadding: EdgeInsets.zero,
                            minTileHeight: 10,
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Aboutnkt()));
                            }
                          ),
                          ListTile(
                            title: Text("About Gyan", style: GoogleFonts.poppins(color: Colors.white,fontSize: 14),),
                            contentPadding: EdgeInsets.zero,
                            minTileHeight: 10,
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Aboutgyan()));
                            }
                          ),
                        ],
                      ),
                      ListTile(
                        title: Text("Feedback", style: GoogleFonts.poppins(color: Colors.white),),
                        contentPadding: EdgeInsets.zero,
                        minTileHeight: 20,
                        leading: Icon(Icons.feedback_outlined, color: Color(0xffe6e6fa),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackPage()));
                        },
                      ),
                      ListTile(
                        title: Text("Settings", style: GoogleFonts.poppins(color: Colors.white),),
                        contentPadding: EdgeInsets.zero,
                        minTileHeight: 20,
                        leading: Icon(Icons.settings, color: Color(0xffe6e6fa),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
                        },
                      ),
                      ListTile(
                        title: Text("Log out", style: GoogleFonts.poppins(color: Colors.white),),
                        contentPadding: EdgeInsets.zero,
                        minTileHeight: 20,
                        leading: Icon(Icons.logout_outlined, color: Color(0xffe6e6fa),),
                        onTap: (){
                          showDialog(context: context, builder:
                          (BuildContext dialogContext){
                            return AlertDialog(
                              backgroundColor: Color(0xff232323),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                      color: Color(0x22e6e6fa),
                                      width: 1.5,)
                                ),
                                actionsPadding: const EdgeInsets.only(bottom: 10, right: 10, top: 0),
                                contentPadding: EdgeInsets.all(20),
                                content: Text("DO YOU REALLY WANT TO DO THIS?", style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12, color: Color(0xffe6e6fa)),),
                                actions: [
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xff232323),
                                        padding: EdgeInsets.zero,
                                          minimumSize: Size.zero
                                      ),
                                      onPressed: (){
                                    FStorage.deleteAll();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const signIn()),
                                          (route) => false,);
                                  },
                                      child: Text("Yes",style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Color(0x66e6e6fa)))),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xff232323),
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero
                                      ),
                                      onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text("No",style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Color(0xffe6e6fa)))),
                                ]
                            );
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}


class CurvedDrawerShape extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path();
    path.lineTo(rect.width - 50, 0);
    path.quadraticBezierTo(
        rect.width + 20, rect.height / 2,
        rect.width - 50, rect.height
    );
    path.lineTo(0, rect.height);
    path.close();
    return path;
  }
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
  @override
  ShapeBorder scale(double t) => this;
}