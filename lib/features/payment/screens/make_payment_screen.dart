import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/payment/bloc/make_payment_bloc/make_payment_bloc.dart';
import 'package:user_mobile_app/features/payment/bloc/make_payment_bloc/make_payment_event.dart';
import 'package:user_mobile_app/features/payment/bloc/make_payment_bloc/make_payment_state.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class MakePayment extends StatefulWidget {
  const MakePayment({super.key});

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  final mobileController = TextEditingController();
  final mPinController = TextEditingController();
  final transactionPinController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool hideMPIN = true;
  bool hideTransactionPin = true;

  String? token;

  String? appointmentId;

  initiatePayment() async {
    // Add your logic here
    if (Utils.checkInternetConnection(context)) {
      context.read<MakePaymentBloc>().add(
            InitiatePayment(
              data: {
                "mobile": mobileController.text.trim(),
                "transaction_pin": mPinController.text.trim(),
                "product_identity": appointmentId,
              },
            ),
          );
    }

    await Future.delayed(const Duration(seconds: 1));
  }

  confirmPayment() async {
    // Add your logic here
    print(
      {
        "token": token,
        "confirmation_code": transactionPinController.text.trim(),
        "transaction_pin": mPinController.text.trim(),
        "appointmentId": appointmentId,
        "mobile": mobileController.text.trim(),
      },
    );
    if (Utils.checkInternetConnection(context)) {
      context.read<MakePaymentBloc>().add(
            ConfirmPayment(
              data: {
                "token": token,
                "confirmation_code": transactionPinController.text.trim(),
                "transaction_pin": mPinController.text.trim(),
                "appointmentId": appointmentId,
                "mobile": mobileController.text.trim(),
              },
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    if (args.isNotEmpty) {
      appointmentId = args;
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'Pay via Khalti',
          backgroundColor: blue800,
          textColor: white,
          isBackButton: true,
        ),
      ),
      body: BlocConsumer<MakePaymentBloc, MakePaymentState>(
          listener: (context, state) {
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }

        if (state is InitiatePaymentSuccess) {
          setState(() {
            token = state.khaltiToken;
          });
        }

        if (state is ConfirmPaymentSuccess) {
          Utils.showSnackBar(
            context,
            'Payment Successful',
            isSuccess: true,
          );
          Navigator.pushNamedAndRemoveUntil(
              context, 'user_home_screen', arguments: 1, (route) => false);
        }

        if (state is InitiatePaymentFailure) {
          Utils.showSnackBar(
            context,
            state.message,
            isSuccess: false,
          );
        }

        if (state is ConfirmPaymentFailure) {
          Utils.showSnackBar(
            context,
            state.message,
            isSuccess: false,
          );
        }
      }, builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is MakePaymentLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingMedium2,
                vertical: PaddingManager.paddingMedium2,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Add your widgets here
                    SizedBox(
                      width: double.infinity,
                      height: HeightManager.h73,
                      child: Image.asset(
                        AppImages.khaltiImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: HeightManager.h20,
                    ),
                    if (token == null) ...[
                      CustomTextfield(
                        label: 'Mobile Number',
                        hintText: 'Enter Mobile Number',
                        textInputType: TextInputType.phone,
                        controller: mobileController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (value.trim().length != 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      CustomTextfield(
                        label: 'MPIN',
                        hintText: 'Enter MPIN',
                        textInputType: TextInputType.number,
                        obscure: hideMPIN,
                        controller: mPinController,
                        suffixPressed: () {
                          setState(() {
                            hideMPIN = !hideMPIN;
                          });
                        },
                        suffixIcon: hideMPIN
                            ? const Icon(
                                CupertinoIcons.eye,
                                color: gray400,
                                size: 22,
                              )
                            : const Icon(
                                CupertinoIcons.eye_slash,
                                color: gray400,
                                size: 22,
                              ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'MPIN is required';
                          }
                          if (value.trim().length != 4) {
                            return 'MPIN must be 4 digits';
                          }
                          return null;
                        },
                      ),
                    ] else ...[
                      const SizedBox(
                        height: HeightManager.h20,
                      ),
                      Text(
                        'Confirm Payment',
                        style: TextStyle(
                          color: gray700,
                          fontSize: FontSizeManager.f22,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      const SizedBox(
                        height: HeightManager.h20,
                      ),
                      CustomTextfield(
                        label: 'Transaction Pin',
                        hintText: 'Enter Transaction Pin',
                        textInputType: TextInputType.number,
                        controller: transactionPinController,
                        obscure: hideTransactionPin,
                        suffixPressed: () {
                          setState(() {
                            hideTransactionPin = !hideTransactionPin;
                          });
                        },
                        suffixIcon: hideTransactionPin
                            ? const Icon(
                                CupertinoIcons.eye,
                                color: gray400,
                                size: 22,
                              )
                            : const Icon(
                                CupertinoIcons.eye_slash,
                                color: gray400,
                                size: 22,
                              ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Transaction Pin is required';
                          }
                          if (value.trim().length != 6) {
                            return 'Transaction Pin must be 6 digits';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(
                      height: HeightManager.h20,
                    ),
                    CustomButtom(
                      title: token != null ? 'Confirm' : 'Pay',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Add your logic here
                          if (token == null) {
                            initiatePayment();
                          } else {
                            confirmPayment();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
