import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../extra/VarFile.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final docInfo = StaticData.about["document_info"];
    final List sections = StaticData.about["sections"] ?? [];

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
          "Privacy Policy",
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
          Text(
            "Last Updated: ${docInfo["last_updated"]}",
            style: bodyStyle.copyWith(color: Colors.white54, fontStyle: FontStyle.italic),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Divider(height: 1, thickness: 0.5, color: Colors.white24),
          ),
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
                  ..._buildMapData(section["data_collected"], bodyStyle),
                  ..._buildMapData(section["usage_purposes"], bodyStyle),
                  ..._buildMapData(section["contact_details"], bodyStyle),
                  ..._buildListData(section["additional_details"], bodyStyle, isBullet: false),
                  ..._buildListData(section["points"], bodyStyle),
                  ..._buildListData(section["conditions"], bodyStyle),
                  ..._buildListData(section["links"], bodyStyle),
                  ..._buildListData(section["rights"], bodyStyle),
                  ..._buildListData(section["notification_types"], bodyStyle),
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

  List<Widget> _buildMapData(Map<String, dynamic>? data, TextStyle style) {
    if (data == null) return [];
    return data.entries.map((e) => Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: "• ${e.key}: ",
                style: style.copyWith(fontWeight: FontWeight.w700, color: Colors.white)
            ),
            TextSpan(text: "${e.value}", style: style),
          ],
        ),
      ),
    )).toList();
  }

  List<Widget> _buildListData(List<dynamic>? data, TextStyle style, {bool isBullet = true}) {
    if (data == null) return [];
    return data.map((e) => Padding(
      padding: EdgeInsets.only(bottom: 8.0, left: isBullet ? 8.0 : 0),
      child: Text(isBullet ? "• $e" : "$e", style: style),
    )).toList();
  }
}