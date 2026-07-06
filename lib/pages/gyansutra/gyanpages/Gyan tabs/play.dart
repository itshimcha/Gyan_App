import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class YoutubePlaylistWebView extends StatefulWidget {
  final String playlistUrl;
  const YoutubePlaylistWebView({super.key, required this.playlistUrl});

  @override
  State<YoutubePlaylistWebView> createState() => _YoutubePlaylistWebViewState();
}

class _YoutubePlaylistWebViewState extends State<YoutubePlaylistWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            _controller.runJavaScript('''
              if (!document.getElementById('gyansutra-hide-nav')) {
                var style = document.createElement('style');
                style.id = 'gyansutra-hide-nav';
                style.innerHTML = `
                  ytm-header-bar, 
                  .mobile-topbar-header, 
                  #header-bar,
                  .header-bar { 
                    display: none !important; 
                  }
                  ytm-app, #app {
                    padding-top: 0 !important;
                    margin-top: 0 !important;
                  }
                `;
                document.head.appendChild(style);
              }
            ''');
          },
          onPageFinished: (String url) {
            _controller.runJavaScript(r'''
              (function() {
                // 1. INJECT UNBREAKABLE CSS
                try {
                  var style = document.createElement('style');
                  style.type = 'text/css';
                  style.innerHTML = `
                    /* Nuke the top bar and bottom nav completely */
                    ytm-mobile-topbar-renderer,
                    ytm-pivot-bar-renderer,
                    .open-app-banner,
                    ytm-promoted-sparkles-web-renderer { 
                      display: none !important; 
                      visibility: hidden !important;
                      height: 0 !important;
                      opacity: 0 !important;
                    }
                  `;
                  document.head.appendChild(style);
                } catch (e) {
                  console.log("CSS Error: ", e);
                }
                setInterval(function() {
                  try {
                    // Forcefully hide the main bars directly via JS
                    var topBar = document.querySelector('ytm-mobile-topbar-renderer');
                    if (topBar) topBar.style.display = 'none';

                    var bottomNav = document.querySelector('ytm-pivot-bar-renderer');
                    if (bottomNav) bottomNav.style.display = 'none';

                    // Hunt down the specific 'X' button in the playlist drawer
                    // We search EVERY button to see if its label contains "close" or "collapse"
                    var buttons = document.querySelectorAll('button');
                    for (var i = 0; i < buttons.length; i++) {
                      var label = buttons[i].getAttribute('aria-label');
                      if (label) {
                        var lowerLabel = label.toLowerCase();
                        if (lowerLabel.includes('close') || lowerLabel.includes('collapse')) {
                          buttons[i].style.display = 'none';
                        }
                      }
                    }
                  } catch (e) {
                    console.log("Loop Error: ", e);
                  }
                }, 400);
              })();
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.playlistUrl));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Playlist"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}