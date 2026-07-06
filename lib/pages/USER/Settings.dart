import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/pages/USER/Cookies.dart';
import 'package:gyansutra/pages/USER/T&C.dart';
import 'package:gyansutra/pages/USER/abtapp.dart';
import 'package:gyansutra/pages/USER/privacy.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool permissionDisabled =true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40,),
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios_new, color: Color(0xffe6e6fa),size: 20,)),
            ),
            Align(
              alignment: Alignment.center,
                child: Text("Settings", style: GoogleFonts.alegreya(color: Color(0xffe6e6fa),height: 0.6 ,fontWeight: FontWeight.w600, fontSize: 50),)),
            SizedBox(height: 10,),
            SizedBox(height: 20,),
            ListView(
              physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top:10, left: 10, right: 10,bottom: 15),
                shrinkWrap: true,
                children: [
                  ExpansionTile(
                    leading: Icon(Icons.security,color: Color(0x99e6e6fa),size: 20,),
                    childrenPadding: EdgeInsets.only(left: 20,top: 0,bottom: 0,right: 0),
                    tilePadding: EdgeInsets.zero,
                    minTileHeight: 30,
                    title: Text("Permissions", style: GoogleFonts.poppins(color: Color(0xffe6e6fa), fontWeight: FontWeight.w500),),
                    children: [
                      IgnorePointer(
                        ignoring: permissionDisabled,
                        child: Opacity(
                          opacity: permissionDisabled ? 0.5:1,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minTileHeight: 10,
                            leading: Icon(Icons.notifications_active,color: Color(0x99e6e6fa),size: 20),
                            title: Text("Notification", style: GoogleFonts.poppins(color: Color(0xffe6e6fa), fontWeight: FontWeight.w500, fontSize: 15),),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: permissionDisabled,
                        child: Opacity(
                          opacity: permissionDisabled ? 0.5:1,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minTileHeight: 10,
                            leading: Icon(Icons.camera_alt_outlined,color: Color(0x99e6e6fa),size: 20),
                            title: Text("Camera", style: GoogleFonts.poppins(color: Color(0xffe6e6fa), fontWeight: FontWeight.w500, fontSize: 15),),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: permissionDisabled,
                        child: Opacity(
                          opacity: permissionDisabled ? 0.5:1,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minTileHeight: 10,
                              leading: Icon(Icons.location_on,color: Color(0x99e6e6fa),size: 20),
                              title: Text("Location", style: GoogleFonts.poppins(color: Color(0xffe6e6fa), fontWeight: FontWeight.w500,fontSize: 15),),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: permissionDisabled,
                        child: Opacity(
                          opacity: permissionDisabled ? 0.5:1,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minTileHeight: 10,
                            leading: Icon(Icons.storage,color: Color(0x99e6e6fa),size: 20),
                            title: Text("Storage", style: GoogleFonts.poppins(color: Color(0xffe6e6fa), fontWeight: FontWeight.w500,fontSize: 15),),
                          ),
                        ),
                      ),

                    ],
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutGyanScreen()));
                    },
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: 10,
                    leading: Icon(Icons.info_outline,color: Color(0x99e6e6fa),size: 20),
                    title: Text("About App", style: GoogleFonts.poppins(color: Color(0xffe6e6fa), fontWeight: FontWeight.w500, fontSize: 15),),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditionsScreen()));
                    },
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: 10,
                    leading: Icon(Icons.assignment_outlined,color: Color(0x99e6e6fa),size: 20),
                    title: Text("Term & Conditions", style: GoogleFonts.poppins(color: Color(0xffe6e6fa), fontWeight: FontWeight.w500, fontSize: 15),),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicyScreen()));
                    },
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: 10,
                    leading: Icon(Icons.privacy_tip_outlined,color: Color(0x99e6e6fa),size: 20),
                    title: Text("Privacy Policy", style: GoogleFonts.poppins(color: Color(0xffe6e6fa), fontWeight: FontWeight.w500, fontSize: 15),),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CookiePolicyScreen()));
                    },
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: 10,
                    leading: Icon(Icons.cookie_outlined,color: Color(0x99e6e6fa),size: 20),
                    title: Text("Cookies", style: GoogleFonts.poppins(color: Color(0xffe6e6fa), fontWeight: FontWeight.w500, fontSize: 15),),
                  ),
                ]
            )
          ],
        ),
      ),
    );
  }
}
