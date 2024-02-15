import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class ExpandableContainer extends StatelessWidget {
  const ExpandableContainer({
    required this.child,
    required this.title,
    super.key,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
        controller: ExpandableController(initialExpanded: true),
        theme: const ExpandableThemeData(
          animationDuration: Duration(milliseconds: 600),
          fadeCurve: Curves.easeInOutCubic,
          iconColor: gray50,
          iconPadding: EdgeInsets.only(
            top: PaddingManager.p12,
            right: PaddingManager.p10,
          ),
          iconSize: 30,
          iconPlacement: ExpandablePanelIconPlacement.right,
        ),
        header: Container(
          padding: const EdgeInsets.symmetric(horizontal: PaddingManager.p10, vertical: PaddingManager.p10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: FontSizeManager.f20,
              fontWeight: FontWeightManager.semiBold,
              color: gray50,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
        ),
        collapsed: const SizedBox(),
        expanded: child);
  }
}
