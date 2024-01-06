import 'package:flutter/material.dart';
import 'package:user_mobile_app/Utils/routes.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_icon.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeScreen();
  }

  changeScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isFirstTime = await SharedUtils.isFirstTime();
    String token = await SharedUtils.getToken();
    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, 'onboarding_screen');
      SharedUtils.setFirstTime();
    } else {
      if (token.isNotEmpty) {
        String role = await SharedUtils.getRole();
        Navigator.pushReplacementNamed(context, Routes.afterLoginRoutes[role]!);
      } else
      Navigator.pushReplacementNamed(context, 'login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Image.asset(
          APP_LOGO,
          width: w * 0.6,
        ),
      ),
    );
  }
}
