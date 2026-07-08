import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/Varfile.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';


class Schedule extends StatefulWidget {
  final ScrollController? parentScrollController;
  final Function(DateTime)? onEventTap;
  const Schedule({super.key, this.parentScrollController, this.onEventTap});
  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  late ScrollController _scrollController ;
  final GlobalKey _currentMonthKey = GlobalKey();
  bool _hasScrolledToCurrentMonth = false;


  @override
  void initState() {
    super.initState();
    _scrollController = widget.parentScrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.parentScrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  Map<String, Map<int, List<dynamic>>> groupEventsByMonthAndDay(List<dynamic> events) {
    Map<String, Map<int, List<dynamic>>> grouped = {};
    events.sort((a, b) => a.start_date.compareTo(b.start_date));
    for (var event in events) {
      final date = event.start_date;
      final monthKey = "${Varfile.months[date.month - 1]} ${date.year}";
      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = {};
      }
      if (!grouped[monthKey]!.containsKey(date.day)) {
        grouped[monthKey]![date.day] = [];
      }
      grouped[monthKey]![date.day]!.add(event);
    }
    return grouped;
  }

  Future <List<Astro>> _fatchAll() async{
    var response = await http.get(
      Uri.parse(apiConfig.AstroAllEndpoint),
      headers: apiConfig.headers,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((json) => Astro.fromJson(json)).toList();
    } else {
      print("SERVER ERROR BODY: ${response.body}");
      throw Exception('Failed to load user profile: ${response.statusCode}');
    }
  }

  bool _isCurrentMonth(String monthName) {
    final now = DateTime.now();
    final currentMonthStr = "${Varfile.months[now.month - 1]} ${now.year}";
    return monthName.toLowerCase() == currentMonthStr.toLowerCase();
  }

  void _scrollToCurrentMonth() {
    if (_hasScrolledToCurrentMonth) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_currentMonthKey.currentContext != null && mounted) {
          _hasScrolledToCurrentMonth = true;
          Scrollable.ensureVisible(
            _currentMonthKey.currentContext!,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            alignment: 0.4
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fatchAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return earthrotate();
        }if (snapshot.hasError) {
          return Center(
            child: Text(
              "Failed to load data. Try again later.",
              style: TextStyle(color: Colors.red[300]),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No data found.",
              style: TextStyle(color: Colors.red[300]),
            ),
          );
        }
        final groupedData = groupEventsByMonthAndDay(snapshot.data!);
        final monthKeys = groupedData.keys.toList();
        int targetMonthIndex = monthKeys.indexWhere((m) => _isCurrentMonth(m));
        bool hasCurrentMonth = targetMonthIndex != -1;
        if (!hasCurrentMonth && monthKeys.isNotEmpty) {
          targetMonthIndex = monthKeys.length - 1;
        }
        _scrollToCurrentMonth();
        return Column(
          children: [
            ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: monthKeys.length,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemBuilder: (context, monthIndex) {
                final monthName = monthKeys[monthIndex];
                final isTargetMonth = monthIndex == targetMonthIndex;
                final daysMap = groupedData[monthName]!;
                final firstEvent = daysMap.values.first.first;
                final int year = firstEvent.start_date.year;
                final int month = firstEvent.start_date.month;
                int daysInMonth = DateTime(year, month+1, 0).day;
                List<dynamic> layoutPlan = [];
                int? gapStart;
                for (int d = 1; d <= daysInMonth; d++) {
                  if (daysMap.containsKey(d)) {
                    if (gapStart != null) {
                      int gapEnd = d - 1;
                      layoutPlan.add(gapStart == gapEnd ? "$gapStart" : "$gapStart-$gapEnd");
                      gapStart = null;
                    }
                    layoutPlan.add(d);
                  } else {
                    gapStart ??= d;
                  }
                }
                if (gapStart != null) {
                  layoutPlan.add(gapStart == daysInMonth ? "$gapStart" : "$gapStart-$daysInMonth");
                }
                return Column(
                  children: [
                    Column(
                      key: isTargetMonth ? _currentMonthKey : null,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Text(
                            monthName,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...List.generate(layoutPlan.length, (index) {
                          final item = layoutPlan[index];
                          if (item is int){
                            final currentDay =item;
                            if (daysMap.containsKey(currentDay)) {
                              final dayEvents = daysMap[currentDay]!;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: dayEvents.map((event) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                    key: ValueKey(event.id),
                                    child: GestureDetector(
                                      onTap: (){
                                        if (widget.onEventTap != null) {
                                          widget.onEventTap!(event.start_date);
                                        }
                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(event.start_date.day.toString(), style: GoogleFonts.poppins(color: Colors.black,fontSize: 20, fontWeight: FontWeight.w900, height: 0.8)),
                                                Text(Varfile.days[event.start_date.weekday - 1], style: GoogleFonts.poppins(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900)),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              height: 62,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(40),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(event.title ?? "Event Details", maxLines: 1,overflow: TextOverflow.ellipsis,style: GoogleFonts.poppins(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700)),
                                                    Text(event.short_description,maxLines: 1,overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          }
                          if(item is String){
                            return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                child: Row(
                                  children: [
                                    Text(item.toString(), style: GoogleFonts.poppins(color: Colors.white38, fontWeight: FontWeight.w600)),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Divider(
                                        color:Colors.white54,
                                        thickness: 1,
                                        height: 1,
                                      ),
                                    )
                                  ],
                                )
                            );
                          }
                          return const SizedBox.shrink();
                        }
                        ),
                      ],
                    ),
                    if (!hasCurrentMonth && isTargetMonth)
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.white54, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Current month calendar will be added soon. Showing latest available.",
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
