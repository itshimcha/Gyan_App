import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gyansutra/extra/com_wid.dart' show earthrotate;
import 'package:http/http.dart' as http;
import 'package:gyansutra/extra/backEndSup.dart';
import 'dart:convert';
import 'package:gyansutra/pages/signIn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


final FStorage = const FlutterSecureStorage();

class Userpage extends StatefulWidget {
  const Userpage({Key? key}) : super(key: key);
  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  late Future<List<userProfile>> _userProfile;
  int _selectedCharIndex = 0;

  final List<Map<String, String>> _characterData = [
    {
      "name": "Hero",
      "charaName": "Peter Parker",
      "image": "assets/images/Char/1.png",
      "desc": "Driven by an unshakeable sense of responsibility and a brilliant, analytical mind. They constantly juggle heavy burdens, using their sharp intellect, witty humor, and profound resilience to persevere through overwhelming odds and protect everyday people."
    },
    {
      "name": "Loyalist",
      "charaName": "Adrien Agreste",
      "image": "assets/images/Char/2.png",
      "desc": "Outwardly easygoing and charming, yet internally seeking freedom and genuine connection. They are fiercely protective of their inner circle and highly dependable when it truly matters."
    },
    {
      "name": "Achiever",
      "charaName": "Cristiano Ronaldo",
      "image": "assets/images/Char/3.png",
      "desc": "Defined by absolute discipline, ambition, and an unwavering pursuit of perfection. They are highly competitive, fiercely focused, and naturally inspire others to elevate their own game."
    },
    {
      "name": "Trendsetter",
      "charaName": "Gwen Stacy",
      "image": "assets/images/Char/4.png",
      "desc": "Cool, rhythmic, and effortlessly graceful. They value their independence and personal space, navigating complex social or professional situations with a calm, untouchable confidence."
    },
    {
      "name": "Guardian",
      "charaName": "Giyu Tomioka",
      "image": "assets/images/Char/5.png",
      "desc": "Quiet, observant, and emotionally guarded. They speak only when necessary but possess immense depth, unshakeable reliability, and a profound sense of duty to protect those around them."
    },
    {
      "name": "Tactician",
      "charaName": "Shinobu Kocho",
      "image": "assets/images/Char/6.png",
      "desc": "Masks a sharp, analytical mind behind a gentle and cheerful demeanor. They rely on intellect, precise strategy, and a composed exterior to outsmart challenges rather than using brute force."
    },
    {
      "name": "Optimist",
      "charaName": "Tom",
      "image": "assets/images/Char/7.png",
      "desc": "Endlessly determined despite constant setbacks. They are expressive, highly theatrical, and incredibly resilient, proving that no matter how hard they fall, they will always bounce back to try again."
    },
    {
      "name": "Rebel",
      "charaName": "Urban Swordswoman",
      "image": "assets/images/Char/8.png",
      "desc": "Bold, fiercely independent, and unapologetically vibrant. They combine sharp, street-smart intuition with a striking, modern aesthetic that commands attention and refuses to blend into the background."
    }
  ];

  @override
  void initState() {
    super.initState();
    _userProfile = getUserProfile();
    _loadSavedCharacter();
  }

  Future<void> _loadSavedCharacter() async {
    String? savedIndex = await FStorage.read(key: 'char');
    if (savedIndex != null && mounted) {
      setState(() {
        _selectedCharIndex = int.parse(savedIndex);
      });
    }
  }

  Future<bool> refreshToken() async {
    String? refresh_token = await FStorage.read(key: 'refresh_token');
    print("Attempting to refresh with token: $refresh_token");

    if (refresh_token == null) return false;

    final response = await http.post(
      Uri.parse(apiConfig.RefreshTokenEndpoint),
      body: json.encode({'refresh': refresh_token}),
      headers: {'Content-Type': 'application/json'},
    );

    print("Refresh Token Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String newAccessToken = data['access'];

      await FStorage.delete(key: 'access_token');
      await FStorage.write(key: 'access_token', value: newAccessToken);
      return true;
    } else {
      await FStorage.deleteAll();
      return false;
    }
  }

