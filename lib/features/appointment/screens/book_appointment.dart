// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/appointment/bloc/book_appointment_bloc/book_appointment_bloc.dart';
import 'package:user_mobile_app/features/appointment/bloc/book_appointment_bloc/book_appointment_event.dart';
import 'package:user_mobile_app/features/appointment/bloc/book_appointment_bloc/book_appointment_state.dart';
import 'package:user_mobile_app/features/appointment/data/model/book_appointment.dart';
import 'package:user_mobile_app/features/appointment/widgets/appointment_type_widget.dart';
import 'package:user_mobile_app/features/appointment/widgets/date_slot_widget.dart';
import 'package:user_mobile_app/features/appointment/widgets/slot_time_widget.dart';
import 'package:user_mobile_app/features/home/widgets/doctor_tile.dart';
import 'package:user_mobile_app/features/slots/data/model/slot.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

List<Slots> slots = [];

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  

  String giveSelectedDate() {
    String date = '';
    for (var element in dates) {
      if (element == selectedDate) {
        date = element;
      }
    }
    return date;
  }

  void mapSlotsAccordingToDate() {
    groupedAppointments.forEach((date, slots) {
      if (!dates.contains(date)) {
        dates.add(date);
      }
     
    });
  }

  int countOfAvailableSlots(List<Slots> slots) {
    int count = 0;
    for (var slot in slots) {
      if (!slot.isBooked!) {
        count++;
      }
    }
    return count;
  }

  List<String> dates = [];
  List<String> appointmentTypes = [
    'Follow Up',
    'Consultation',
    'Therapy',
    'Counseling'
  ];
  Map<String, String> appointmentTypeMap = {
    'Follow Up': 'FOLLOWUP',
    'Consultation': 'CONSULTATION',
    'Therapy': 'THERAPY',
    'Counseling': 'COUNSELING',
  };
  String selectedAppointmentTypes = 'Follow Up';

  Map<String, List<Slots>> groupedAppointments = {};

  // Print the grouped results
  Map<String, List<Slots>> groupByDate(List<Slots> slots) {
    return groupBy(
      slots,
      (slot) {
        DateTime slotDate = DateTime.parse(slot.slotDateTime!);
        return slotDate.toString().slotDateFormat();
      },
    );
  }

  String? selectedDate;

  Slots seletedSlot = Slots();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;
    return BlocConsumer<BookAppointmentBloc, BookAppointmentState>(
      listener: (context, state) {
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }
      },
      builder: (context, state) {
        if (state is BookAppointmentInitial) {
          context
              .read<BookAppointmentBloc>()
              .add(FetchSlots(doctorId: args.id!));
        }

        if (state is FetchSlotsSuccess) {
          slots = state.slots;
          groupedAppointments = groupByDate(slots);
          mapSlotsAccordingToDate();
          dates.sort((a, b) => a.compareTo(b));
        }
        return LoadingOverlay(
          isLoading: state is BookAppointmentLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900, size: 60),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBarCustomWithSceenTitle(
                title: 'Book Appointment',
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: PaddingManager.paddingMedium2),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoctorTile(
                      doctor: args,
                      onNavigate: () {},
                    ),
                    const SizedBox(height: HeightManager.h20),
                    if (state is FetchSlotsFailure)
                      Center(
                        child: Text(
                          state.message,
                        ),
                      )
                    else if (state is FetchSlotsLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (slots.isEmpty)
                      const Center(
                        child: Text(
                          'No slots available',
                        ),
                      )
                    else if (slots.isNotEmpty) ...[
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (String date in dates) ...[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                },
                                child: DateSlotWidget(
                                  maintextColor:
                                      date == selectedDate ? white : gray800,
                                  subtextColor:
                                      date == selectedDate ? white : gray500,
                                  borderColor:
                                      date == selectedDate ? blue900 : gray600,
                                  backgroundColor:
                                      date == selectedDate ? blue900 : white,
                                  date: date,
                                  slots: groupedAppointments[date] != null
                                      ? countOfAvailableSlots(
                                          groupedAppointments[date]!)
                                      : 0,
                                ),
                              ),
                              const SizedBox(width: WidthManager.w10),
                            ],
                            const SizedBox(width: WidthManager.w10),
                          ],
                        ),
                      ),
                      const SizedBox(height: HeightManager.h20),
                      if (selectedDate == null)
                        const Center(
                          child: Text(
                            'Select a date to view available slots',
                          ),
                        )
                      else ...[
                        Center(
                          child: Text(
                            giveSelectedDate(),
                            style: TextStyle(
                              fontSize: FontSizeManager.f22,
                              fontWeight: FontWeightManager.semiBold,
                              color: gray900,
                              fontFamily: GoogleFonts.rubik().fontFamily,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: HeightManager.h20),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            for (Slots slot
                                in groupedAppointments[selectedDate]!) ...[
                              InkWell(
                                onTap: () {
                                  if (slot.isBooked!) {
                                    Utils.showSnackBar(
                                        context, 'Slot is already booked',
                                        isSuccess: false);
                                    return;
                                  }
                                  setState(() {
                                    seletedSlot = slot;
                                  });
                                },
                                child: SlotTimeWidget(
                                  slot: slot,
                                  isSelected: slot == seletedSlot,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ]),
                        ),
                      ],
                    ],
                    const SizedBox(height: HeightManager.h20),
                    Text(
                      'Appointment Type',
                      style: TextStyle(
                        fontSize: FontSizeManager.f22,
                        fontWeight: FontWeightManager.semiBold,
                        color: gray900,
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: HeightManager.h20),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (String type in appointmentTypes) ...[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedAppointmentTypes = type;
                                });
                              },
                              child: AppointmentTypeWidget(
                                title: type,
                                isSelected: type == selectedAppointmentTypes,
                              ),
                            ),
                            const SizedBox(width: WidthManager.w10),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: HeightManager.h20),
                    CustomTextfield(
                      label: 'Note',
                      hintText: 'Enter your note here',
                      minLines: 5,
                      controller: _noteController,
                      maxLines: 8,
                    ),
                    CustomButtom(
                        title: 'Proceed To Payment',
                        onPressed: () {
                          if (seletedSlot.slotDateTime == null) {
                            Utils.showSnackBar(context, 'Please select a slot',
                                isSuccess: false);
                          }
                          if (selectedAppointmentTypes.isEmpty) {
                            Utils.showSnackBar(context, 'Please select a type',
                                isSuccess: false);
                          }
                          if (_formKey.currentState!.validate()) {
                            BookAppointmentModel appointment =
                                BookAppointmentModel(
                              slotId: seletedSlot.slotId,
                              doctorId: args.id,
                              appointmentFee: args.fee!,
                              doctor: args,
                              slotDateTime: seletedSlot.slotDateTime!,
                              appointmentType:
                                  appointmentTypeMap[selectedAppointmentTypes],
                              notes: _noteController.text,
                            );
                            Navigator.pushNamed(context, 'book_summary',
                                arguments: appointment);
                            
                          }
                        }),
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
