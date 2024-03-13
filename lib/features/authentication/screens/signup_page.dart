import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isMatch = true;

  checkPassword() {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        isMatch = true;
      });
    } else if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        isMatch = false;
      });
    } else {
      setState(() {
        isMatch = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void submit() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (Utils.checkInternetConnection(context)) {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "role": "USER",
        "password": password,
      };
      BlocProvider.of<UserRegisterBloc>(context)
          .add(UserRegisterEvent(userInfo: data));
    }
  }

  clearAllText() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return BlocConsumer<UserRegisterBloc, UserRegisterState>(
      listener: (context, state) {
        if (state is RegistrationCompleted) {
          Utils.showSnackBar(context, state.data["message"], isSuccess: true);
          Navigator.pop(context);

          clearAllText();
        }
        if (state is RegistrationFailed) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          isLoading: context.watch<UserRegisterBloc>().state is AuthLoading,
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
                            "Sign Up",
                            style: TextStyle(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontSize: FontSizeManager.f32,
                                fontWeight: FontWeightManager.semiBold,
                                color: gray900),
                          ),
                        ),
                        const SizedBox(
                          height: HeightManager.h12,
                        ),
                        Center(
                          child: Text(
                            "Create your new account",
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
                          label: 'Full Name',
                          controller: _nameController,
                          textInputType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }

                            return null;
                          },
                          suffixIcon: const Icon(
                            Icons.person_outline_outlined,
                            color: gray400,
                          ),
                          hintText: 'John doe',
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }

                            return null;
                          },
                          onChanged: (p0) {
                            if (_confirmPasswordController.text.isNotEmpty) {
                              checkPassword();
                            }
                          },
                          suffixIcon: hidePassword
                              ? const Icon(
                                  Icons.visibility_off_outlined,
                                  color: gray400,
                                )
                              : const Icon(
                                  Icons.visibility_outlined,
                                  color: gray400,
                                ),
                          obscure: hidePassword,
                          suffixPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          hintText: '********',
                        ),
                        CustomTextfield(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                          textInputType: TextInputType.visiblePassword,
                          suffixIcon: hideConfirmPassword
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
                          onChanged: (p0) {
                            if (_passwordController.text.isNotEmpty) {
                              checkPassword();
                            }
                          },
                          obscure: hideConfirmPassword,
                          suffixPressed: () {
                            setState(() {
                              hideConfirmPassword = !hideConfirmPassword;
                            });
                          },
                          hintText: '********',
                        ),
                        if (!isMatch) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Password does not match',
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: FontSizeManager.f12,
                                fontWeight: FontWeightManager.regular,
                                color: errorColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: HeightManager.h12,
                          )
                        ],
                        CustomButtom(
                          title: 'Register',
                          onPressed: () {
                            if (_formKey.currentState!.validate() && isMatch) {
                              submit();
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
                              "Register as a doctor?",
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: FontSizeManager.f16,
                                fontWeight: FontWeightManager.medium,
                                color: gray800,
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  Navigator.pushNamed(context, 'doc_step1'),
                              child: Text(
                                " Click here",
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
                                  color: gray400),
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
                            Container(
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
                                      0,
                                      0.5,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                googleIcon,
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
                        ),
                        const SizedBox(
                          height: HeightManager.h18,
                        ),
                        Center(
                          child: RichText(
                              textAlign: TextAlign.center,
                              
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "Already have an account?",
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: FontSizeManager.f16,
                                    fontWeight: FontWeightManager.medium,
                                    color: gray800,
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                    },
                                  text: " Login here",
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: FontSizeManager.f16,
                                    fontWeight: FontWeightManager.medium,
                                    color: blue800,
                                  ),
                                ),
                              ])),
                        ),
                        const SizedBox(
                          height: HeightManager.h18,
                        ),
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
