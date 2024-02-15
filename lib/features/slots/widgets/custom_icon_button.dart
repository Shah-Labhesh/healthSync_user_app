// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.size,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final double size;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingManager.p10,
          vertical: PaddingManager.p10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WidthManager.w10),
          border: Border.all(
            color: gray300,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
