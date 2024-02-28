import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/appointment/bloc/book_appointment_bloc/book_appointment_bloc.dart';
import 'package:user_mobile_app/features/appointment/bloc/book_appointment_bloc/book_appointment_event.dart';
import 'package:user_mobile_app/features/appointment/bloc/book_appointment_bloc/book_appointment_state.dart';
import 'package:user_mobile_app/features/appointment/data/model/book_appointment.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';

class AppointmentSummary extends StatefulWidget {
  const AppointmentSummary({super.key});

  @override
  State<AppointmentSummary> createState() => _AppointmentSummaryState();
}

class _AppointmentSummaryState extends State<AppointmentSummary> {
  BookAppointmentModel? bookAppointmentModel;

  bool isFirstBuild = true;

  String selectedPaymentType = 'KHALTI_WALLET';
  List<String> time = [
    '5',
    '10',
    '15',
    '20',
    '25',
    '30',
    '35',
    '40',
    '45',
    '50',
    '55',
    '60'
  ];
  String selectedTime = '30';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BookAppointmentModel;
    if (isFirstBuild) {
      bookAppointmentModel = args;
      isFirstBuild = false;
    }
    return BlocConsumer<BookAppointmentBloc, BookAppointmentState>(
      listener: (context, state) {
        if (state is BookAppointmentSuccess) {
          Utils.showSnackBar(context, 'Appointment Booked Successfully');
          Navigator.pushNamed(
              context, 'make_payment', arguments: state.appointmentId);
        }

        if (state is BookAppointmentFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }

        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is BookAppointmentLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: 'Booking Summary',
                isBackButton: true,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          vertical: PaddingManager.p12,
                          horizontal: PaddingManager.paddingMedium2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: PaddingManager.paddingMedium2,
                          vertical: PaddingManager.p12),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: black.withOpacity(0.08),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select an Payment Option',
                            style: TextStyle(
                              fontSize: FontSizeManager.f16,
                              fontWeight: FontWeightManager.semiBold,
                              color: gray900,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // PaymentOptionWidget(
                          //   image: AppImages.esewaImage,
                          //   title: 'eSewa Wallet',
                          //   value: selectedPaymentType == 'ESEWA_WALLET',
                          //   onTapped: () {
                          //     print('value');
                          //     setState(() {
                          //       selectedPaymentType = 'ESEWA_WALLET';
                          //     });
                          //   },
                          // ),
                          PaymentOptionWidget(
                            image: AppImages.khaltiImage,
                            title: 'Khalti Wallet',
                            value: selectedPaymentType == 'KHALTI_WALLET',
                            onTapped: () {
                              setState(() {
                                selectedPaymentType = 'KHALTI_WALLET';
                              });
                            },
                          ),
                          // PaymentOptionWidget(
                          //   image: AppImages.fonepayImage,
                          //   title: 'Fonepay',
                          //   value: selectedPaymentType == 'FONEPAY',
                          //   onTapped: () {
                          //     print('value');
                          //     setState(() {
                          //       selectedPaymentType = 'FONEPAY';
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: PaddingManager.paddingMedium2,
                          vertical: PaddingManager.p12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: PaddingManager.paddingMedium2,
                          vertical: PaddingManager.p12),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: black.withOpacity(0.08),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Details',
                            style: TextStyle(
                              fontSize: FontSizeManager.f16,
                              fontWeight: FontWeightManager.bold,
                              color: gray900,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(
                            height: HeightManager.h10,
                          ),
                          RowTextWidget(
                            title: 'Doctor',
                            value:
                                'Dr. ${bookAppointmentModel!.doctor!.name!} - ${bookAppointmentModel!.doctor!.speciality ?? ''}',
                          ),
                          RowTextWidget(
                            title: 'Type',
                            value: bookAppointmentModel!.appointmentType!
                                .removeUnderScore(),
                          ),
                          RowTextWidget(
                            title: 'Time',
                            value:
                                '${bookAppointmentModel!.slotDateTime!.splitDate()} ${bookAppointmentModel!.slotDateTime!.splitTime()}',
                          ),
                          RowTextWidget(
                            title: 'Note',
                            value: bookAppointmentModel!.notes!,
                          ),
                          const SizedBox(
                            height: HeightManager.h10,
                          ),
                          // reminder before
                          Row(
                            children: [
                              Text(
                                'Reminder Before',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f16,
                                  fontWeight: FontWeightManager.semiBold,
                                  color: gray900,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              PopupMenuButton(
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                ),
                                itemBuilder: (BuildContext context) {
                                  return [
                                    for (var item in time)
                                      PopupMenuItem(
                                        value: item,
                                        onTap: () {
                                          setState(() {
                                            selectedTime = item;
                                          });
                                        },
                                        child: Text('$item mins'),
                                      )
                                  ];
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: PaddingManager.p6,
                                    horizontal: PaddingManager.p12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: blue800,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$selectedTime mins',
                                        style: TextStyle(
                                          fontSize: FontSizeManager.f16,
                                          fontWeight: FontWeightManager.medium,
                                          color: blue600,
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: WidthManager.w4,
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: blue800,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(
                vertical: PaddingManager.paddingMedium2,
                horizontal: PaddingManager.paddingMedium2,
              ),
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                      color: black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Payment Summary',
                    style: TextStyle(
                      fontSize: FontSizeManager.f16,
                      fontWeight: FontWeightManager.bold,
                      color: gray900,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(
                    height: HeightManager.h6,
                  ),
                  const Divider(
                    color: gray300,
                    thickness: 1,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Appointment fee',
                          style: TextStyle(
                            fontSize: FontSizeManager.f14,
                            fontWeight: FontWeightManager.medium,
                            color: gray800,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Rs ${bookAppointmentModel!.appointmentFee}',
                          style: TextStyle(
                            fontSize: FontSizeManager.f14,
                            fontWeight: FontWeightManager.medium,
                            color: gray700,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Platform cost',
                          style: TextStyle(
                            fontSize: FontSizeManager.f14,
                            fontWeight: FontWeightManager.medium,
                            color: gray800,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Rs 50',
                          style: TextStyle(
                            fontSize: FontSizeManager.f14,
                            fontWeight: FontWeightManager.medium,
                            color: gray700,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: gray300,
                    thickness: 1,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total cost',
                          style: TextStyle(
                            fontSize: FontSizeManager.f16,
                            fontWeight: FontWeightManager.semiBold,
                            color: gray900,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Rs ${bookAppointmentModel!.appointmentFee! + 50}',
                          style: TextStyle(
                            fontSize: FontSizeManager.f16,
                            fontWeight: FontWeightManager.semiBold,
                            color: red600,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButtom(
                      title: 'Book Appointment',
                      onPressed: () {
                        bookAppointmentModel!.reminderTime = selectedTime;
                        bookAppointmentModel!.platformCost = 50;
                        bookAppointmentModel!.totalFee =
                            bookAppointmentModel!.appointmentFee! + 50;
                        Map<String, dynamic> value =
                            bookAppointmentModel!.toMap();
                        context
                            .read<BookAppointmentBloc>()
                            .add(BookAppointment(appointmentData: value));
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RowTextWidget extends StatelessWidget {
  const RowTextWidget({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: FontSizeManager.f14,
                fontWeight: FontWeightManager.medium,
                color: gray700,
                fontFamily: GoogleFonts.lato().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: FontSizeManager.f14,
                fontWeight: FontWeightManager.semiBold,
                color: gray800,
                fontFamily: GoogleFonts.lato().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentOptionWidget extends StatelessWidget {
  const PaymentOptionWidget({
    super.key,
    required this.image,
    required this.title,
    required this.value,
    this.onTapped,
  });

  final String image;
  final String title;
  final bool value;
  final Function()? onTapped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 14,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: FontSizeManager.f12,
              fontWeight: FontWeightManager.medium,
              color: gray600,
              fontFamily: GoogleFonts.lato().fontFamily,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          CustomCheckbox(
            value: value,
            onTapped: onTapped,
          ),
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onTapped,
  });

  final bool value;
  final Function()? onTapped;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: value ? blue800 : white,
          border: Border.all(
            color: value ? blue800 : gray300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(
          Icons.check,
          color: white,
          size: 16,
        ),
      ),
    );
  }
}
