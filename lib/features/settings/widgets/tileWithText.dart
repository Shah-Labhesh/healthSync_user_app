import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class TileWithText extends StatelessWidget {
  const TileWithText({
    Key? key,
    this.notification,
    required this.text,
    required this.isSwitch,
    this.value,
    this.onChanged,
  }) : super(key: key);

  final bool? notification;
  final String text;
  final bool isSwitch;
  final String? value;
  final Function(bool)? onChanged;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: FontSizeManager.f16,
                  color: gray400,
                  fontWeight: FontWeightManager.light,
                ),
              ),
              Spacer(),
              if (isSwitch == false) ...[
                Text(
                  value!,
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: FontSizeManager.f16,
                    color: gray400,
                    fontWeight: FontWeightManager.light,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.edit,
                  color: gray400,
                  size: 24,
                )
              ] else
              CupertinoSwitch(
                value: notification ?? false,
                onChanged: onChanged,
                activeColor: Color(0xffFDBC0A),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            color: gray200,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
