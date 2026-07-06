import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/Varfile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MonthAstro extends StatefulWidget {
  final int? month;
  final int? year;
  final Function(DateTime)? onDayTap;
  const MonthAstro({super.key, this.month, this.year, this.onDayTap});

  @override
  State<MonthAstro> createState() => _MonthAstroState();
}

class _MonthAstroState extends State<MonthAstro> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, Map<int, List<dynamic>>> _groupedData = {};

  @override
  void initState() {
    super.initState();
    final int year = widget.year ?? DateTime.now().year;
    final int month = widget.month ?? DateTime.now().month;
    _focusedDay = DateTime(year, month, 1);
    _selectedDay = _focusedDay;
    _fetchDataForCurrentMonth();
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

  Future<void> _fetchDataForCurrentMonth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      var response = await http.get(
        Uri.parse("${apiConfig.AstromonthEndpoint}${_focusedDay.month}&year=${_focusedDay.year}"),
        headers: apiConfig.headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final events = responseData.map((json) => Astro.fromJson(json)).toList();
        setState(() {
          _groupedData = groupEventsByMonthAndDay(events);
        });
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }
  bool _isCurrentMonth(String monthName) {
    final now = DateTime.now();
    final currentMonthStr = "${Varfile.months[now.month - 1]} ${now.year}";
    return monthName.toLowerCase() == currentMonthStr.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final currentMonthKey = "${Varfile.months[_focusedDay.month - 1]} ${_focusedDay.year}";
    final daysMap = _groupedData[currentMonthKey] ?? {};
    final daysList = daysMap.keys.toList()..sort();
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20, top:20),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2050, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: GoogleFonts.poppins(color: Colors.black87),
                  weekendTextStyle:GoogleFonts.poppins(color: Colors.black),
                  todayDecoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  markerDecoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                ),
                eventLoader: (day) {
                  final monthStr = "${Varfile.months[day.month - 1]} ${day.year}";
                  if (_groupedData.containsKey(monthStr) && _groupedData[monthStr]!.containsKey(day.day)) {
                    return _groupedData[monthStr]![day.day]!;
                  }
                  return [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  if (widget.onDayTap != null) {
                    widget.onDayTap!(selectedDay);
                  }
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                  _fetchDataForCurrentMonth();
                },
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(color: Colors.black45, blurRadius: 10, spreadRadius: 2)
                    ]
                ),
                child: _isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                )
                    : _errorMessage != null
                    ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red[300])))
                    : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    Expanded(
                      child: daysList.isEmpty ? Center(
                        child: Text("Event will be uploaded soon",
                            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
                      ) : ListView.builder(
                        controller: scrollController,
                        itemCount: daysList.length,
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        itemBuilder: (context, index) {
                          final currentDay = daysList[index];
                          final dayEvents = daysMap[currentDay]!;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: dayEvents.map((event) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                key: ValueKey(event.id),
                                child: GestureDetector(
                                  onTap: () {
                                    if (widget.onDayTap != null) {
                                      widget.onDayTap!(event.start_date);
                                    }
                                  },
                                  child: Container(
                                    height: 65,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(event.start_date.day.toString(),
                                                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900, height: 0.8)),
                                              Text(Varfile.days[event.start_date.weekday - 1],
                                                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900)),
                                            ],
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(event.title ?? "Event Details", maxLines: 1, overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700)),
                                                Text(event.short_description, maxLines: 1, overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}