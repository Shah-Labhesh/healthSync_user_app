import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Garib',
              style: TextStyle(
                fontSize: FontSizeManager.f22,
                fontWeight: FontWeightManager.semiBold,
                color: gray900,
                letterSpacing: 0.5,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Good Morning",
              style: textTheme.labelSmall!.copyWith(
                fontSize: FontSizeManager.f14,
                fontWeight: FontWeightManager.semiBold,
                color: gray400,
                letterSpacing: 0.5,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.4),
                      blurRadius: 2,
                      spreadRadius: 1,
                      blurStyle: BlurStyle.outer,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const ImageIcon(
                  AssetImage(
                    notificationIcon,
                  ),
                  size: 30,
                ),
              ),
              Positioned(
                right: 12,
                top: 10,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: const BoxDecoration(
                    color: blue900,
                    shape: BoxShape.circle,
                    
                  ),
                ),
              ),
            ],
          ),
        ),
        
      ],
    );
  }
}
