import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isMatch = true;

  void checkPassword() {
    if (_passwordController.text == _confirmPasswordController.text) {
      setState(() {
        isMatch = true;
      });
    } else {
      setState(() {
        isMatch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'Reset Password',
          isBackButton: true,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Set the new password for your account so you can login and access all the features.",
                  style: TextStyle(
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    fontSize: FontSizeManager.f16,
                    fontWeight: FontWeightManager.regular,
                    color: gray500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomTextfield(
                  label: '',
                  bottomPadding: 16,
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
                  hintText: 'New Password',
                ),
                CustomTextfield(
                  label: '',
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
                  hintText: 'Re-enter Password',
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
                const Spacer(),
                CustomButtom(
                  title: 'Reset Password',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // _performResetPassword();
                    }
                  },
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
