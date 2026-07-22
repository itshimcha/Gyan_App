import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:gyansutra/extra/com_wid.dart' show earthrotate, snackbar, CustomSnackbar;
import 'package:http/http.dart' as http;
import 'package:gyansutra/extra/backEndSup.dart';
import 'dart:convert';
import 'package:gyansutra/pages/signIn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';

final FStorage = const FlutterSecureStorage();

class Userpage extends StatefulWidget {
  const Userpage({Key? key}) : super(key: key);
  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  late Future<List<userProfile>> _userProfile;
  int _selectedCharIndex = 0;
  late String _activeCategory;

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

  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'rollno': TextEditingController(),
    'phone': TextEditingController(),
    'dateofbirth': TextEditingController(),
    'email': TextEditingController(),
  };

  String? _selectedCampus;
  String? _selectedBranch;
  int? _selectedBatch;
  int? _selectedSemester;

  final FocusNode _rollnoFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _dateofbirthFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _userProfile = getUserProfile();
    _loadSavedCharacter();
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _rollnoFocus.dispose();
    _dobFocus.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _dateofbirthFocus.dispose();
    _usernameFocus.dispose();
    super.dispose();
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
    if (refresh_token == null) return false;
    final response = await http.post(
      Uri.parse(apiConfig.RefreshTokenEndpoint),
      body: json.encode({'refresh': refresh_token}),
      headers: {'Content-Type': 'application/json'},
    );
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
          CustomSnackbar.show(context, "Session expired, Please Login again");
        }
        throw Exception('Session expired');
      }
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final profile = userProfile.fromJson(responseData);

      _controllers['name']?.text = profile.full_name ?? "";
      _controllers['dateofbirth']?.text = profile.date_of_birth ?? "";
      _controllers['rollno']?.text = profile.roll_no ?? "";
      _controllers['phone']?.text = profile.phone_number ?? "";
      _controllers['email']?.text = profile.email ?? "";

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

  String? _normalizeDate(String date) {
    if (date.trim().isEmpty) return null;
    try {
      final parsed = DateTime.parse(date.trim());
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {
      try {
        final parsed = DateFormat('dd-MM-yyyy').parse(date.trim());
        return DateFormat('yyyy-MM-dd').format(parsed);
      } catch (e) {
        return null;
      }
    }
  }

  Future<void> _selectDate(BuildContext context, StateSetter setSheetState) async {
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 18));
    if (_controllers['dateofbirth']!.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_controllers['dateofbirth']!.text);
      } catch (_) {}
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setSheetState(() {
        _controllers['dateofbirth']!.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> UserUpdate(String name, String rollNo, String phone, String dob, String? campus, String? branch, int? batch, int? semester) async {
    String? access_token = await FStorage.read(key: 'access_token');
    final String? _normalizedDob = _normalizeDate(dob);

    final Map<String, dynamic> updatedData = {
      'full_name': name.trim(),
      'roll_no': rollNo.trim(),
      'phone_number': phone.trim(),
      'date_of_birth': _normalizedDob ?? dob.trim(),
      'campus': campus,
      'branch': branch,
      'batch': batch,
      'semester': semester,
    };

    try {
      var response = await http.patch(
        Uri.parse(apiConfig.UserprofileupdateEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${access_token?.trim()}',
        },
        body: json.encode(updatedData),
      );
      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          access_token = await FStorage.read(key: 'access_token');
          response = await http.patch(
            Uri.parse(apiConfig.UserprofileupdateEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${access_token?.trim()}',
            },
            body: json.encode(updatedData),
          );
        } else {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const signIn()), (route) => false,
            );
          }
          return;
        }
      }

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _selectedCampus = campus;
            _selectedBranch = branch;
            _selectedBatch = batch;
            _selectedSemester = semester;
            _userProfile = getUserProfile();
          });
          CustomSnackbar.show(context, "Profile Updated Successfully");
          Navigator.pop(context);
        }
      } else {
        throw Exception('Failed to update profile, Check your internet connection');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(context, "Failed to update profile, Try again later");
      }
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
          Text(value, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),)
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
                  child: Image.asset("assets/images/profilebg.jpg", fit: BoxFit.cover,)),
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
                            top: MediaQuery.of(context).size.height * 0.3,
                            left: MediaQuery.of(context).size.width * 0.3,
                            bottom: MediaQuery.of(context).size.height * 0.07,
                            child: Container(
                                child: Image.asset(_characterData[_selectedCharIndex]["image"]!, fit: BoxFit.fitWidth)
                            )
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.height * 0.12,
                            left: MediaQuery.of(context).size.width * 0.51,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_characterData[_selectedCharIndex]["charaName"]!, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, height: 0.9, fontWeight: FontWeight.w700),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 9),
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
                                      items: List.generate(_characterData.length, (index) => DropdownMenuItem<int>(
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
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0x77e6e6fa),
                                Colors.transparent
                              ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 0.9]
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 3),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: MediaQuery.of(context).size.height * 0.02,
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
                                      Text("Username", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5), height: 0.7, fontSize: 10, fontWeight: FontWeight.w500),),
                                      Text(prodata.username.toUpperCase(), overflow: TextOverflow.ellipsis, maxLines: 2, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),),
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
                                  infoCard(Icon(Icons.calendar_month), "Date of Birth", prodata.date_of_birth.isNotEmpty ? DateFormat('dd MMMM yyyy').format(DateFormat('dd-MM-yyyy').parse(prodata.date_of_birth)) : "Not Provided"),
                                  infoCard(Icon(Icons.phone,), "Phone", prodata.phone_number),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                                  Divider(
                                    height: 1,
                                    endIndent: 4,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _controllers['name']!.text = prodata.full_name;
                                      _controllers['phone']!.text = prodata.phone_number;
                                      _controllers['rollno']!.text = prodata.roll_no;
                                      _controllers['dateofbirth']!.text = prodata.date_of_birth;
                                      _selectedCampus = Varfile.Campus.contains(prodata.campus) ? prodata.campus : null;
                                      _selectedBranch = Varfile.Branch_Name.contains(prodata.branch) ? prodata.branch : null;
                                      final int? parsedBatch = int.tryParse(prodata.batch.toString());
                                      _selectedBatch = Varfile.Batch.contains(parsedBatch) ? parsedBatch : null;
                                      final int? parsedSem = int.tryParse(prodata.semester.toString());
                                      _selectedSemester = Varfile.Sem.contains(parsedSem) ? parsedSem : null;

                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          String activeCategory = "Name";
                                          String? tempCampus = _selectedCampus;
                                          String? tempBranch = _selectedBranch;
                                          int? tempBatch = _selectedBatch;
                                          int? tempSemester = _selectedSemester;
                                          return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setSheetState) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context).viewInsets.bottom
                                                ),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xff191919),
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(20),
                                                        topRight: Radius.circular(20)
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(20),
                                                  constraints: BoxConstraints(
                                                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          Text("Edit Profile", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                                          const SizedBox(height: 15),
                                                          DropdownButtonFormField<String>(
                                                            value: activeCategory,
                                                            dropdownColor: Colors.black,
                                                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                                                            menuMaxHeight: 200,
                                                            decoration: InputDecoration(
                                                              prefixIcon: const Icon(Icons.search_outlined, color: Colors.white54, size: 20),
                                                              labelText: "Select Field to Edit",
                                                              labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                                                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.grey)),
                                                            ),
                                                            items: ["Name", "Rollno", "Campus", "Branch", "Semester", "Batch", "Phone", "Date of Birth"].map((String target) {
                                                              return DropdownMenuItem<String>(value: target, child: Text(target, style: const TextStyle(color: Colors.white)));
                                                            }).toList(),
                                                              onChanged: (newTarget) {
                                                                if (newTarget != null) {
                                                                  setSheetState(() => activeCategory = newTarget);
                                                                }
                                                              },
                                                          ),
                                                          const SizedBox(height: 25),
                                                          if (activeCategory == "Name")
                                                            TextFormField(
                                                              controller: _controllers['name'],
                                                              focusNode: _nameFocus,
                                                              style: const TextStyle(color: Colors.white),
                                                              decoration: InputDecoration(
                                                                prefixIcon: const Icon(Icons.person, color: Colors.white54, size: 20),
                                                                labelText: "Full Name",
                                                                labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400, fontSize: 15),
                                                                hintText: "Enter Full Name",
                                                                hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400),
                                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                  borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                                                                ),
                                                              ),
                                                            )
                                                          else if (activeCategory == "Rollno")
                                                            TextFormField(
                                                              controller: _controllers['rollno'],
                                                              focusNode: _rollnoFocus,
                                                              style: const TextStyle(color: Colors.white),
                                                              decoration: InputDecoration(
                                                                prefixIcon: const Icon(Icons.pin, color: Colors.white54, size: 20),
                                                                labelText: "Rollno",
                                                                labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400, fontSize: 15),
                                                                hintText: "Enter Roll Number",
                                                                hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400),
                                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                  borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                                                                ),
                                                              ),
                                                            )
                                                          else if (activeCategory == "Campus")
                                                              DropdownButtonFormField<String>(
                                                                value: Varfile.Campus.contains(tempCampus) ? tempCampus : null,
                                                                dropdownColor: const Color(0xff191919),
                                                                menuMaxHeight: 200,
                                                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                                                                decoration: InputDecoration(
                                                                  prefixIcon: const Icon(Icons.location_city, color: Colors.white54, size: 20),
                                                                  labelText: "Campus",
                                                                  labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.grey)),
                                                                ),
                                                                items: Varfile.Campus.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(color: Colors.white)))).toList(),
                                                                onChanged: (val) => setSheetState(() => tempCampus = val),
                                                              )
                                                            else if (activeCategory == "Branch")
                                                                DropdownButtonFormField<String>(
                                                                  value: Varfile.Branch_Name.contains(tempBranch) ? tempBranch : null,
                                                                  dropdownColor: const Color(0xff191919),
                                                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                                                                  menuMaxHeight: 300,
                                                                  decoration: InputDecoration(
                                                                    prefixIcon: const Icon(Icons.account_tree_rounded, color: Colors.white54, size: 20),
                                                                    labelText: "Branch",
                                                                    labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.grey)),
                                                                  ),
                                                                  items: Varfile.Branch_Name.map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(color: Colors.white)))).toList(),
                                                                  onChanged: (val) => setSheetState(() => tempBranch = val),
                                                                )
                                                              else if (activeCategory == "Semester")
                                                                  DropdownButtonFormField<int>(
                                                                    value: Varfile.Sem.contains(tempSemester) ? tempSemester : null,
                                                                    dropdownColor: const Color(0xff191919),
                                                                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                                                                    menuMaxHeight: 300,
                                                                    decoration: InputDecoration(
                                                                      prefixIcon: const Icon(Icons.menu_book_rounded, color: Colors.white54, size: 20),
                                                                      labelText: "Semester",
                                                                      labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.grey)),
                                                                    ),
                                                                    items: Varfile.Sem.map((s) => DropdownMenuItem<int>(value: s, child: Text(s.toString(), style: const TextStyle(color: Colors.white)))).toList(),
                                                                    onChanged: (val) => setSheetState(() => tempSemester = val),
                                                                  )
                                                                else if (activeCategory == "Batch")
                                                                    DropdownButtonFormField<int>(
                                                                      value: Varfile.Batch.contains(tempBatch) ? tempBatch : null,
                                                                      dropdownColor: const Color(0xff191919),
                                                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                                                                      menuMaxHeight: 300,
                                                                      decoration: InputDecoration(
                                                                        prefixIcon: const Icon(Icons.badge, color: Colors.white54, size: 20),
                                                                        labelText: "Batch",
                                                                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                                                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.grey)),
                                                                      ),
                                                                      items: Varfile.Batch.map((b) => DropdownMenuItem<int>(value: b, child: Text(b.toString(), style: const TextStyle(color: Colors.white)))).toList(),
                                                                      onChanged: (val) => setSheetState(() => tempBatch = val),
                                                                    )
                                                                  else if (activeCategory == "Phone")
                                                                      TextFormField(
                                                                        controller: _controllers['phone'],
                                                                        focusNode: _phoneFocus,
                                                                        keyboardType: TextInputType.number,
                                                                        style: GoogleFonts.poppins(color: Colors.white),
                                                                        decoration: InputDecoration(
                                                                          prefixIcon: const Icon(Icons.phone, color: Colors.white54, size: 20),
                                                                          prefixText: "+91 ",
                                                                          prefixStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w400, fontSize: 15),
                                                                          labelText: "Phone Number",
                                                                          labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400, fontSize: 15),
                                                                          hintText: "**********",
                                                                          hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400),
                                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                                                                          focusedBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(12.0),
                                                                            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    else if (activeCategory == "Date of Birth")
                                                                        TextFormField(
                                                                          controller: _controllers['dateofbirth'],
                                                                          focusNode: _dateofbirthFocus,
                                                                          readOnly: true,
                                                                          style: const TextStyle(color: Colors.white),
                                                                          decoration: InputDecoration(
                                                                            suffixIcon: const Icon(Icons.calendar_month, color: Colors.white54, size: 20),
                                                                            labelText: "Date of Birth",
                                                                            labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400, fontSize: 15),
                                                                            hintText: "DD/MM/YYYY",
                                                                            hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400),
                                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                                                                            focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                                                                            ),
                                                                          ),
                                                                          onTap: () => _selectDate(context, setSheetState),
                                                                        ),
                                                          const SizedBox(height: 40),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.indigoAccent,
                                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                            ),
                                                            onPressed: () {
                                                              UserUpdate(
                                                                  _controllers['name']!.text,
                                                                  _controllers['rollno']!.text,
                                                                  _controllers['phone']!.text,
                                                                  _controllers['dateofbirth']!.text,
                                                                  tempCampus,
                                                                  tempBranch,
                                                                  tempBatch,
                                                                  tempSemester
                                                              );
                                                            },
                                                            child: Text("Save Changes", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
                                                          ),
                                                          const SizedBox(height: 50)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_note, color: Colors.white.withOpacity(0.5)),
                                        const SizedBox(width: 4),
                                        Text("Edit Profile", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w500))
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