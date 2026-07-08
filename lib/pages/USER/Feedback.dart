import 'package:flutter/material.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:http/http.dart'as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';


class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollnoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String? selectedtype;

  bool _isLoading = false;

  void _showDialog() {
    showDialog(
      context: context,
      // barrierDismissible prevents users from closing the dialog by tapping outside it
      barrierDismissible: false,
      builder: (BuildContext context) {
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
            content: Text("Successfully Submitted", style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12, color: Color(0xffe6e6fa)),),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xff232323),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("OK",style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Color(0xffe6e6fa)))),
            ]
        );
      },
    );
  }
  Future <void> submitFeedback() async {
    if (_nameController.text.trim().isEmpty ||
        _rollnoController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _feedbackController.text.trim().isEmpty ||
        selectedtype == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the details before submitting."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final Map formData = {
      "entry.983625159": _nameController.text,
      "entry.997569354": _rollnoController.text,
      "entry.730524261": _emailController.text,
      "entry.1466128427": selectedtype,
      "entry.148925937": _feedbackController.text
    };
    try {
      final response = await http.post(
        Uri.parse(apiConfig.FeedbackFormLink),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: formData,
      );
      await Future.delayed(Duration(seconds: 1));
      if (response.statusCode == 200) {
        if(mounted){
          _showDialog();
        }
        _nameController.clear();
        _rollnoController.clear();
        _emailController.clear();
        selectedtype = null;
        _feedbackController.clear();
      } else {
        print("Failed: Status ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xffBEB8CD),
                      Color(0xffFAF9F8)
                    ], begin: Alignment.topCenter,
                        end: Alignment.bottomLeft
                    )
                ),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20,)),
                          ),
                          Column(
                            children: [
                              Text(
                                " Feedback Form", style: GoogleFonts.alegreya(
                                  fontWeight: FontWeight.w800,
                                  height: 0.8,
                                  fontSize: 40,
                                  color: Colors.black),
                              ),
                              SizedBox(height: 3,),
                              Text(
                                "Fill the details", style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                          Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                  colors: [
                                    Color(0xffBEB8CD),
                                    Color(0xffFAF9F8)
                                  ],
                                  center: Alignment.topLeft,
                                  radius: 7),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              ),
                              controller: _nameController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  focusColor: Colors.blue,
                                  labelText: "Name",
                                  hintText: "Full_Name",
                                  hintStyle: GoogleFonts.poppins(color: Colors.black26, fontWeight: FontWeight.w400),
                                  labelStyle: GoogleFonts.poppins(color: Colors.black54),
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(color: Colors.white)
                                  )
                              ),

                            ),
                          ), // name
                          Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                  colors: [
                                    Color(0xffBEB8CD),
                                    Color(0xffFAF9F8)
                                  ],
                                  center: Alignment.topLeft,
                                  radius: 7),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              ),
                              controller: _rollnoController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  focusColor: Colors.blue,
                                  labelText: "Rollno.",
                                  hintText: "Correct Rollno.",
                                  hintStyle: GoogleFonts.poppins(color: Colors.black26, fontWeight: FontWeight.w400),
                                  labelStyle: GoogleFonts.poppins(color: Colors.black54),
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(color: Colors.white)
                                  )
                              ),

                            ),
                          ), // rollno
                          Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                  colors: [
                                    Color(0xffBEB8CD),
                                    Color(0xffFAF9F8)
                                  ],
                                  center: Alignment.topLeft,
                                  radius: 7),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                fontWeight: FontWeight.w500
                              ),
                              controller: _emailController,
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                  focusColor: Colors.blue,
                                  labelText: "Email",
                                  hintText: "University Email",
                                  hintStyle: GoogleFonts.poppins(color: Colors.black26, fontWeight: FontWeight.w400),
                                  labelStyle: GoogleFonts.poppins(color: Colors.black54),
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(color: Colors.white)
                                  )
                              ),

                            ),
                          ), // email
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius
                                  .circular(4.0),
                            ),
                            width: 300,
                            padding: const EdgeInsets.only(left: 18, top: 15, bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Feedback Type",style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.white)
                                ),
                                SizedBox(height: 10,),
                                FormField<dynamic>(
                                  initialValue: selectedtype ?? "General",
                                  validator: (value) {
                                    if (selectedtype == null) {
                                      return "Please select a feedback type";
                                    }
                                    return null;
                                  },
                                  builder: (FormFieldState<dynamic> state) {
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            spacing: 20.0,
                                            runSpacing: 12.0,
                                            children: Varfile.type.map((type) {
                                              bool isSelected = selectedtype == type;
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedtype = type;
                                                  });
                                                  state.didChange(type);
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: isSelected
                                                            ? const RadialGradient(
                                                            colors: [Color(0xffBEB8CD), Color(0xffFAF9F8)],
                                                            center: Alignment.topLeft,
                                                            radius: 2)
                                                            : null,
                                                        color: isSelected ? null : Colors.transparent,
                                                        border: Border.all(
                                                          color: isSelected
                                                              ? Colors.transparent
                                                              : Colors.white.withOpacity(0.5),
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      type.toString(),
                                                      style: GoogleFonts.poppins(
                                                        color: isSelected
                                                            ? Colors.white
                                                            : Colors.white.withOpacity(0.7),
                                                        fontWeight: isSelected
                                                            ? FontWeight.w500
                                                            : FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        if (state.hasError)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Text(
                                              state.errorText!,
                                              style: TextStyle(
                                                color: Colors.redAccent.shade200,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 300,
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                  colors: [
                                    Color(0xffBEB8CD),
                                    Color(0xffFAF9F8)
                                  ],
                                  center: Alignment.topLeft,
                                  radius: 7),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              maxLines: 200,
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              ),
                              controller: _feedbackController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  focusColor: Colors.blue,
                                  labelText: "Feedback",
                                  hintText: "Brief",
                                  hintStyle: GoogleFonts.poppins(color: Colors.black26, fontWeight: FontWeight.w400),
                                  labelStyle: GoogleFonts.poppins(color: Colors.black54),
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(color: Colors.white)
                                  )
                              ),

                            ),
                          ),
                          ElevatedButton(
                              onPressed: _isLoading ? null : submitFeedback,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent,
                                disabledBackgroundColor: Colors.grey.shade400,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),),
                              child: _isLoading ? earthrotate(): Text("Submit", style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              )
                          ),
                        ]
                    )
                ),
              )
            ]
        )
    );
  }
}
