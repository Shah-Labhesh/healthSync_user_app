import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
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

  bool isFirstBuild = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null && isFirstBuild) {
      isFirstBuild = false;
      context
          .read<EmailVerificationBloc>()
          .add(InitiateEmailVerificationEvent(email: args["email"]));
    }
    return BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is EmailVerificationCompleted) {
          showDialog(
            context: context,
            builder: (context) {
              return Utils.successDialog(
                context,
                state.data["message"],
                onPressed: () => Navigator.pushReplacementNamed(context, 'login_screen', arguments: {"email": args!["email"], "password": args["password"]}),
              );
            },
          );
          
        }
        if (state is EmailVerificationInitiationFailed) {
          showDialog(
            context: context,
            builder: (context) {
              return Utils.errorDialog(
                context,
                state.message,
                onPressed: () => Navigator.pop(context),
              );
            },
          );
        }
        if (state is EmailVerificationFailed) {
          showDialog(
            context: context,
            builder: (context) {
              return Utils.errorDialog(
                context,
                state.message,
                onPressed: () => Navigator.pop(context),
              );
            },
          );
        }
        if (state is EmailVerificationInitiated) {
          showDialog(
            context: context,
            builder: (context) {
              return Utils.successDialog(
                context,
                state.data["message"],
                onPressed: () => Navigator.pop(context),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: context.watch<EmailVerificationBloc>().state
              is EmailVerificationLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900, size: 60),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBarCustomWithSceenTitle(
                title: "Email Verification",
                isBackButton: true,
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Enter the 4 digits code that you received on your email.",
                        style: textTheme.displaySmall!.copyWith(
                          fontSize: FontSizeManager.f14,
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
                          context.read<EmailVerificationBloc>().add(
                                VerifyEmailEvent(
                                  credentials: {
                                    "otp": text,
                                    "email": args!["email"]
                                  },
                                ),
                              );
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
                                                .read<EmailVerificationBloc>()
                                                .add(
                                                  ResendEmailVerificationEvent(
                                                      email: args!["email"]),
                                                );
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
                    Spacer(),
                    CustomButtom(
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
                          context.read<EmailVerificationBloc>().add(
                                VerifyEmailEvent(
                                  credentials: {"otp": otp, "email": args},
                                ),
                              );
                        }),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
