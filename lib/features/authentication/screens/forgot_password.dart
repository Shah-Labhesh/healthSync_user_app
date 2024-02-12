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
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_event.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_state.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _performResetPassword(BuildContext context) {
    context.read<PasswordResetBloc>().add(
          RequestForgotPasswordEvent(
            email: _emailController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is PasswordInitiated) {
          Navigator.pushNamed(context, 'otp_verification',
              arguments: _emailController.text.trim());
        }
        if (state is PasswordInitiationFailed) {
          showDialog(
            context: context,
            builder: (context) => Utils.errorDialog(
              context,
              state.message,
              onPressed: () => Navigator.pop(context),
            ),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: context.watch<PasswordResetBloc>().state
              is PasswordInitiateLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900, size: 60),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: 'Forgot Password',
                isBackButton: true,
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: CustomButtom(
                title: 'Send OTP',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _performResetPassword(context);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
