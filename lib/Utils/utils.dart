import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class Utils {
  
 static showSnackBar(BuildContext context, dynamic message,
      {bool isSuccess = true, int durationForDisplay = 3}) {
    String formattedMessage = '';
    if (message is List<dynamic>) {
      // If the message is a List of Strings, format it as a bulleted list.
      formattedMessage = message.map((item) => "• $item").join('\n');
    } else if (message is String) {
      // If the message is a single String, use it directly.
      formattedMessage = message;
    } else {
      // If the message is neither a List of Strings nor a String, display an error message.
      formattedMessage = "Something went wrong. Please try again later.";
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          formattedMessage,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: white,
                fontSize: 12,
              ),
        ),
        backgroundColor: isSuccess ? successColor : errorColor,
        duration: Duration(seconds: durationForDisplay),
      ),
    );
  }


  static Widget successDialog(
      BuildContext context,  String message,
      {Function()? onPressed}) {
    return SimpleDialog(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        1,
      ),
      contentPadding:
          const EdgeInsets.only(top: 80, left: 30, right: 30, bottom: 20),
      children: [
        Image.asset(
          successIcon,
          height: 100,
        ),
        const SizedBox(
          height: 30,
        ),
        Center(
          child: Text(
            message,
            style: TextStyle(
              color: gray500,
              fontSize: FontSizeManager.f16,
              fontWeight: FontWeightManager.regular,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          color: gray400,
          thickness: 2,
          indent: 10,
          endIndent: 10,
        ),
        InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                'Okay',
                style: TextStyle(
                  color: blue600,
                  fontSize: FontSizeManager.f18,
                  fontWeight: FontWeightManager.medium,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  static Widget errorDialog(
      BuildContext context,  String message,
      {Function()? onPressed}) {
    return SimpleDialog(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        1,
      ),
      contentPadding:
          const EdgeInsets.only(top: 80, left: 30, right: 30, bottom: 20),
      children: [
        Image.asset(
          errorIcon,
          height: 100,
        ),
        const SizedBox(
          height: 30,
        ),
        Center(
          child: Text(
            message,
            style: TextStyle(
              color: gray500,
              fontSize: FontSizeManager.f16,
              fontWeight: FontWeightManager.regular,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          color: gray400,
          thickness: 2,
          indent: 10,
          endIndent: 10,
        ),
        InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                'Okay',
                style: TextStyle(
                  color: blue600,
                  fontSize: FontSizeManager.f18,
                  fontWeight: FontWeightManager.medium,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  logoutDialog(BuildContext context, Function()? onPressed) {
    return AlertDialog(
      title: Text(
        'Logout',
        style: TextStyle(
          color: gray900,
          fontSize: FontSizeManager.f22,
          fontWeight: FontWeightManager.bold,
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
      ),
      content: Text(
        'Are you sure you want to logout?',
        style: TextStyle(
          color: gray700,
          fontSize: FontSizeManager.f16,
          fontWeight: FontWeightManager.medium,
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: green600,
              fontSize: FontSizeManager.f14,
              fontWeight: FontWeightManager.regular,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Log Out',
            style: TextStyle(
              color: red600,
              fontSize: FontSizeManager.f14,
              fontWeight: FontWeightManager.regular,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
        ),
       
      ],
    );
  }
}
