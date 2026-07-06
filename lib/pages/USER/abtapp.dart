import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../extra/VarFile.dart';

class AboutGyanScreen extends StatelessWidget {
  const AboutGyanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = StaticData.aboutApp;

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
          ...List<String>.from(data["introduction"]).map(
                (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(paragraph, style: bodyStyle),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(height: 1, thickness: 0.5, color: Colors.white24),
          ),
          Text(data["dual_purpose"]["title"], style: headlineStyle),
          const SizedBox(height: 8),
          Text(data["dual_purpose"]["content"], style: bodyStyle),
          const SizedBox(height: 20),
          Text(data["features_title"], style: headlineStyle),
          const SizedBox(height: 14),
          ...List<Map<String, dynamic>>.from(data["features"]).map(
                (feature) => _buildSimpleFeature(feature, headlineStyle, bodyStyle),
          ),
          const SizedBox(height: 4),
          _buildSimpleDeveloperNote(data["developer_note"], headlineStyle, bodyStyle),
          const SizedBox(height: 20),
          Text(data["conclusion"]["title"], style: headlineStyle),
          const SizedBox(height: 8),
          Text(data["conclusion"]["content"], style: bodyStyle),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSimpleFeature(Map<String, dynamic> feature, TextStyle headline, TextStyle body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feature["title"],
            style: headline.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            feature["description"],
            style: body.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleDeveloperNote(Map<String, dynamic> devNote, TextStyle headline, TextStyle body) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            devNote["title"],
            style: headline.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 8),
          Text(
            devNote["context"],
            style: body,
          ),
          const SizedBox(height: 10),
          Text(
            devNote["quote"],
            style: body.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "- ${devNote["author"]}",
                  style: body.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                ),
                Text(
                  devNote["role"],
                  style: body.copyWith(fontSize: 8, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}