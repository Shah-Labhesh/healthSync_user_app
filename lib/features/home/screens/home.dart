import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_mobile_app/features/account/screens/account_screen.dart';
import 'package:user_mobile_app/features/appointment/screens/appointment_list_screen.dart';
import 'package:user_mobile_app/features/chats/screens/chat_room_screen.dart';
import 'package:user_mobile_app/features/favorite/screens/favorite_screen.dart';
import 'package:user_mobile_app/features/home/screens/home_content.dart';
import 'package:user_mobile_app/widgets/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool loggedInStatus = false;

  @override
  void initState() {
    super.initState();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    MyAppointmentScreen(),
    const MyChatRoomScreen(),
    //  MyFavoriteScreen(),
    AccountScreen(),
  ];
  bool isLoggedIn = false;

  Future<void> _onItemTapped(
    int index,
  ) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isBuiltInit = false;

  @override
  Widget build(BuildContext context) {
    if (!isBuiltInit) {
      _selectedIndex = ModalRoute.of(context)!.settings.arguments as int? ?? 0;
      isBuiltInit = true;
    }

    return WillPopScope(
      onWillPop: () async {
        (_selectedIndex == 0) ? exitApp() : _onItemTapped(0);
        return false;
      },
      child: Scaffold(
        
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavCustom(
          index: _selectedIndex,
          onTap: _onItemTapped,
          isLoggedIn: isLoggedIn,
        ),
      ),
    );
  }

  void exitApp() {
    SystemNavigator.pop();
  }
}
