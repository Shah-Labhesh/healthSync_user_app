import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/bloc/account_bloc.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/account/screens/drawer_doctor.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/appointment/widgets/no_appointment_widget.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_bloc.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_event.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_state.dart';
import 'package:user_mobile_app/features/home/widgets/home_appbar.dart';
import 'package:user_mobile_app/features/home/widgets/tile_bar.dart';
import 'package:intrinsic_grid_view/intrinsic_grid_view.dart';
import 'package:user_mobile_app/features/home/widgets/user_appointment_box.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int getTodaysAppointmentCount(List<Appointment> appointments) {
    int count = 0;
    for (Appointment appointment in appointments) {
      if (appointment.slot!.slotDateTime!.split('T')[0] ==
          DateTime.now().toIso8601String().split('T')[0]) {
        count++;
      }
    }
    return count;
  }

  List<Appointment> appointments = [];
  User doctors = User();
  List<User> patients = [];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        SystemNavigator.pop();
      },
      child: BlocConsumer<DocHomeBloc, DocHomeState>(
        listener: (context, state) {
          if (state is TokenExpired) {
            Utils.handleTokenExpired(context);
          }

          if (state is DocHomeLoaded) {
            appointments = state.appointments;
            doctors = state.doctors;
            patients = state.patients;
            setState(() {});
          }

          if (state is AprovalRequested) {
            Utils.showSnackBar(
              context,
              'Request for approval has been sent',
            );
          }

          if (state is ApprovalRequestFailed) {
            Utils.showSnackBar(
              context,
              state.message,
              isSuccess: false,
            );
          }
        },
        builder: (context, state) {
          if (state is DocHomeInitial) {
            context.read<DocHomeBloc>().add(GetDocHome());
          }

          if (state is DocHomeLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is DocHomeError) {
            return GestureDetector(
              onTap: () async {
              if (Utils.checkInternetConnection(context)) {
                context.read<DocHomeBloc>().add(GetDocHome());
              }
            },
              child:Scaffold(
              body: Center(
                child: Text(state.message),
              ),
            ),
            )
            ;
          }
          if (state is DocHomeLoaded) {
            appointments = state.appointments;
            doctors = state.doctors;
            patients = state.patients;
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DocHomeBloc>().add(GetDocHome());
            },
            child: Scaffold(
              key: _scaffoldKey, // Add a key to the Scaffold
              drawer: BlocProvider(
                create: (context) => AccountBloc(),
                child: DoctorDrawer(doctor: doctors),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: PaddingManager.paddingMedium2,
                      vertical: PaddingManager.paddingMedium2),
                  child: Column(
                    children: [
                      BlocProvider(
                        create: (context) => NotificationBloc(),
                        child: HomeAppBar(
                          drawer: true,
                          name: doctors.name ?? '-',
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: HeightManager.h16,
                      ),
                      if (doctors.approved == false) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PaddingManager.p12,
                            vertical: PaddingManager.p10,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: gray400, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: red600,
                              ),
                              const SizedBox(
                                width: WidthManager.w10,
                              ),
                              Expanded(
                                child: Text(
                                  'Your account is not approved yet. Please update your profile to start taking the appointment.',
                                  style: TextStyle(
                                    fontSize: FontSizeManager.f12,
                                    color: gray800,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeightManager.regular,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: WidthManager.w10,
                              ),
                              if (state is RequestingAproval)
                                const CupertinoActivityIndicator()
                              else
                                GestureDetector(
                                  onTap: () {
                                    if (Utils.checkInternetConnection(
                                        context)) {
                                      context
                                          .read<DocHomeBloc>()
                                          .add(RequestForAproval());
                                    }
                                  },
                                  child: Text('Request Now',
                                      style: TextStyle(
                                        fontSize: FontSizeManager.f12,
                                        color: red600,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeightManager.regular,
                                      )),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: HeightManager.h16,
                        ),
                      ],
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: blue900,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Today Appointments',
                                      style: TextStyle(
                                        fontSize: FontSizeManager.f16,
                                        color: white,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeightManager.semiBold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: HeightManager.h10,
                                    ),
                                    Text(
                                      "${getTodaysAppointmentCount(appointments)}",
                                      style: TextStyle(
                                        fontSize: FontSizeManager.f18,
                                        color: white,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeightManager.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: WidthManager.w10,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: blue900,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Patients',
                                      style: TextStyle(
                                        fontSize: FontSizeManager.f16,
                                        color: white,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeightManager.semiBold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: HeightManager.h10,
                                    ),
                                    Text(
                                      "${patients.length}",
                                      style: TextStyle(
                                        fontSize: FontSizeManager.f18,
                                        color: white,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeightManager.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: HeightManager.h6,
                      ),
                      const TileBarWidget(title: 'My Appointments'),
                      const SizedBox(
                        height: HeightManager.h6,
                      ),
                      if (appointments.isEmpty)
                        const NoAppointmentWidget()
                      else
                        IntrinsicGridView.vertical(
                          columnCount: 2,
                          verticalSpace: 10,
                          horizontalSpace: 10,
                          children: [
                            for (Appointment appointment in appointments)
                              UserAppointmentBox(
                                appointment: appointment,
                              ),
                          ],
                        ), // IntrinsicGridView.vertical
                      const SizedBox(
                        height: HeightManager.h10,
                      ),
                      // const TileBarWidget(title: 'Patients List'),
                      // if (state.patients.isEmpty)
                      //   const SizedBox(
                      //     height: HeightManager.h190,
                      //     child: Center(
                      //       child: Text('No Patients'),
                      //     ),
                      //   )
                      // else
                      //   for (User patient in state.patients)
                      //     PatientTileWidget(
                      //       patient: patient,
                      //     ),

                      const SizedBox(
                        height: HeightManager.h30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
