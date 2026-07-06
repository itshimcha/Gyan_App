import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../extra/VarFile.dart';

class CookiePolicyScreen extends StatelessWidget {
  const CookiePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = StaticData.cookiePolicy;
    final List sections = data["sections"] ?? [];

    final headlineStyle = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.2,
    );

    final bodyStyle = GoogleFonts.poppins(
      fontSize: 10,
      height: 1.4,
      color: Colors.white.withOpacity(0.9),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          data["title"],
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        children: [
          ...sections.map((section) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${section["id"]}. ${section["title"]}", style: headlineStyle),
                  const SizedBox(height: 8),
                  if (section["intro_text"] != null) ...[
                    Text(section["intro_text"], style: bodyStyle),
                    const SizedBox(height: 10),
                  ],
                  if (section["content"] != null) ...[
                    for (var text in section["content"]) ...[
                      Text(text.toString(), style: bodyStyle),
                      const SizedBox(height: 10),
                    ]
                  ],
                  if (section["sub_heading"] != null) ...[
                    Text(section["sub_heading"], style: bodyStyle.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 8),
                  ],
                  if (section["table"] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Table(
                        border: TableBorder.all(color: Colors.white24, width: 0.5),
                        columnWidths: const {
                          0: FlexColumnWidth(1.2),
                          1: FlexColumnWidth(2.0),
                          2: FlexColumnWidth(1.0),
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Colors.white10),
                            children: [
                              for (var header in section["table"]["headers"])
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    header,
                                    style: bodyStyle.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                          for (var row in section["table"]["rows"])
                            TableRow(
                              children: [
                                for (var cell in row)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      cell,
                                      style: bodyStyle,
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ..._buildListData(section["points"], bodyStyle),
                  ..._buildListData(section["contact_details"], bodyStyle, isBullet: false),
                  if (section["sub_sections"] != null) ...[
                    for (var sub in section["sub_sections"]) ...[
                      const SizedBox(height: 6),
                      Text(sub["title"], style: bodyStyle.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(sub["description"], style: bodyStyle),
                      const SizedBox(height: 8),
                      if (sub["items"] != null) ..._buildListData(sub["items"], bodyStyle),
                      const SizedBox(height: 6),
                    ]
                  ],
                  if (section["closing_text"] != null) ...[
                    const SizedBox(height: 6),
                    Text(section["closing_text"], style: bodyStyle),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<Widget> _buildListData(List<dynamic>? data, TextStyle style, {bool isBullet = true}) {
    if (data == null) return [];
    return data.map((e) => Padding(
      padding: EdgeInsets.only(bottom: 8.0, left: isBullet ? 8.0 : 0),
      child: Text(isBullet ? "• $e" : "$e", style: style),
    )).toList();
  }
}