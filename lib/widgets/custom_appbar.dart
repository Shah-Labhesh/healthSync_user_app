import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class AppBarCustomWithSceenTitle extends StatelessWidget {
  const AppBarCustomWithSceenTitle({
    super.key,
    required this.title,
    this.onPop,
    this.isBackButton = true,
    this.action = const SizedBox(),
  });

  final String title;
  final bool? isBackButton;
  final Widget? action;
  final Function()? onPop;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: white,
      toolbarHeight: 70,
      centerTitle: true,
      elevation: 0,
      leading: GestureDetector(
        onTap: onPop ?? () {
          Navigator.pop(context);
        },
        child: Visibility(
          visible: isBackButton!,
          child: const Icon(
            Icons.arrow_back_ios_outlined,
            color: gray800,
          ),
        ),
      ),
      
      title: Text(
        title,
        style: textTheme.labelMedium!.copyWith(
          letterSpacing: 0.5,
          fontSize: FontSizeManager.f18,
          color: gray800,
        ),
      ),
      actions: [
        action!,
        const SizedBox(
          width: WidthManager.w15,
        ),
      ],
    );
  }
}
