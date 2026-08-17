// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:gyansutra/extra/Responsive.dart';
// import 'package:gyansutra/extra/backEndSup.dart';
// import 'package:gyansutra/extra/com_wid.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class RecruitmentPage extends StatefulWidget {
//   final int formId;
//   const RecruitmentPage ({super.key, this.formId = 1});
//
//   @override
//   State<RecruitmentPage> createState() => _RecruitmentPageState();
// }
//
// class _RecruitmentPageState extends State<RecruitmentPage> {
//   late Future<FormSection> _getq;
//
//   final Map<int, dynamic> _formAnswers = {};
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   final _secureStorage = const FlutterSecureStorage();
//   bool _isRestoringData = true;
//
//   List<int> _sectionStack = [];
//
//   final Map<int, Question> _allQuestions = {};
//
//   bool _isSubmitting = false;
//   bool _hasSubmitted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _sectionStack = [widget.formId];
//     _getq = Fatchquestion(widget.formId);
//     _loadSavedAnswers();
//   }
//
//   Future<void> _loadSavedAnswers() async {
//     try {
//       final savedData = await _secureStorage.read(key: 'form_answers_${widget.formId}');
//       if (savedData != null) {
//         final Map<String, dynamic> decoded = jsonDecode(savedData);
//         setState(() {
//           _formAnswers.clear();
//           decoded.forEach((key, value) {
//             _formAnswers[int.parse(key)] = value;
//           });
//         });
//       }
//
//       final submittedFlag = await _secureStorage.read(key: 'form_submitted_${widget.formId}');
//       if (submittedFlag == 'true') {
//         setState(() {
//           _hasSubmitted = true;
//         });
//       }
//     } catch (e) {
//       print("Error loading saved answers: $e");
//     } finally {
//       setState(() {
//         _isRestoringData = false;
//       });
//     }
//   }
//
//   Future<void> _saveAnswerToSecureStorage(int id, dynamic value) async {
//     setState(() {
//       _formAnswers[id] = value;
//     });
//
//     final Map<String, dynamic> encodeMap = {};
//     _formAnswers.forEach((k, v) {
//       encodeMap[k.toString()] = v;
//     });
//
//     await _secureStorage.write(
//       key: 'form_answers_${widget.formId}',
//       value: jsonEncode(encodeMap),
//     );
//   }
//
//   Future<FormSection> Fatchquestion(int sectionId) async {
//     try {
//       final response = await http.get(
//         Uri.parse("${apiConfig.baseURl}/api/recruitment/sections/$sectionId/"),
//         headers: apiConfig.headers,
//       );
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = jsonDecode(response.body);
//         return FormSection.fromJson(data);
//       } else {
//         throw Exception("Server returned");
//       }
//     } catch (e) {
//       print("ERROR Occured");
//       rethrow;
//     }
//   }
//
//   int? _resolveNextSectionId(FormSection section) {
//     for (final question in section.questions) {
//       if (question.rules.isNotEmpty) {
//         final answer = _formAnswers[question.id]?.toString();
//         for (final rule in question.rules) {
//           if (rule.triggerValue == answer) {
//             return rule.jumpToSection;
//           }
//         }
//       }
//     }
//     return null;
//   }
//
//   void _handleNext(FormSection currentSection) {
//     if (_isSubmitting) return;
//
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       for (final q in currentSection.questions) {
//         _allQuestions[q.id] = q;
//       }
//
//       final nextSectionId = _resolveNextSectionId(currentSection);
//
//       if (nextSectionId != null) {
//         setState(() {
//           _sectionStack.add(nextSectionId);
//           _getq = Fatchquestion(nextSectionId);
//         });
//       } else {
//         _submitForm();
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill out all required fields.'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     }
//   }
//
//   void _handleBack() {
//     if (_isSubmitting) return;
//     if (_sectionStack.length > 1) {
//       setState(() {
//         _sectionStack.removeLast();
//         _getq = Fatchquestion(_sectionStack.last);
//       });
//     }
//   }
//
//   Future<void> _submitForm() async {
//     setState(() {
//       _isSubmitting = true;
//     });
//
//     try {
//       final List<Map<String, dynamic>> answers = [];
//
//       _formAnswers.forEach((questionId, rawValue) {
//         final question = _allQuestions[questionId];
//         final type = question?.type ?? 'short_text';
//         dynamic value;
//
//         switch (type) {
//           case 'linear_scale':
//             value = rawValue is int
//                 ? rawValue
//                 : int.tryParse(rawValue.toString()) ?? rawValue;
//             break;
//           case 'mcq_checkbox':
//             value = rawValue is List ? List<String>.from(rawValue) : <String>[];
//             break;
//           default:
//             value = rawValue?.toString() ?? '';
//         }
//
//         answers.add({
//           'question': questionId,
//           'value': value,
//         });
//       });
//
//       final response = await http
//           .post(
//         Uri.parse("${apiConfig.baseURl}/api/recruitment/responses/"),
//         headers: apiConfig.headers,
//         body: jsonEncode({
//           'form': widget.formId,
//           'answers': answers,
//         }),
//       )
//           .timeout(const Duration(seconds: 20));
//
//       if (!mounted) return;
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         await _secureStorage.write(key: 'form_submitted_${widget.formId}', value: 'true');
//         await _secureStorage.delete(key: 'form_answers_${widget.formId}');
//
//         setState(() {
//           _hasSubmitted = true;
//         });
//
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (ctx) => AlertDialog(
//             title: const Text('Application Submitted! 🚀'),
//             content: const Text(
//                 'Your responses have been successfully recorded. Best of luck with the recruitments!'),
//             actions: [
//               FilledButton(
//                 onPressed: () => Navigator.pop(ctx),
//                 child: const Text('Done'),
//               ),
//             ],
//           ),
//         );
//       } else {
//         throw Exception('${response.statusCode}: ${response.body}');
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Submission failed: $e'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSubmitting = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isRestoringData) {
//       return Scaffold(
//         body: Stack(
//           children: [
//             StarBg(),
//             Center(child: earthrotate()),
//           ],
//         ),
//       );
//     }
//     if (_hasSubmitted) {
//       return Scaffold(
//         body: Stack(
//           children: [
//             StarBg(),
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Text(
//                   'You have already submitted this form.\nThank you for applying!',
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: Stack(
//           children: [
//             StarBg(),
//             Padding(
//               padding: Responsive.isDesktop(context)
//                   ? const EdgeInsets.symmetric(horizontal: 200)
//                   : const EdgeInsets.all(15.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 50),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text("NAKSHATRA", style: GoogleFonts.poppins(fontSize: 40, letterSpacing: 4, fontWeight: FontWeight.w800, color: Colors.white, height: 1)),
//                       Text("Recruitment Form 2026", style: GoogleFonts.poppins(fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w300, color: Colors.white)),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Expanded(
//                     child: FutureBuilder<FormSection>(
//                       future: _getq,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return Center(child: earthrotate());
//                         } else if (snapshot.hasError) {
//                           return Center(child: No_internet());
//                         } else if (!snapshot.hasData) {
//                           return Center(
//                             child: Text(
//                               'Recruitment Form not open Yet.',
//                               style: GoogleFonts.poppins(color: Colors.white),
//                             ),
//                           );
//                         }
//                         final FormSection q = snapshot.data!;
//                         final questions = q.questions ?? [];
//
//                         return ListView(
//                           padding: const EdgeInsets.only(bottom: 40),
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     q.title,
//                                     style: GoogleFonts.poppins(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     q.description,
//                                     textAlign: TextAlign.center,
//                                     style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             ...questions.map((question) => _buildQuestionWidget(question)),
//
//                             const SizedBox(height: 30),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 40),
//                               child: Row(
//                                 mainAxisAlignment: _sectionStack.length > 1
//                                     ? MainAxisAlignment.spaceBetween
//                                     : MainAxisAlignment.center,
//                                 children: [
//                                   if (_sectionStack.length > 1)
//                                     GestureDetector(
//                                       onTap: _isSubmitting ? null : _handleBack,
//                                       child: Container(
//                                         width: 50,
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white24,
//                                           borderRadius: BorderRadius.circular(50),
//                                           border: Border.all(color: Colors.white54),
//                                         ),
//                                         child: const Icon(Icons.arrow_back_sharp, color: Colors.white),
//                                       ),
//                                     ),
//                                   GestureDetector(
//                                     onTap: _isSubmitting ? null : () => _handleNext(q),
//                                     child: Container(
//                                       width: 170,
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                           color: Colors.white54,
//                                           borderRadius: BorderRadius.circular(50)
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: _isSubmitting
//                                               ? const [
//                                             SizedBox(
//                                               width: 70,
//                                               height: 20,
//                                               child: CircularProgressIndicator(
//                                                 strokeWidth: 2,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ]
//                                               : [
//                                             Text(
//                                               _sectionStack.length > 1 ? 'Submit' : 'Next',
//                                               style: GoogleFonts.poppins(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 5,),
//                                             Icon(_sectionStack.length > 1
//                                                 ? Icons.check
//                                                 : Icons.arrow_forward_sharp),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuestionWidget(Question q) {
//     final int id = q.id;
//     final String type = q.type;
//     final String text = q.text;
//     final bool isRequired = q.isRequired;
//     final Map<String, dynamic> metadata = q.metadata;
//
//     if (type == 'info_box') {
//       return Card(
//         color: Colors.white70,
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(color: Colors.white),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Note:",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w900,
//                   color: Colors.black87,
//                   height: 1.35,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 text,
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                   height: 1.35,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     Widget inputWidget;
//     switch (type) {
//       case 'short_text':
//         inputWidget = TextFormField(
//           initialValue: _formAnswers[id] ?? '',
//           textCapitalization: TextCapitalization.sentences,
//           style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//           decoration: InputDecoration(
//             hintText: 'Valid Answers Only',
//             focusColor: Colors.white,
//             hintStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white30),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(17),
//               borderSide: const BorderSide(color: Colors.blueAccent),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(17),
//               borderSide: const BorderSide(color: Colors.redAccent),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(17),
//               borderSide: const BorderSide(color: Colors.redAccent),
//             ),
//             isDense: true,
//           ),
//           validator: (val) {
//             if (isRequired && (val == null || val.trim().isEmpty)) {
//               return 'This field is required';
//             }
//             return null;
//           },
//           onChanged: (val) {
//             _saveAnswerToSecureStorage(id, val);
//           },
//           onSaved: (val) => _formAnswers[id] = val,
//         );
//         break;
//
//       case 'long_text':
//         inputWidget = TextFormField(
//           initialValue: _formAnswers[id] ?? '',
//           textCapitalization: TextCapitalization.sentences,
//           style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//           maxLines: 6,
//           decoration: InputDecoration(
//             hintText: 'Your answer',
//             hintStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white30),
//             focusColor: Colors.white,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(17),
//               borderSide: const BorderSide(color: Colors.blueAccent),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(17),
//               borderSide: const BorderSide(color: Colors.redAccent),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(17),
//               borderSide: const BorderSide(color: Colors.redAccent),
//             ),
//           ),
//           validator: (val) {
//             if (isRequired && (val == null || val.trim().isEmpty)) {
//               return 'This field is required';
//             }
//             return null;
//           },
//           onChanged: (val) {
//             _saveAnswerToSecureStorage(id, val);
//           },
//           onSaved: (val) => _formAnswers[id] = val,
//         );
//         break;
//
//       case 'dropdown':
//         final options = List<String>.from(metadata['options'] ?? []);
//         inputWidget = DropdownButtonFormField<String>(
//           value: _formAnswers[id],
//           menuMaxHeight: 400,
//           isExpanded: true,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
//             isDense: true,
//           ),
//           dropdownColor: Colors.black,
//           hint: Text('-- Select --', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white38)),
//           style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//           items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
//           validator: (val) => isRequired && (val == null || val.isEmpty)
//               ? 'Please select an option'
//               : null,
//           onChanged: (val) {
//             _saveAnswerToSecureStorage(id, val);
//           },
//         );
//         break;
//
//       case 'mcq_radio':
//         final options = List<String>.from(metadata['options'] ?? []);
//         inputWidget = Column(
//           children: options.map((opt) {
//             return RadioListTile<String>(
//               title: Text(opt, style: GoogleFonts.poppins(fontSize: 15, color: Colors.white70)),
//               minTileHeight: 17,
//               activeColor: Colors.blue,
//               value: opt,
//               groupValue: _formAnswers[id],
//               contentPadding: EdgeInsets.zero,
//               dense: true,
//               onChanged: (val) {
//                 _saveAnswerToSecureStorage(id, val);
//               },
//             );
//           }).toList(),
//         );
//         break;
//
//       case 'mcq_checkbox':
//         final options = List<String>.from(metadata['options'] ?? []);
//         final List<String> selected = List<String>.from(_formAnswers[id] ?? []);
//         inputWidget = Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: options.map((opt) {
//               final isChecked = selected.contains(opt);
//               return CheckboxListTile(
//                 title: Text(opt, style: GoogleFonts.poppins(fontSize: 15, color: Colors.white70)),
//                 value: isChecked,
//                 minTileHeight: 20,
//                 checkColor: Colors.white,
//                 contentPadding: EdgeInsets.zero,
//                 dense: true,
//                 onChanged: (bool? val) {
//                   List<String> updatedSelection = List.from(selected);
//                   if (val == true) {
//                     updatedSelection.add(opt);
//                   } else {
//                     updatedSelection.remove(opt);
//                   }
//                   _saveAnswerToSecureStorage(id, updatedSelection);
//                 },
//               );
//             }).toList(),
//           ),
//         );
//         break;
//
//       case 'linear_scale':
//         final int min = metadata['min'] ?? 1;
//         final int max = metadata['max'] ?? 5;
//         final double currentVal = (_formAnswers[id] as num?)?.toDouble() ?? min.toDouble();
//         inputWidget = Column(
//           children: [
//             Slider(
//               value: currentVal,
//               min: min.toDouble(),
//               max: max.toDouble(),
//               divisions: max - min,
//               label: currentVal.round().toString(),
//               onChanged: (val) {
//                 _saveAnswerToSecureStorage(id, val.round());
//               },
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${metadata['min_label'] ?? min} ($min)',
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//                 Text(
//                   '${metadata['max_label'] ?? max} ($max)',
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             )
//           ],
//         );
//         break;
//
//       default:
//         return const SizedBox.shrink();
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           color: Colors.black54,
//           border: Border.all(color: Colors.white54),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Text.rich(
//                   TextSpan(
//                       text: text,
//                       style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.8)),
//                       children: [
//                         if (isRequired)
//                           TextSpan(
//                             text: '*',
//                             style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
//                           )
//                       ]
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               inputWidget
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }