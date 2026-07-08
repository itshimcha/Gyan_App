import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/pages/signIn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:lottie/lottie.dart';

class UserInput extends StatefulWidget {
  const UserInput({super.key});

  @override
  State<UserInput> createState() => _UserInputState();
}

final Storage = const FlutterSecureStorage();

class _UserInputState extends State<UserInput> {
  int _currentStep = 1;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _rollnoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? selectedBranch;
  int? selectedSem;
  String? selectedCampus;
  int? selectedBatch;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_rollnoController.text.trim().isEmpty) {
      _showError("Please enter your Roll No");
      return;
    }
    if (selectedCampus == null) {
      _showError("Please select your Campus");
      return;
    }
    if (selectedBatch == null) {
      _showError("Please select your Batch");
      return;
    }
    if (selectedSem == null) {
      _showError("Please select your Semester");
      return;
    }
    if (selectedBranch == null) {
      _showError("Please select your Branch");
      return;
    }

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

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final errorMessage = responseData['message'] ??
            'Submission failed. Please check your details.';
        if (mounted) _showError(errorMessage);
      }
    } catch (e) {
      if (mounted) _showError("Network error. Please try again later.");
    }
  }

  Widget _buildPersonal() {
    return Column(
      children: [
        Lottie.asset("assets/lottie/HappySpaceman.json", width: 300, height: 300),
        Container(
          width: 350,
          padding: EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
              color: Colors.black26,
              border: Border.all(color: Colors.white38),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Column(
                children: [
                  Text("Personal Details", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 17),),
                  Text("Let us know you", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.white70, fontSize: 10),),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 20, right: 20),
                    child: TextField(style: GoogleFonts.poppins(color: Colors.white, ),
                      textCapitalization: TextCapitalization.words,
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.white54, size: 20),
                        labelText: "Full Name",
                          labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400,fontSize: 15),
                          hint: Text("Himanshu Chaurasia", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                          ),
                        )
                      ),
                    ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 20, right: 20),
                    child: TextField(style: GoogleFonts.poppins(color: Colors.white),
                        textCapitalization: TextCapitalization.words,
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.assignment_ind, color: Colors.white54, size: 20),
                          labelText: "UserName",
                          labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400,fontSize: 15),
                          hint: Text("Himcha", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 20, right: 20),
                    child: TextField(style: GoogleFonts.poppins(color: Colors.white),
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone, color: Colors.white54, size: 20),
                          prefixText: "91+ ",
                          prefixStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w400,fontSize: 15),
                          labelText: "Phone Number",
                          labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400,fontSize: 15),
                          hint: Text("**********", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 20, right: 20),
                    child: TextField(style: GoogleFonts.poppins(color: Colors.white),
                        controller: _dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.calendar_month, color: Colors.white54, size: 20),
                          labelText: "Date of Birth",
                          labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400,fontSize: 15),
                          hint: Text("DD/MM/YYYY", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                          ),
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
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0, top: 5.0, left: 20, right: 20),
                    child: SizedBox(
                      width: 125,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          elevation: 0,
            ),
            onPressed: () {
              if (_nameController.text.trim().isEmpty) {
                _showError("Please enter your name");
                return;
              }
              if (_usernameController.text.trim().isEmpty) {
                _showError("Please enter a username");
                return;
              }
              if (_phoneController.text.trim().length != 10) {
                _showError("Please enter a valid 10-digit phone number");
                return;
              }
              if (_dobController.text.trim().isEmpty) {
                _showError("Please select your Date of Birth");
                return;
              }
              setState(() {
                _currentStep = 2;
              });
            },
            child: Text("Continue",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcademic() {
    return Column(
      children: [
        Lottie.asset("assets/lottie/Astronautinfo.json", width: 300, height: 300),
        Container(
          width: 350,
          padding: EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
              color: Colors.black26,
              border: Border.all(color: Colors.white38),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Column(
                children: [
                  Text("Acedmic Details", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 17),),
                  Text("Let us know you", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.white70, fontSize: 10),),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 20, right: 20),
                    child: TextField(style: GoogleFonts.poppins(color: Colors.white, ),
                      textCapitalization: TextCapitalization.words,
                      controller: _rollnoController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.pin, color: Colors.white54, size: 20),
                        labelText: "Rollno",
                          labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400,fontSize: 15),
                          hint: Text("202*U******", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w400,) ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                          ),
                        )
                      ),
                    ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 20, right: 20),
                    child: DropdownButtonFormField(
                      dropdownColor: Colors.black,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                      menuMaxHeight: 300,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_tree_rounded, color: Colors.white54, size: 20),
                        labelText: "Branch",
                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      hint: Text("Select",
                        style: GoogleFonts.poppins(color: Colors.white30.withOpacity(0.3), fontWeight: FontWeight.w400),
                      ),
                      value: selectedBranch,
                      items: Varfile.Branch_Name.map((branch) {
                        return DropdownMenuItem(
                          value: branch,
                          child: Text(branch.toString()),
                        );
                      }).toList(),
                      validator: (value) {
                        if(value == null){
                          return "Please select a Branch";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedBranch = value;
                        });
                      },

                    ),
                  ), // Branch
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 20, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                            child: DropdownButtonFormField(
                              dropdownColor: Colors.black,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                              menuMaxHeight: 300,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.menu_book_rounded, color: Colors.white54, size: 20),
                                labelText: "Semester",
                                labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              hint: Text("Select",
                                style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w400),
                              ),
                              value: selectedSem,
                              items: Varfile.Sem.map((Sem) {
                                return DropdownMenuItem(
                                  value: Sem,
                                  child: Text(Sem.toString()),
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

                            ) ),
                        SizedBox(width: 10,),
                        Expanded(
                          flex: 1,
                            child: DropdownButtonFormField(
                              dropdownColor: Colors.black,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                              menuMaxHeight: 300,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.location_city, color: Colors.white54, size: 20),
                                labelText: "Campus",
                                labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              hint: Text("Select",
                                style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w400),
                              ),
                              value: selectedCampus,
                              items: Varfile.Campus.map((campus) {
                                return DropdownMenuItem(
                                  value: campus,
                                  child: Text(campus.toString()),
                                );
                              }).toList(),
                              validator: (value) {
                                if(value == null){
                                  return "Please select a Campus";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedCampus = value;
                                });
                              },

                            ) ),
                      ],
                    ),
                  ), // Semester //campus
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 20, right: 20),
                    child: DropdownButtonFormField(
                      dropdownColor: Colors.black,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                      menuMaxHeight: 300,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.groups_rounded, color: Colors.white54, size: 20),
                        labelText: "Batch",
                        labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      hint: Text("Select",
                        style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w400),
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
                  ), // Batch
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0, top: 5.0, left: 30, right: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 125,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                side: BorderSide(color: Colors.white),
                                elevation: 0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _currentStep = 1;
                                });
                              },
                              child: Text("Back",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: SizedBox(
                            width: 125,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 0,
                              ),
                              onPressed: () {
                                if (_rollnoController.text.trim().length != 11) {
                                  _showError("Please enter correct your Rollno");
                                  return;
                                }
                                if (selectedBranch == null) {
                                  _showError("Please select Branch");
                                  return;
                                }
                                if (selectedSem == null) {
                                  _showError("Please select Semester");
                                  return;
                                }
                                if (selectedCampus == null) {
                                  _showError("Please select Campus");
                                  return;
                                }
                                if (selectedBatch== null) {
                                  _showError("Please select Batch ");
                                  return;
                                }
                                _handleLogin();
                              },
                              child: Text("Explore",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
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
                  Color(0x113B038A),
                  Colors.black
                ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomLeft
                )
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          IconButton(onPressed: (){
                            if (_currentStep == 2) {
                              setState(() {
                                _currentStep = 1;
                              });
                            } else {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const signIn()));}
                          }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),
                          Text("Sign in", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 19),)
                        ],
                      ),
                    ),
                    if (_currentStep == 1)
                      _buildPersonal()
                    else if (_currentStep == 2)
                      _buildAcademic(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}