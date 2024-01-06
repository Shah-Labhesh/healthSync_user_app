import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/constants/theme.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/screens/doc_step1.dart';
import 'package:user_mobile_app/features/authentication/screens/doc_step2.dart';
import 'package:user_mobile_app/features/authentication/screens/doc_step3.dart';
import 'package:user_mobile_app/features/authentication/screens/doc_step4.dart';
import 'package:user_mobile_app/features/authentication/screens/email_verification.dart';
import 'package:user_mobile_app/features/authentication/screens/forgot_password.dart';
import 'package:user_mobile_app/features/authentication/screens/login_page.dart';
import 'package:user_mobile_app/features/authentication/screens/otp_verify.dart';
import 'package:user_mobile_app/features/authentication/screens/qualification_screen.dart';
import 'package:user_mobile_app/features/authentication/screens/reset_password.dart';
import 'package:user_mobile_app/features/authentication/screens/signup_page.dart';
import 'package:user_mobile_app/features/home/screens/home.dart';
import 'package:user_mobile_app/features/onboarding/page_view.dart';
import 'package:user_mobile_app/features/splash_screen/splash_screen.dart';
import 'package:user_mobile_app/.env.dart';
import 'package:user_mobile_app/widgets/google_map_widget.dart';

void main() {
  AppEnvironment.setupEnv(Environment.local);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Sync',
      debugShowCheckedModeBanner: false,
      theme: lighTheme,
      initialRoute: 'user_home_screen',
      routes: {
        'splash_screen': (context) => const SplashScreen(),
        'onboarding_screen': (context) => OnBoardingScreen(),
        'login_screen': (context) => BlocProvider(
              create: (context) => LoginBloc(),
              child: LoginPage(),
            ),
        'signup_screen': (context) => BlocProvider(
              create: (context) => UserRegisterBloc(),
              child: const SignUpPage(),
            ),
        'forgot_password': (context) => ForgotPasswordScreen(),
        'doc_step1': (context) => BlocProvider(
              create: (context) => DocRegisterBloc(),
              child: const DocStep1(),
            ),
        'doc_step2': (context) => BlocProvider(
              create: (context) => DocAddressBloc(),
              child: const DocStep2(),
            ),
        'doc_step3': (context) => BlocProvider(
              create: (context) => DocDetailsBloc(),
              child: const DocStep3(),
            ),
        'doc_step4': (context) => BlocProvider(
              create: (context) => MoreDocDetailsBloc(),
              child: const DocStep4(),
            ),
        'email_verification': (context) => BlocProvider(
              create: (context) => EmailVerificationBloc(),
              child: const EmailVerificationScreen(),
            ),
        'otp_verification': (context) => const OTPVerificationScreen(),
        'reset_password': (context) => const ResetPasswordScreen(),
        'user_home_screen': (context) => const HomeScreen(),
        'map_screen': (context) => const MapWidget(),
        'qualification_screen': (context) => BlocProvider(
              create: (context) => MoreDocDetailsBloc(),
              child: QualificationScreen(),
            ),
      },
    );
  }
}
