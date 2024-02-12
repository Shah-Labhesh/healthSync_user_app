import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_event.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_state.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class DocStep1 extends StatefulWidget {
  const DocStep1({super.key});

  @override
  State<DocStep1> createState() => _DocStep1State();
}

class _DocStep1State extends State<DocStep1> {
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  FocusNode? _nameFocusNode;
  FocusNode? _emailFocusNode;
  FocusNode? _passwordFocusNode;
  FocusNode? _confirmPasswordFocusNode;

  bool isMatch = true;

  void preformRegister() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    context.read<DocRegisterBloc>().add(RegisterDoctorEvent(credentials: {
          "name": name,
          "email": email,
          "role": "DOCTOR",
          "password": password,
        }));
  }

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return BlocConsumer<DocRegisterBloc, DocAuthState>(
      listener: (context, state) {
        print(state);
        if (state is DocRegisterFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
        if (state is DocRegisterSuccess) {
          Utils.showSnackBar(context, 'Doctor Registered Successfully',
              isSuccess: true);
          Navigator.pushReplacementNamed(context, 'doc_step2',arguments: state.id);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          isLoading:
              context.watch<DocRegisterBloc>().state is DocRegisterLoading,
          child: Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.padding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: HeightManager.h50,
                      ),
                      Row(
                        children: [
                          Text(
                            "Registration",
                            style: TextStyle(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontSize: FontSizeManager.f32,
                              fontWeight: FontWeightManager.semiBold,
                              color: gray900,
                            ),
                          ),
                          Spacer(),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Step ',
                                  style: textTheme.displaySmall!.copyWith(
                                    fontSize: FontSizeManager.f14,
                                    fontWeight: FontWeightManager.regular,
                                    color: gray500,
                                  ),
                                ),
                                TextSpan(
                                  text: '1',
                                  style: textTheme.displaySmall!.copyWith(
                                    fontSize: FontSizeManager.f14,
                                    fontWeight: FontWeightManager.bold,
                                    color: red500,
                                  ),
                                ),
                                TextSpan(
                                  text: '/4',
                                  style: textTheme.displaySmall!.copyWith(
                                    fontSize: FontSizeManager.f14,
                                    fontWeight: FontWeightManager.regular,
                                    color: gray500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: HeightManager.h12,
                      ),
                      Text(
                        "Please Provide Us Your Personal Details To Know You Better",
                        style: TextStyle(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontSize: FontSizeManager.f16,
                          fontWeight: FontWeightManager.regular,
                          color: gray400,
                        ),
                      ),
                      const SizedBox(
                        height: HeightManager.h32,
                      ),
                      CustomTextfield(
                        label: "Full name",
                        hintText: "John Doe",
                        suffixIcon: const Icon(
                          Icons.person_outline_outlined,
                          color: gray400,
                        ),
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      CustomTextfield(
                        label: "Email",
                        hintText: "JohnDoe@gmail.com",
                        suffixIcon: const Icon(
                          Icons.email_outlined,
                          color: gray400,
                        ),
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!EmailValidator.validate(value)) {
                            return "Please enter valid email";
                          }
                          return null;
                        },
                      ),
                      CustomTextfield(
                        label: "Password",
                        hintText: "********",
                        suffixIcon: hidePassword
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                color: gray400,
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                color: gray400,
                              ),
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscure: hidePassword,
                        suffixPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        onChanged: (p0) {
                          checkPassword();
                        },
                        textInputType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter strong password";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters";
                          }
                          return null;
                        },
                      ),
                      CustomTextfield(
                        label: "Confirm Password",
                        hintText: "********",
                        suffixIcon: hideConfirmPassword
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                color: gray400,
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                color: gray400,
                              ),
                        textInputType: TextInputType.visiblePassword,
                        obscure: hideConfirmPassword,
                        focusNode: _confirmPasswordFocusNode,
                        suffixPressed: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        },
                        onChanged: (p0) {
                          checkPassword();
                        },
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter strong password";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters";
                          }
                          return null;
                        },
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
                      const SizedBox(
                        height: HeightManager.h32,
                      ),
                      CustomButtom(
                          title: "Register",
                          onPressed: () {
                            if (_formKey.currentState!.validate() && isMatch) {
                              preformRegister();
                            }
                          }),
                      const SizedBox(
                        height: HeightManager.h50,
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ),
        );
      },
    );
  }
}
