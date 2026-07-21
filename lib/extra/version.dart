import 'package:flutter/material.dart';
import 'package:gyansutra/extra/backEndSup.dart';
import 'package:gyansutra/extra/com_wid.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class VersionCheckGate extends StatefulWidget {
  final Widget child;

  const VersionCheckGate({super.key, required this.child});

  @override
  State<VersionCheckGate> createState() => _VersionCheckGateState();
}

class _VersionCheckGateState extends State<VersionCheckGate> {
  final VersionControlService _versionService = VersionControlService();
  bool _isLoading = true;
  VersionCheckResult? _checkResult;

  @override
  void initState() {
    super.initState();
    _performVersionCheck();
  }

  Future<void> _performVersionCheck() async {
    setState(() {
      _isLoading = true;
    });
    final result = await _versionService.checkAppVersion();
    if (mounted) {
      setState(() {
        _checkResult = result;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchDownloadUrl(String? url) async {
    if (url == null || url.isEmpty) {
      if (mounted) {
        CustomSnackbar.show(context, "Download link is not available.");
      }
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        CustomSnackbar.show(context, "Something went wrong .");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Lottie.asset("assets/lottie/loading.json", width: 80, height: 80),
        ),
      );
    }
    if (_checkResult?.status == VersionStatus.unknown) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset("assets/lottie/Nointer.json", width: 300, height: 300),
              const SizedBox(height: 14),
              Text(
                "Connection Issue",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white,fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
               Text(
                "Please check your internet connection and try again.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white54,fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _performVersionCheck,
                child: Text("Retry",
                    style: GoogleFonts.poppins(color: Colors.black,fontSize: 15, fontWeight: FontWeight.w500)

                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_checkResult?.status == VersionStatus.forceUpdate) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset("assets/lottie/Updateapp.json", width: 300, height: 300),
              SizedBox(height: 24),
              Text(
                "Update Required",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white,fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text(
                "This version of the app is no longer supported. Please download the latest update to continue.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white54,fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _launchDownloadUrl(_checkResult?.downloadUrl),
                child: Text("Download Update Now",
                    style: GoogleFonts.poppins(color: Colors.black,fontSize: 15, fontWeight: FontWeight.w500)
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_checkResult?.status == VersionStatus.optionalUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOptionalUpdateDialog(context, _checkResult?.downloadUrl);
      });
    }

    return widget.child;
  }

  void _showOptionalUpdateDialog(BuildContext context, String? url) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: Color(0x22e6e6fa),
                width: 1.5,)
          ),
        title:  Text("Update Available",style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
        content: Text("A new version of Nexus is available. Would you like to update now?",style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Skip"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _launchDownloadUrl(url);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}

