import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web_gsi;

Widget renderGoogleButton() {
  return (GoogleSignInPlatform.instance as web_gsi.GoogleSignInPlugin).renderButton(
    configuration: web_gsi.GSIButtonConfiguration(minimumWidth: 320,size: web_gsi.GSIButtonSize.large,),
  );
}