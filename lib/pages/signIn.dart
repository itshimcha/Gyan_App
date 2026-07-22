import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:gyansutra/pages/USER/Cookies.dart';
import 'package:gyansutra/pages/USER/privacy.dart';
import 'package:gyansutra/pages/Userinput.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gyansutra/extra/VarFile.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}
final Storage = const FlutterSecureStorage();
final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

class _signInState extends State<signIn> {
  bool _isLoading = false;

  Future<void> SignInGoogle(BuildContext context) async{

    try {
      await _googleSignIn.initialize(
        serverClientId: Varfile.serverID,
      );

      final googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) {
        setState(() { _isLoading = false; });
        return;
      }

      final googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      final response = await http.post(
        Uri.parse(apiConfig.authEndpoint),
        headers: apiConfig.headers,
        body: json.encode({'id_token': idToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final String myAccessToken = responseData['access'];
        final String myRefreshToken = responseData['refresh'];
        final bool isProfileComplete = responseData['is_profile_complete'];
        final Map<String, dynamic> user = responseData['user'];
        final String email = user['email'];
        final String name = user['name'];

        await Storage.write(key: 'access_token', value: myAccessToken);
        await Storage.write(key: 'refresh_token', value: myRefreshToken);
        await Storage.write(key: 'email', value: email);
        await Storage.write(key: 'name', value: name);
        await Storage.write(key: 'is_profile_complete', value: isProfileComplete.toString());
        if (!context.mounted) return;
        if (isProfileComplete) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInput()),
          );
        }
      } else {
        print(response.statusCode);
        print(response.body);
        if (!context.mounted) return;
        CustomSnackbar.show(context, "Failed to authenticate with Google. Please try again.");
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.show(context,"An error occurred");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Stack(
            children: [
              StarBg(),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0x663B038A),
                      Colors.black
                    ],begin: Alignment.topCenter,
                        end: Alignment.bottomLeft
                    )
                ),
              ),
              Stack(
                children: [
                  Positioned(
                      top: 100,
                      left: 25,
                      child: Image.asset("assets/images/translogo.png", height: 100,width: 90,)
                  ),
                  Positioned(
                    top: 500,
                    left: 20,
                    child: SizedBox(
                      width: 400,
                      height: 100,
                      child: Text(
                        "First Step\nToward Cosmos...", style: GoogleFonts.alegreya(fontSize: 40, fontWeight: FontWeight.w700,color: Color(0xffE6E6FA),height: 1.2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 630,
                    left: 20,
                    child: GestureDetector(
                        onTap: (){
                          SignInGoogle(context);
                        },
                        child: Stack(
                            children: [
                              Container(
                                width: 320,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16.0),
                                    boxShadow: [BoxShadow(
                                        color: Colors.white.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 20,
                                        blurStyle: BlurStyle.outer
                                    )]
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                                  child: Container(
                                      width: 320,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:30, right: 20, top: 8, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Image.asset("assets/images/google.png",width: 30,height: 30,),
                                                  SizedBox(width: 8,),
                                                  Text("SignIn with Google",style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white)),
                                                ]
                                            ),
                                            Icon(Icons.arrow_forward,color: Colors.white,size: 25,),
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ]

                        )
                    ),
                  ),
                  Positioned(
                      bottom: 50,
                      left: 30,
                      child: Container(
                        width: 180,
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicyScreen()));
                                },
                                child: Text(
                                  "Privacy Policy", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700,color: Colors.white.withOpacity(0.4)),
                                )
                            ),
                            Text(
                              "|", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700,color: Colors.white.withOpacity(0.4)),
                            ),
                            GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CookiePolicyScreen()));
                                },
                                child: Text(
                                  "Cookies", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700,color: Colors.white.withOpacity(0.4)),
                                )
                            )

                          ],
                        ),
                      )
                  )
                ],
              )
            ]
        )
    );
  }
}