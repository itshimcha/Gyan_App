import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:flutter/services.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class UserInput extends StatefulWidget {
  const UserInput({super.key});

  @override
  State<UserInput> createState() => _UserInputState();
}

final Storage = const FlutterSecureStorage();

class _UserInputState extends State<UserInput> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController  = TextEditingController();
  final TextEditingController _rollnoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? selectedBranch;
  int? selectedSem;
  String? selectedCampus;
  int? selectedBatch;


  Future<void> _handleLogin() async {
    String? access_token = await Storage.read(key: 'access_token');
    try {
      final response = await http.put(
        Uri.parse(apiConfig.UserinputEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access_token'
        },

        body: jsonEncode({
          'full_name': _nameController.text,
          'username': _usernameController.text,
          'phone_number': _phoneController.text,
          'date_of_birth': _dobController.text,
          'roll_no': _rollnoController.text,
          'branch': selectedBranch,
          'semester': selectedSem,
          'campus': selectedCampus,
          'batch': selectedBatch,
        }),
      );
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage())
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Text(
                          " Who's Exploring?", style: GoogleFonts.alegreya(fontWeight: FontWeight.w600,fontSize: 40,color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Fill the details", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.6)),
                      ),
                      SizedBox(height: 10,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: BackdropFilter(
                          filter:ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                          child: Container(
                            width: 340,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 18),
                                      child: Text("Name", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.7)),)),
                                  Container(
                                      width: 300,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                            colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                            ,center: Alignment.topLeft,radius: 7),
                                        borderRadius: BorderRadius.circular(40.0),
                                      ),
                                      child: TextField(style: GoogleFonts.poppins(color: Colors.black),
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          hint: Text("Himanshu Chaurasia", style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(40.0),
                                          )
                                        ),

                                      ),
                                    ),
                                  Padding(padding: EdgeInsets.only(left: 18),
                                      child: Text("Username", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.7)),)),
                                  Container(
                                    width: 300,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                          colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                          ,center: Alignment.topLeft,radius: 7),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: TextField(style: TextStyle(color: Colors.black),
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                          hint: Text("Himcha", style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(40.0),
                                          )
                                      ),

                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 18),
                                      child: Text("Rollno", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.7)),)),
                                  Container(
                                    width: 300,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                          colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                          ,center: Alignment.topLeft,radius: 7),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: TextField(style: TextStyle(color: Colors.black),
                                      controller: _rollnoController,
                                      decoration: InputDecoration(
                                          hint: Text("2024UIC****", style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(40.0),
                                          )
                                      ),

                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 18),
                                      child: Text("Phone No.", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.7)),)),
                                  Container(
                                    width: 300,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                          colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                          ,center: Alignment.topLeft,radius: 7),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: TextField(style: TextStyle(color: Colors.black),
                                        controller: _phoneController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.phone,color: Colors.black.withOpacity(0.7),),
                                            hint: Text("782*******",
                                                style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                                            border: InputBorder.none
                                        ),

                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      Padding(padding: EdgeInsets.only(left: 18),
                                        child: Text("Dob", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.7)),)),
                                      Padding(padding: EdgeInsets.only(right:17 ),
                                          child: Text("Campus", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.7)),)),
                                  ]
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: 300,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            gradient: RadialGradient(
                                                colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                                ,center: Alignment.topLeft,radius: 7),
                                            borderRadius: BorderRadius.circular(40.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4,left: 18,right: 6),
                                            child: TextField(
                                              controller: _dobController,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  suffixIcon: Icon(Icons.calendar_today,color: Colors.black.withOpacity(0.7),),
                                                  hint: Text("DD/MM/YYYY",
                                                      style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                                                  border: InputBorder.none
                                              ),
                                              onTap: () async {
                                                DateTime? pickedDate = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime(2008),
                                                  firstDate: DateTime(1991),
                                                  lastDate: DateTime(2011),
                                                  initialDatePickerMode: DatePickerMode.year,);
                                                if (pickedDate != null) {
                                                  String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                                  setState(() {
                                                    _dobController.text = formattedDate;
                                                  });
                                                }
                                              }
                                            ),
                                          )
                                      ),),
                                      SizedBox(width: 8),
                                      Expanded(
                                        flex: 1,
                                          child: Container(
                                              width: 300,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                gradient: RadialGradient(
                                                    colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                                    ,center: Alignment.topLeft,radius: 3),
                                                borderRadius: BorderRadius.circular(40.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4,left: 18,right: 6),
                                                child:
                                                DropdownButtonFormField(
                                                      style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  hint: Text("Select",
                                                    style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedCampus,
                                                  items: Varfile.Campus.map((campus) {
                                                    return DropdownMenuItem(
                                                      value: campus,
                                                      child: Text(campus),
                                                    );
                                                  }).toList(),
                                                  validator: (value) {
                                                    if(value == null){
                                                      return "Please select a campus";
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedCampus = value;
                                                    });
                                                  },

                                                ),
                                              )
                                          )
                                      ),
                                    ]
                                  ),
                                  SizedBox(height: 7),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(padding: EdgeInsets.only(left: 18),
                                          child: Text("Batch", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.7)),)),
                                      Padding(padding: EdgeInsets.only(right:17 ),
                                          child: Text("Sem", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.7)),)),
                                      Padding(padding: EdgeInsets.only(right:17 ),
                                          child: Text("Branch", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.7)),)),
                                    ]
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                              width: 300,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                gradient: RadialGradient(
                                                    colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                                    ,center: Alignment.topLeft,radius: 3),
                                                borderRadius: BorderRadius.circular(40.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4,left: 18,right: 6),
                                                child:
                                                DropdownButtonFormField(
                                                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  hint: Text("Select",
                                                    style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedBatch,
                                                  items: Varfile.Batch.map((batch) {
                                                    return DropdownMenuItem(
                                                      value: batch,
                                                      child: Text(batch.toString()),
                                                    );
                                                  }).toList(),
                                                  validator: (value) {
                                                    if(value == null){
                                                      return "Please select a Batch";
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedBatch = value;
                                                    });
                                                  },

                                                ),
                                              )
                                          )
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                              width: 300,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                gradient: RadialGradient(
                                                    colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                                    ,center: Alignment.topLeft,radius: 3),
                                                borderRadius: BorderRadius.circular(40.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4,left: 18,right: 6),
                                                child:
                                                DropdownButtonFormField(
                                                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  hint: Text("Select",
                                                    style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedSem,
                                                  items: Varfile.Sem.map((sem) {
                                                    return DropdownMenuItem(
                                                      value: sem,
                                                      child: Text(sem.toString()),
                                                    );
                                                  }).toList(),
                                                  validator: (value) {
                                                    if(value == null){
                                                      return "Please select a Semester";
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedSem = value;
                                                    });
                                                  },

                                                ),
                                              )
                                          )
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                              width: 300,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                gradient: RadialGradient(
                                                    colors:[Color(0xffBEB8CD), Color(0xffFAF9F8)]
                                                    ,center: Alignment.topLeft,radius: 3),
                                                borderRadius: BorderRadius.circular(40.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4,left: 18,right: 6),
                                                child:
                                                DropdownButtonFormField(
                                                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  hint: Text("Select",
                                                    style: GoogleFonts.poppins(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedBranch,
                                                  items: Varfile.Branch_Name.map((branch) {
                                                    return DropdownMenuItem(
                                                      value: branch,
                                                      child: Text(branch),
                                                    );
                                                  }).toList(),
                                                  validator: (value) {
                                                    if(value == null){
                                                      return "Please select a campus";
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedBranch = value;
                                                    });
                                                  },

                                                ),
                                              )
                                          )
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 7,),
                                  Center(
                                    child: Container(
                                      width: 150,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        gradient: RadialGradient(
                                          colors: [Color(0xffBEB8CD), Color(0xffFAF9F8)],
                                          radius: 4,
                                          center: Alignment.topLeft
                                        )
                                      ),
                                      child: GestureDetector(
                                        onTap:
                                          _handleLogin,
                                        child: Center(
                                          child: Text("Explore",
                                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800,color: Color(0xff191970)),),
                                        )
                                      )
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          )
                      )
                      ),
                      SizedBox(height: 100,),
                      Container(
                      width: 380,
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                          "Disclamier", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.5)),),
                            Text(
                              "Put the Details at your own Risk. The Developer and The Nakshatra is not responsible for your data", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.5)),
                            ),
                          ]
                        )


                      ),

                      SizedBox(height: 100,),

                    ],
                  ),
                  ),
                )
            ]
      )
    );
  }
}

