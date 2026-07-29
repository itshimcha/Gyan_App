import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:gyansutra/extra/Responsive.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gyansutra/extra/device_switch/Sign_android.dart'
if (dart.library.js_interop) 'package:gyansutra/extra/device_switch/Sign_Web.dart';
import 'package:lottie/lottie.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}
final Storage = const FlutterSecureStorage();
final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

class _signInState extends State<signIn> {
  bool _isLoading = false;
  bool _webReady = !kIsWeb;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _googleSignIn.initialize(serverClientId: null).then((_) {
        if (mounted) setState(() => _webReady = true);
      });
      _googleSignIn.authenticationEvents.listen((user) {
        if (user is GoogleSignInAuthenticationEventSignIn) {
          CompleteSignInGoogle(context, user.user);
        }
      });
    }
  }

  Future<void> CompleteSignInGoogle(BuildContext context, GoogleSignInAccount googleUser) async{
    setState(() => _isLoading = true);
    try {
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
        if (!context.mounted) return;
        CustomSnackbar.show(context, "Failed to authenticate with Google. Please try again Later.");
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.show(context,"An error occurred${e}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  Future<void> SignInGoogle(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      await _googleSignIn.initialize(serverClientId: Varfile.serverID);
      final googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      await CompleteSignInGoogle(context, googleUser);
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.show(context, "An error occurred$e");
      setState(() => _isLoading = false);
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
              Positioned(
                top: Responsive.isDesktop(context)? -200:-250,
                  right: Responsive.isDesktop(context)? -200:-250,
                  child: Lottie.asset("assets/lottie/WaveAnimation.json", width: 600, height: 600)),
                  () {
                    if (Responsive.isDesktop(context)) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 450,
                                // Removed fixed height: 450 to let content define height safely
                                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min, // Shrink-wraps content safely
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/translogo.png",
                                      height: 140, // Slightly reduced to fit gracefully
                                      width: 140,
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      "First Step Toward Cosmos...",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.alegreya(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xffE6E6FA),
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: 320,
                                      height: 60,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 320,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(16.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white.withOpacity(0.1),
                                                  spreadRadius: 0,
                                                  blurRadius: 20,
                                                  blurStyle: BlurStyle.outer,
                                                ),
                                              ],
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16.0),
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
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/google.png",
                                                            width: 28,
                                                            height: 28,
                                                          ),
                                                          const SizedBox(width: 12),
                                                          Text(
                                                            "SignIn with Google",
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 16, // Adjusted slightly to fit row cleanly
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Icon(Icons.arrow_forward, color: Colors.white, size: 22),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (kIsWeb && _webReady)
                                            Positioned.fill(
                                              child: Opacity(
                                                opacity: 0.01,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: SizedBox(
                                                    width: 320,
                                                    height: 40,
                                                    child: renderGoogleButton(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (!kIsWeb)
                                            Positioned.fill(
                                              child: GestureDetector(
                                                onTap: () => SignInGoogle(context),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 220, // Increased slightly so text doesn't overflow horizontally
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
                                      },
                                      child: Text(
                                        "Privacy Policy",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "|",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white.withOpacity(0.4),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CookiePolicyScreen()));
                                      },
                                      child: Text(
                                        "Cookies",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 90,),
                          Image.asset("assets/images/translogo.png", height: 100,width: 90,),
                          SizedBox(height: 320,),
                          Text(
                            "First Step\nToward Cosmos...", style: GoogleFonts.alegreya(fontSize: 40, fontWeight: FontWeight.w700,color: Color(0xffE6E6FA),height: 1.2),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: 320,
                            height: 60,
                            child: Stack(
                              children: [
                                Container(
                                  width: 320,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16.0),
                                    boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), spreadRadius: 0, blurRadius: 20, blurStyle: BlurStyle.outer)],
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                                    child: Container(
                                      width: double.infinity,

                                      height: 60,
                                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(16.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 30, right: 20, top: 8, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset("assets/images/google.png", width: 30, height: 30),
                                            const SizedBox(width: 8),
                                            Expanded(child: FittedBox(
                                                fit: BoxFit.scaleDown,child: Text("SignIn with Google", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)))),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.arrow_forward, color: Colors.white, size: 25),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (kIsWeb && _webReady)
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.01,
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: SizedBox(
                                          width: 320,
                                          height: 40,
                                          child: renderGoogleButton(),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (!kIsWeb)
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () => SignInGoogle(context),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
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
                        ],
                      ),
                    ),
                  );
                }
              }()
            ]
        )
    );
  }
}