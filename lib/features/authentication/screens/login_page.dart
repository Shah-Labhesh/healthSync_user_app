import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/routes.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_event.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_state.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _performLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (Utils.checkInternetConnection(context)) {
      context.read<LoginBloc>().add(
        RequestLoginEvent(credentials: {'email': email, 'password': password}));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {};
    if (args.isNotEmpty) {
      context.read<LoginBloc>().add(RequestLoginEvent(
          credentials: {"email": args["email"], "password": args["password"]}));
    }
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          Utils.showSnackBar(context, state.message, isSuccess: false, durationForDisplay: 8);
        }
        if (state is LoginSucess) {
          String? route = Routes.afterLoginRoutes[state.data['role']];
          if (route != null) {
            Utils.showSnackBar(context, 'You have successfully logged in',
                isSuccess: true);
            Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
          }else{
            Utils.showSnackBar(context, 'You can not login with this account',
                isSuccess: false);
          }
        }
        if (state is UserNotVerified) {
          Navigator.pushNamed(context, 'email_verification', arguments: {
            'email': state.data['email'],
            'password': state.data['password']
          });
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900, size: 60),
          isLoading: context.watch<LoginBloc>().state is AuthLoading,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(PaddingManager.paddingMedium),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: HeightManager.h50,
                        ),
                        Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontSize: FontSizeManager.f32,
                              fontWeight: FontWeightManager.semiBold,
                              color: gray900,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: HeightManager.h12,
                        ),
                        Center(
                          child: Text(
                            "Continue with your account",
                            style: TextStyle(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontSize: FontSizeManager.f16,
                              fontWeight: FontWeightManager.regular,
                              color: gray400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: HeightManager.h50,
                        ),
                        CustomTextfield(
                          label: 'Email',
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (EmailValidator.validate(value) == false) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          suffixIcon: const Icon(
                            Icons.email_outlined,
                            color: gray400,
                          ),
                          hintText: 'Johndoe@gmail.com',
                        ),
                        CustomTextfield(
                          label: 'Password',
                          controller: _passwordController,
                          textInputType: TextInputType.visiblePassword,
                          suffixIcon: hidePassword
                              ? const Icon(
                                  Icons.visibility_off_outlined,
                                  color: gray400,
                                )
                              : const Icon(
                                  Icons.visibility_outlined,
                                  color: gray400,
                                ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }

                            return null;
                          },
                          obscure: hidePassword,
                          suffixPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          hintText: '********',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, 'forgot_password'),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: FontSizeManager.f16,
                                  fontWeight: FontWeightManager.medium,
                                  color: blue800,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: HeightManager.h12,
                        ),
                        CustomButtom(
                          title: 'Login',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _performLogin();
                            }
                          },
                        ),
                        const SizedBox(
                          height: HeightManager.h18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not Started Yet?",
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: FontSizeManager.f16,
                                  fontWeight: FontWeightManager.medium,
                                  color: gray800),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, 'signup_screen');
                              },
                              child: Text(
                                " Register Now",
                                style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: FontSizeManager.f16,
                                    fontWeight: FontWeightManager.medium,
                                    color: blue800),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: HeightManager.h18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: w * 0.23,
                              height: HeightManager.h2,
                              color: gray300,
                            ),
                            Text(
                              "Or Continue with",
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: FontSizeManager.f16,
                                fontWeight: FontWeightManager.medium,
                                color: gray400,
                              ),
                            ),
                            Container(
                              width: w * 0.23,
                              height: HeightManager.h2,
                              color: gray300,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: HeightManager.h18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                context
                                    .read<LoginBloc>()
                                    .add(RequestGoogleLoginEvent());
                              },
                              child: Container(
                                height: HeightManager.h90,
                                width: WidthManager.w90,
                                decoration: BoxDecoration(
                                  color: gray100,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: const Offset(
                                          0, 0.5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  googleIcon,
                                ),
                              ),
                            ),
                            // Container(
                            //   height: HeightManager.h105,
                            //   width: WidthManager.w105,
                            //   decoration: BoxDecoration(
                            //     image: const DecorationImage(
                            //       image: AssetImage(
                            //         twitterIcon,
                            //       ),
                            //       fit: BoxFit.cover,
                            //     ),
                            //     borderRadius: BorderRadius.circular(5),
                            //   ),
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
