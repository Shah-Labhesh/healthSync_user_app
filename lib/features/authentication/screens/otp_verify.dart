import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_event.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_state.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  // timer for resend otp
  Timer? _timer;

  int _start = 59;

  String? otp;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is PasswordResetOtpResent) {
          Utils.showSnackBar(
            context,
            "OTP resent successfully",
            isSuccess: true,
          );
        }
        if (state is PasswordResetOtpResendFailed) {
          showDialog(
            context: context,
            builder: (context) => Utils.errorDialog(
              context,
              state.message,
              onPressed: () => Navigator.pop(context),
            ),
          );
        }
        if (state is PasswordVerificationFailed) {
          showDialog(
            context: context,
            builder: (context) => Utils.errorDialog(
              context,
              state.message,
              onPressed: () => Navigator.pop(context),
            ),
          );
        }
        if (state is PasswordVerified) {
          Navigator.pushNamed(context, 'reset_password',
              arguments: {'email': args, 'otp': otp});
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: context.watch<PasswordResetBloc>().state
                  is PasswordResendOtpLoading ||
              context.watch<PasswordResetBloc>().state is VerifyPasswordLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900, size: 60),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBarCustomWithSceenTitle(
                title: "OTP Verification",
                isBackButton: true,
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "Enter the 4 digits code that you received on your email.",
                          style: textTheme.displaySmall!.copyWith(
                            fontSize: FontSizeManager.f16,
                            fontWeight: FontWeightManager.regular,
                            color: gray500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OtpPinField(
                        fieldHeight: 65,
                        fieldWidth: 65,
                        autoFillEnable: true,
                        textInputAction: TextInputAction.done,
                        otpPinFieldDecoration:
                            OtpPinFieldDecoration.defaultPinBoxDecoration,
                        keyboardType: TextInputType.number,
                        showCursor: true,
                        cursorColor: gray400,
                        highlightBorder: true,
                        otpPinFieldStyle: const OtpPinFieldStyle(
                          defaultFieldBorderColor: gray200,
                          activeFieldBorderColor: gray200,
                          filledFieldBorderColor: gray200,
                        ),
                        maxLength: 4,
                        onChange: (text) {
                          if (text.length == 4) {
                            otp = text;
                            context.read<PasswordResetBloc>().add(
                                VerifyPasswordEvent(
                                    credentials: {"otp": otp, "email": args!}));
                          }
                        },
                        onSubmit: (text) {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Didn't receive the code? ",
                                style: textTheme.labelMedium!.copyWith(
                                  fontSize: FontSizeManager.f14,
                                  fontWeight: FontWeightManager.regular,
                                  color: gray500,
                                ),
                                children: [
                                  _start == 0
                                      ? TextSpan(
                                          text: "Resend OTP",
                                          style: textTheme.labelMedium!.copyWith(
                                            fontSize: FontSizeManager.f14,
                                            fontWeight: FontWeightManager.regular,
                                            color: blue600,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              context
                                                  .read<PasswordResetBloc>()
                                                  .add(ResendPasswordResetEvent(
                                                      email: args!));
                                              setState(() {
                                                _start = 59;
                                              });
                                              startTimer();
                                            },
                                        )
                                      : TextSpan(
                                          text: "00:$_start",
                                          style: textTheme.labelMedium!.copyWith(
                                            fontSize: FontSizeManager.f14,
                                            fontWeight: FontWeightManager.regular,
                                            color: blue600,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: CustomButtom(
                  title: "Verify",
                  onPressed: () {
                    if (otp == null || otp!.length != 4) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Utils.errorDialog(
                            context,
                            "Please enter a valid OTP",
                            onPressed: () => Navigator.pop(context),
                          );
                        },
                      );
                      return;
                    }
                    context.read<PasswordResetBloc>().add(VerifyPasswordEvent(
                        credentials: {"otp": otp, "email": args!}));
                  }),
            ),
          ),
        );
      },
    );
  }
}
