import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

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
        horizontal: PaddingManager.p10,
        vertical: PaddingManager.p12,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: FontSizeManager.f16,
                    color: gray400,
                    fontWeight: FontWeightManager.light,
                  ),
                ),
              ),
              if (isSwitch == false) ...[
                Expanded(
                  child: Text(
                    value!,
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: FontSizeManager.f16,
                      color: gray400,
                      fontWeight: FontWeightManager.light,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(
                  width: WidthManager.w5,
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
                activeColor: const Color(0xffFDBC0A),
              ),
            ],
          ),
          const SizedBox(
            height: HeightManager.h10,
          ),
          const Divider(
            color: gray200,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
