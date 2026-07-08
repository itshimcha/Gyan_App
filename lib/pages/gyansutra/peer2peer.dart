import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/Varfile.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Advicepage extends StatefulWidget {
  const Advicepage({super.key});

  @override
  State<Advicepage> createState() => _AdvicepageState();
}

final storage = FlutterSecureStorage();

class _AdvicepageState extends State<Advicepage> {
  late Future<List<AdviceModel>> futureAdvice;
  String _selectedBranchFilter = 'All';
  String? _userId;

  @override
  void initState() {
    super.initState();
    futureAdvice = getAdvice();
    _initUserId();
  }

  Future<void> _initUserId() async {
    String? email = await storage.read(key: 'email');
    if (email == null || email.isEmpty) {
      email = 'user@gmail.com';
    }
    setState(() {
      _userId = email;
    });
  }

  Future<List<AdviceModel>> getAdvice() async {
    final response = await http.get(Uri.parse(apiConfig.Sr_advise));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<AdviceModel> list = data.map((item) {
        if (item['votedEmails'] is String) {
          try {
            item['votedEmails'] = json.decode(item['votedEmails']);
          } catch (_) {
            item['votedEmails'] = {};
          }
        }
        return AdviceModel.fromJson(item);
      }).toList();
      list.sort((a, b) {
        int scoreA = a.Upvote - a.downvote;
        int scoreB = b.Upvote - b.downvote;
        return scoreB.compareTo(scoreA);
      });

      return list;
    } else {
      throw Exception('Failed to load advice');
    }
  }

  Future<void> submitNewAdvice(AdviceModel newAdvice) async {
    try {
      final requestBody = newAdvice.toJsonAdd();
      requestBody['action'] = 'add';
      final response = await http.post(
        Uri.parse(apiConfig.Sr_advise),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200 || response.statusCode == 302) {
        setState(() {
          futureAdvice = getAdvice();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post advice', style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _castVote(AdviceModel advice, int intendedVote) async {
    if (_userId == null) {
      await _initUserId();
      if (_userId == null) return;
    }
    final userId = _userId!;
    final int currentVote = advice.votedEmails[userId] ?? 0;
    final int newVote = currentVote == intendedVote ? 0 : intendedVote;
    final int prevUpvote = advice.Upvote;
    final int prevDownvote = advice.downvote;
    final Map<String, int> prevVotes = Map<String, int>.from(advice.votedEmails);
    int upDelta = 0, downDelta = 0;
    if (currentVote == 1) upDelta -= 1;
    if (currentVote == -1) downDelta -= 1;
    if (newVote == 1) upDelta += 1;
    if (newVote == -1) downDelta += 1;

    setState(() {
      advice.Upvote += upDelta;
      advice.downvote += downDelta;
      if (newVote == 0) {
        advice.votedEmails.remove(userId);
      } else {
        advice.votedEmails[userId] = newVote;
      }
    });

    try {
      final request = http.Request('POST', Uri.parse(apiConfig.Sr_advise))
        ..followRedirects = false
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode(advice.toJsonVote(newVote, userId));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Server rejected the vote');
      }
    } catch (e) {
      setState(() {
        advice.Upvote = prevUpvote;
        advice.downvote = prevDownvote;
        advice.votedEmails
          ..clear()
          ..addAll(prevVotes);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to vote: sorry for inconvenience', style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showAddAdviceDialog() async {
    final username = await storage.read(key: 'username');

    final subjectController = TextEditingController();
    final adviceController = TextEditingController();
    final usernameController = TextEditingController();

    bool isUsernameEnabled = true;
    if (username != null && username.isNotEmpty) {
      usernameController.text = username;
      isUsernameEnabled = false;
    }

    String selectedFormBranch = Varfile.Branch_Name.isNotEmpty ? Varfile.Branch_Name.first : '';
    final formKey = GlobalKey<FormState>();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Post', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: usernameController,
                        maxLength: 20,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: 'Username',
                            enabled: isUsernameEnabled,
                            labelStyle: GoogleFonts.poppins(color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        validator: (value) => value!.isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: selectedFormBranch,
                        dropdownColor: Colors.black87,
                        menuMaxHeight: 500,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            constraints: BoxConstraints(maxHeight: 300),
                            labelText: 'Branch',
                            labelStyle: GoogleFonts.poppins(color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        items: ['General', ...Varfile.Branch_Name].map((String branch) {
                          return DropdownMenuItem<String>(value: branch, child: Text(branch));
                        }).toList(),
                        onChanged: (newValue) {
                          setDialogState(() => selectedFormBranch = newValue!);
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: subjectController,
                        maxLength: 60,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? 'Subject is required' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: adviceController,
                        maxLength: 1000,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Post/Advice',
                          labelStyle: GoogleFonts.poppins(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty ? 'Advice is required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newAdvice = AdviceModel(
                        rowIndex: 0,
                        Subject: subjectController.text.trim(),
                        Advice: adviceController.text.trim(),
                        Username: usernameController.text.trim(),
                        Branch: selectedFormBranch,
                      );
                      submitNewAdvice(newAdvice);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Post'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:Stack(
        children: [
          Opacity(opacity: 0.6,
          child: Image.asset("assets/images/Firefly.png", fit: BoxFit.cover, width: double.infinity, height: double.infinity,)),
          RefreshIndicator(
            color: Colors.black,
            backgroundColor: Colors.white54,
            onRefresh: () async {
              setState(() => futureAdvice = getAdvice());
              await futureAdvice;
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    },
                        icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white,),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Campus Share",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "Share your ideas and advice",
                                style: GoogleFonts.poppins(
                                  color: Colors.white60,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          PopupMenuButton<String>(
                            initialValue: _selectedBranchFilter,
                            constraints: const BoxConstraints(maxHeight: 420),
                            icon: const Icon(Icons.tune, color: Colors.white),
                            color: Colors.black,
                            onSelected: (String newValue) {
                              setState(() {
                                _selectedBranchFilter = newValue;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return ['All', ...Varfile.Branch_Name].map((String branch) {
                                return PopupMenuItem<String>(
                                  value: branch,
                                  child: Text(
                                    branch,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<AdviceModel>>(
                      future: futureAdvice,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return earthrotate();
                        } else if (snapshot.hasError) {
                          return _buildMessageState(
                            icon: Icons.error_outline,
                            message: 'Something went wrong',
                            showRetry: true,
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _buildMessageState(
                            icon: Icons.forum_outlined,
                            message: 'No advice posted yet.\nBe the first to share some!',
                          );
                        }

                        List<AdviceModel> adviceList = snapshot.data!;
                        if (_selectedBranchFilter != 'All') {
                          adviceList = adviceList.where((a) => a.Branch.toLowerCase() == _selectedBranchFilter.toLowerCase()).toList();
                        }
                        if (adviceList.isEmpty) {
                          return _buildMessageState(
                            icon: Icons.search_off,
                            message: 'No advice matches "$_selectedBranchFilter".',
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                          itemCount: adviceList.length,
                          itemBuilder: (context, index) => _AdviceCard(
                            advice: adviceList[index],
                            userId: _userId,
                            onUpvote: () => _castVote(adviceList[index], 1),
                            onDownvote: () => _castVote(adviceList[index], -1),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    MainTxt(text: "Nakshatra")
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAdviceDialog,
        icon: Icon(Icons.add),
        label: Text('Add'),
      ),
    );
  }
  Widget _buildMessageState({required IconData icon, required String message, bool showRetry = false}) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(icon, size: 56, color: Colors.grey),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 15)),
        if (showRetry) ...[
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => setState(() => futureAdvice = getAdvice()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ),
        ],
      ],
    );
  }
}

class _AdviceCard extends StatelessWidget {
  final AdviceModel advice;
  final String? userId;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const _AdviceCard({
    required this.advice,
    required this.userId,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    final int currentVote = advice.votedEmails[userId] ?? 0;
    final bool isUpvoted = currentVote == 1;
    final bool isDownvoted = currentVote == -1;
    final initials = advice.Username.isNotEmpty ? advice.Username[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:Colors.black54,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(advice.Username, style: GoogleFonts.poppins(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w500)),
              ),
              Container(
                width: 70,
                height: 30,
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40)
                ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(advice.Branch, style: GoogleFonts.poppins(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500)),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Text(advice.Subject, style: GoogleFonts.poppins(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(advice.Advice,
              style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7),fontSize: 12,fontWeight: FontWeight.w500)),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: Icon(isUpvoted? Icons.thumb_up_alt: Icons.thumb_up_alt_outlined , size: 20,
                      color: isUpvoted? Colors.white : Colors.white54),
                  onPressed: onUpvote,
                ),
                SizedBox(
                  width: 28,
                  child: Text(
                    '${advice.score}',
                    textAlign: TextAlign.center,style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: Icon(isDownvoted? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined,
                      color: isDownvoted? Colors.white : Colors.white54, size: 20),
                  onPressed: onDownvote,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}