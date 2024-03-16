// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/appointment/bloc/my_appointment_bloc/my_appointment_bloc.dart';
import 'package:user_mobile_app/features/appointment/bloc/my_appointment_bloc/my_appointment_event.dart';
import 'package:user_mobile_app/features/appointment/bloc/my_appointment_bloc/my_appointment_state.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/appointment/widgets/appointment_container.dart';
import 'package:user_mobile_app/features/appointment/widgets/no_appointment_widget.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/widgets/appbar.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class MyAppointmentScreen extends StatefulWidget {
  const MyAppointmentScreen({super.key});

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  int _selectedIndex = 0;

  List<Appointment> upcomingAppointments = [];
  List<Appointment> completedAppointments = [];

  bool doctor = false;

  @override
  void initState() {
    super.initState();
    initializeRole();
  }

  void initializeRole() async {
    doctor = await SharedUtils.getRole() == 'DOCTOR';
    setState(() {});
  }

  void fetchData() {
    if (Utils.checkInternetConnection(context)) {
      context.read<MyAppointmentBloc>().add(FetchMyAppointmentEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        fetchData();
      },
      child: Scaffold(
        appBar: doctor
            ? const PreferredSize(
                preferredSize: Size.fromHeight(HeightManager.h73),
                child: AppBarCustomWithSceenTitle(
                  title: 'My Appointments',
                  isBackButton: true,
                ),
              )
            : null,
        body: BlocConsumer<MyAppointmentBloc, MyAppointmentState>(
          listener: (context, state) {
            if (state is TokenExpired) {
              Utils.handleTokenExpired(context);
            }

            if (state is MyAppointmentCancelSuccess) {
              Utils.showSnackBar(context, state.message);
              fetchData();
            }

            if (state is MyAppointmentCancelFailed) {
              Utils.showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is MyAppointmentInitial) {
              context.read<MyAppointmentBloc>().add(FetchMyAppointmentEvent());
            }
            if (state is MyAppointmentLoadFailed) {
              return GestureDetector(
                onTap: () {
                  fetchData();
                },
                child: Center(
                  child: Text(state.message),
                ),
              );
            }
            if (state is MyAppointmentLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is MyAppointmentLoaded) {
              upcomingAppointments = state.data
                  .where((element) => element.isExpired == false)
                  .toList();
              completedAppointments = state.data
                  .where((element) => element.isExpired == true)
                  .toList();
            }

            return LoadingOverlay(
              isLoading: state is MyAppointmentCancelling,
              progressIndicator: LoadingAnimationWidget.threeArchedCircle(
                color: blue900,
                size: 60,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: PaddingManager.paddingMedium2,
                    vertical: PaddingManager.paddingSmall,
                  ),
                  child: Column(
                    children: [
                      if (!doctor) ...[
                        BlocProvider(
                          create: (context) => NotificationBloc(),
                          child: const CustomAppBar(
                            title: 'My Appointments',
                            notification: true,
                            isBackButton: false,
                          ),
                        ),
                        const SizedBox(
                          height: HeightManager.h20,
                        ),
                      ],
                      DefaultTabController(
                        length: 2,
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          indicatorColor: blue900,
                          labelStyle: TextStyle(
                            fontSize: FontSizeManager.f16,
                            fontWeight: FontWeightManager.semiBold,
                            color: gray800,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            letterSpacing: 0.5,
                          ),
                          onTap: (value) {
                            setState(() {
                              _selectedIndex = value;
                            });
                          },
                          tabs: const [
                            Tab(
                              text: 'Upcoming',
                            ),
                            Tab(
                              text: 'Completed',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (_selectedIndex == 0)
                        if (upcomingAppointments.isEmpty)
                          const NoAppointmentWidget()
                        else
                          for (Appointment appointment in upcomingAppointments)
                            AppointmentTile(
                              doctor: doctor,
                              appointment: appointment,
                              onCancel: () {
                                context.read<MyAppointmentBloc>().add(
                                    CancelAppointmentEvent(
                                        appointmentId: appointment.id!));
                              },
                            )
                      else if (_selectedIndex == 1)
                        if (completedAppointments.isEmpty)
                          const NoAppointmentWidget()
                        else
                          for (Appointment appointment in completedAppointments)
                            AppointmentTile(
                              doctor: doctor,
                              appointment: appointment,
                            )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
