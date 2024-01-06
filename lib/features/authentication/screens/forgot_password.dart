import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _performResetPassword() {
    
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(title: 'Forgot Password',isBackButton: true,),
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
                  "Enter your email for the verification proccesss, we will send 4 digits code to your email.",
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
          
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
                CustomButtom(
                  title: 'Send OTP',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                    _performResetPassword();
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