  Future<List<userProfile>> getUserProfile() async {
    String? access_token = await FStorage.read(key: 'access_token');

    var response = await http.get(
      Uri.parse(apiConfig.UserprofileEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access_token',
      },
    );

    if (response.statusCode == 401) {
      bool refreshed = await refreshToken();

      if (refreshed) {
        access_token = await FStorage.read(key: 'access_token');
        response = await http.get(
          Uri.parse(apiConfig.UserprofileEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $access_token',
          },
        );
      } else {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const signIn()),
                (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Session expired. Please log in again.")),
          );
        }
        throw Exception('Session expired');
      }
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final profile = userProfile.fromJson(responseData);
      await FStorage.write(key: 'name', value: profile.full_name);
      await FStorage.write(key: 'email', value: profile.email);
      await FStorage.write(key: 'avatar_url', value: profile.avatar_url);
      await FStorage.write(key: 'username', value: profile.username);
      await FStorage.write(key: 'date_of_birth', value: profile.date_of_birth);
      await FStorage.write(key: 'campus', value: profile.campus);
      await FStorage.write(key: 'branch', value: profile.branch);
      await FStorage.write(key: 'batch', value: profile.batch);
      await FStorage.write(key: 'semester', value: profile.semester);
      await FStorage.write(key: 'roll_no', value: profile.roll_no);
      await FStorage.write(key: 'phone_number', value: profile.phone_number);
      return [profile];
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Widget infoCard(Icon icon, String field, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon.icon, color: Colors.white.withOpacity(0.5), size: 15,),
            SizedBox(width: 4,),
            Text(field, style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w500),)
          ],
        ),

        Text(value,overflow: TextOverflow.ellipsis,  style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),)
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(opacity: 0.2,
              child: Image.asset("assets/images/profilebg.jpg",fit: BoxFit.cover,)),
            ),
            FutureBuilder<List<userProfile>>(
                future: _userProfile,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return earthrotate();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data found.",
                        style: TextStyle(color: Colors.white)));
                  }
                  final profiles = snapshot.data!;
                  final prodata = profiles.first;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Positioned(
                            top:MediaQuery.of(context).size.height*0.3,
                            left: MediaQuery.of(context).size.width*0.3,
                            bottom: MediaQuery.of(context).size.height*0.07,
                            child: Container(
                                child: Image.asset(_characterData[_selectedCharIndex]["image"]!,fit: BoxFit.fitWidth)
                            )
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.height * 0.12,
                            left: MediaQuery.of(context).size.width * 0.51,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_characterData[_selectedCharIndex]["charaName"]!, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18,height: 0.9, fontWeight: FontWeight.w700),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top:9),
                                  child: AnimatedTextKit(
                                    key: ValueKey<int>(_selectedCharIndex),
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        _characterData[_selectedCharIndex]["desc"]!,
                                        textStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
                                        speed: const Duration(milliseconds: 50),
                                      ),
                                    ],
                                    totalRepeatCount: 1,
                                    displayFullTextOnTap: true,
                                  ),
                                ),
                              ],
                            )
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.05,
                          left: MediaQuery.of(context).size.width * 0.7,
                          child: Container(
                            height: 30,
                            width: 115,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                            ),
                            child: Center(
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                      value: _selectedCharIndex,
                                      isExpanded: true,
                                      dropdownColor: const Color(0xFF1E1E1E),
                                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                                      items: List.generate(_characterData.length,(index) => DropdownMenuItem<int>(
                                        value: index,
                                        child: Center(child: Text(_characterData[index]["name"]!)),
                                      )),
                                      onChanged: (int? newIndex) async {
                                        if (newIndex != null) {
                                          setState(() {
                                            _selectedCharIndex = newIndex;
                                          });
                                        }
                                        await FStorage.write(key: 'char', value: newIndex.toString());

                                      })
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0x77e6e6fa),
                                Colors.transparent
                              ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0,0.9]
                              )
                          ),
                          child:Padding(
                            padding: const EdgeInsets.only(left:10, right: 3),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: MediaQuery.of(context).size.height * 0.02 ,
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                  CircleAvatar(
                                    child: ClipOval(
                                      child: prodata.avatar_url.isEmpty ? const Icon
                                        (Icons.person, color: Colors.grey, size: 30) : Image.network(prodata.avatar_url,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                            size: 30,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Username", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5),height:0.7,fontSize: 10, fontWeight: FontWeight.w500),),
                                      Text(prodata.username.toUpperCase(),overflow: TextOverflow.ellipsis,maxLines: 2, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),),
                                    ],
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                  infoCard(Icon(Icons.person,), "Name", prodata.full_name),
                                  infoCard(Icon(Icons.school,), "Roll No", prodata.roll_no),
                                  infoCard(Icon(Icons.email,), "Email", prodata.email),
                                  infoCard(Icon(Icons.school), "Branch", prodata.branch),
                                  infoCard(Icon(Icons.school,), "Semester", prodata.semester),
                                  infoCard(Icon(Icons.school,), "Batch", prodata.batch),
                                  infoCard(Icon(Icons.school,), "Campus", prodata.campus),
                                  infoCard(Icon(Icons.calendar_month,), "Date of Birth", prodata.date_of_birth),
                                  infoCard(Icon(Icons.phone,), "Phone", prodata.phone_number),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                                  Divider(
                                    height: 1,
                                    endIndent: 4,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      showBottomSheet(context: context,
                                          backgroundColor: Colors.transparent,
                              
                                          enableDrag: true,
                                          showDragHandle: true,
                                          elevation: 2,
                                          builder: (BuildContext context){
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xee191919),
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.white.withOpacity(0.1),
                                                        spreadRadius: 2,
                                                        blurRadius: 20,
                                                        blurStyle: BlurStyle.outer
                              
                                                    )
                                                  ]
                                              ),
                                              height: 200,
                                              width: MediaQuery.of(context).size.width,
                                              child: Center(
                                                child: Text("Profile Update will be Unable Soon,",style: GoogleFonts.poppins(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
                                              ),
                                            );
                                          });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_note,color: Colors.white.withOpacity(0.5),),
                                        SizedBox(width: 4,),
                                        Text("Edit Profile", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5),fontSize: 12, fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            )
          ]
      ),
    );
  }
}