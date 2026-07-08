import 'package:flutter/material.dart';
import 'package:gyansutra/extra/VarFile.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:gyansutra/pages/Homepage.dart';
import 'package:gyansutra/pages/Nakshatra/Astro/day.dart';
import 'package:gyansutra/pages/Nakshatra/Astro/month.dart';
import 'package:gyansutra/pages/Nakshatra/Astro/schedule.dart';
import 'package:gyansutra/pages/USER/drawer.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';



class Astrocalender extends StatefulWidget {
  final int? year;
  final int? month;
  final DateTime? Date;
  const Astrocalender({super.key, this.Date, this.month, this.year});

  @override
  State<Astrocalender> createState() => _AstrocalenderState();
}

class _AstrocalenderState extends State<Astrocalender> {
  late String _currentView;
  DateTime? _selectedDate;
  int? _selectedMonth;
  int? _selectedYear;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.Date;
    _selectedMonth = widget.month;
    _selectedYear = widget.year;
    _currentView = widget.Date != null ? 'Day' : 'Schedule';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildCalendarView() {
    switch (_currentView) {
      case 'Month':
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: MonthAstro(
              month: _selectedMonth ?? DateTime.now().month,
              year: _selectedYear ?? DateTime.now().year,
              onDayTap: (DateTime tappedDate) {
                setState(() {
                  _selectedDate = tappedDate;
                  _currentView = 'Day';
                });
              },
            ),
          ),
        );
      case 'Day':
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: DayAstro(Date: _selectedDate ?? DateTime.now()),
          ),
        );
      case 'Schedule':
      default:
        return Schedule(
          onEventTap: (DateTime tappedDate){
            setState(() {
              _selectedDate = tappedDate;
              _currentView ='Day';
            }
            );

          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.08,
          left: MediaQuery.of(context).size.width * 0.03,
        ),
        child: SpeedDial(
          icon: Icons.calendar_view_month_outlined,
          activeIcon: Icons.close,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          spacing: 12,
          spaceBetweenChildren: 8,
          children: [
            SpeedDialChild(
              child: Icon(Icons.calendar_month, color: Colors.black),
              backgroundColor: Colors.white,
              label: 'Month',
              onTap: () {
                setState(() {
                  _currentView = 'Month';
                });
                _scrollToTop();
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.calendar_view_day, color: Colors.black),
              backgroundColor: Colors.white,
              label: 'Day',
              onTap: () {
                setState(() {
                  _currentView = 'Day';
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(0.0);
                  }
                });
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.view_agenda, color: Colors.black),
              backgroundColor: Colors.white,
              label: 'Schedule',
              onTap: () {
                setState(() {
                  _currentView = 'Schedule';
                });
              },
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.black
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              key: ValueKey(_currentView),
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 50),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false);
                      },
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            shape: BoxShape.circle
                          ),
                          child: Center(child: Icon(Icons.home,color: Colors.black,))),
                    )
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AstroCalender", style:
                        GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Color(0xffe6e6fa)
                        ),),
                        Text("Never miss an Event",
                            style:
                            GoogleFonts.poppins(
                                height: 0.7,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0x88e6e6fa)))
                      ],
                    ),
                  ),
                  _buildCalendarView(),
                  MainTxt(text: "AstroCalender")
                ],
              ),
            )
          )
        ]
      )
    );
  }
}