import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class BottomNavCustom extends StatefulWidget {
  const BottomNavCustom({
    required this.index,
    required this.onTap,
    required this.isLoggedIn,
    super.key,
  });

  final int index;
  final Function(int)? onTap;
  final bool isLoggedIn;

  @override
  State<BottomNavCustom> createState() => _BottomNavCustomState();
}

class _BottomNavCustomState extends State<BottomNavCustom> {
  late int selectedIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: HeightManager.h73,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: blue600,
        unselectedItemColor: gray500,
        currentIndex: widget.index,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeightManager.regular,
          fontSize: 0,
        ),
        selectedIconTheme: const IconThemeData(
          size: 30,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 30,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeightManager.regular,
          fontSize: 0,
        ),
        onTap: (value) {
          widget.onTap?.call(value);
          setState(() {
            selectedIndex = widget.isLoggedIn ? value : 0;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                homeIcon,
              ),
              size: 28,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                appointmentIcon,
              ),
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                chatIcon,
              ),
              size: 28,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                heartIcon,
              ),
              size: 28,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                profileIcon,
              ),
              size: 25,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
