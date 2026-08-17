import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../extra/Responsive.dart';
import '../../extra/VarFile.dart';

class PwaInstallGuideScreen extends StatelessWidget {
  const PwaInstallGuideScreen({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $urlString");
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = StaticData.pwaInstallGuide;
    final isDesktop = Responsive.isDesktop(context);

    final headlineStyle = GoogleFonts.poppins(
      fontSize: isDesktop ? 22 : 14,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.2,
    );

    final subHeadlineStyle = GoogleFonts.poppins(
      fontSize: isDesktop ? 16 : 12,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    final bodyStyle = GoogleFonts.poppins(
      fontSize: isDesktop ? 13 : 10,
      height: 1.4,
      color: Colors.white.withOpacity(0.9),
    );

    final appInfo = data["app_info"] as Map<String, dynamic>;
    final videoUrl = appInfo["youtube_tutorial_url"] as String? ?? "";
    final webUrl = appInfo["web_url"] as String? ?? "";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          data["header"]["title"],
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: isDesktop ? 26 : 18,
            fontWeight: isDesktop ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 300 : 0),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          children: [
            // Subtitle / Intro
            Text(
              data["header"]["subtitle"],
              style: bodyStyle,
            ),
            const SizedBox(height: 14),

            // Action Buttons: Quick Launch & Watch Tutorial
            Row(
              children: [
                if (webUrl.isNotEmpty)
                  Expanded(
                    child: _buildActionLinkButton(
                      icon: Icons.open_in_browser_rounded,
                      label: "Open Web App",
                      color: Colors.cyanAccent,
                      onTap: () => _launchURL(webUrl),
                      bodyStyle: bodyStyle,
                    ),
                  ),
                if (webUrl.isNotEmpty && videoUrl.isNotEmpty)
                  const SizedBox(width: 8),
                if (videoUrl.isNotEmpty)
                  Expanded(
                    child: _buildActionLinkButton(
                      icon: Icons.play_circle_fill_rounded,
                      label: "Watch Video",
                      color: Colors.redAccent,
                      onTap: () => _launchURL(videoUrl),
                      bodyStyle: bodyStyle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Prerequisites Box
            _buildPrerequisitesCard(
              List<String>.from(data["header"]["prerequisites"]),
              subHeadlineStyle,
              bodyStyle,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Divider(height: 1, thickness: 0.5, color: Colors.white24),
            ),

            // Section: Installation Steps
            Text("Installation Steps", style: headlineStyle),
            const SizedBox(height: 12),

            ...List<Map<String, dynamic>>.from(data["steps"]).map(
                  (step) => _buildStepCard(step, headlineStyle, bodyStyle, isDesktop),
            ),

            const SizedBox(height: 10),

            // Section: Troubleshooting / Help
            Text(data["troubleshooting"]["title"], style: headlineStyle),
            const SizedBox(height: 12),

            ...List<Map<String, dynamic>>.from(data["troubleshooting"]["items"]).map(
                  (item) => _buildTroubleshootingItem(item, subHeadlineStyle, bodyStyle),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildActionLinkButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required TextStyle bodyStyle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrerequisitesCard(
      List<String> prerequisites,
      TextStyle headerStyle,
      TextStyle bodyStyle,
      ) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amberAccent, size: 16),
              const SizedBox(width: 6),
              Text(
                "Important Note",
                style: headerStyle.copyWith(
                  fontSize: 11,
                  color: Colors.amberAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...prerequisites.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ", style: bodyStyle.copyWith(color: Colors.white70)),
                  Expanded(
                    child: Text(
                      item,
                      style: bodyStyle.copyWith(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(
      Map<String, dynamic> step,
      TextStyle headline,
      TextStyle body,
      bool isDesktop,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Number & Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${step["step_number"]}",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  step["title"],
                  style: headline.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            step["description"],
            style: body,
          ),
          const SizedBox(height: 8),

          // Action / Callout Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.touch_app_outlined, color: Colors.cyanAccent, size: 14),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    step["callout_text"],
                    style: body.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Optional Tip
          if (step["tip"] != null && (step["tip"] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Tip: ${step["tip"]}",
              style: body.copyWith(
                fontSize: 9,
                color: Colors.white54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTroubleshootingItem(
      Map<String, dynamic> item,
      TextStyle header,
      TextStyle body,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q: ${item["issue"]}",
            style: header.copyWith(fontSize: 11, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            item["solution"],
            style: body.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}