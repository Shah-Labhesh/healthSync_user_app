import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackButton = true,
    this.notification= false,
  });

  final String title;
  final bool? isBackButton;
  final bool notification;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 70,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isBackButton!)
            const Icon(
              Icons.arrow_back_ios_outlined,
              color: gray800,
            )
          else
            const SizedBox(
              width: 60,
            ),
          Text(
            title,
            style: textTheme.labelMedium!.copyWith(
              letterSpacing: 0.5,
              fontSize: FontSizeManager.f18,
              color: gray800,
            ),
          ),
          if (notification == false)
            const SizedBox(
              width: 50,
              height: 50,
            )
          else
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
      ),
    );
  }
}
