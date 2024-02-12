import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/account/screens/drawer_doctor.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_bloc.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_event.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_state.dart';
import 'package:user_mobile_app/features/home/widgets/home_appbar.dart';
import 'package:user_mobile_app/features/home/widgets/patient_tile_widget.dart';
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

  // User doctor = User();
  // List<Appointment> appointments = [];
  // List<User> patients = [];

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
          // TODO: implement listener

          if (state is TokenExpired) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'login_screen', (route) => false);

            Utils.showSnackBar(
              context,
              'Session Expired. Please login again',
              isSuccess: false,
            );
          }
        },
        builder: (context, state) {
          if (state is DocHomeInitial) {
            context.read<DocHomeBloc>().add(GetDocHome());
          }

          if (state is DocHomeLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is DocHomeError) {
            return Scaffold(
              body: Center(
                child: Text(state.message),
              ),
            );
          }
          if (state is DocHomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DocHomeBloc>().add(GetDocHome());
              },
              child: Scaffold(
                key: _scaffoldKey, // Add a key to the Scaffold
                drawer: DoctorDrawer(doctor: state.doctors),
                body: SafeArea(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        BlocProvider(
                          create: (context) => NotificationBloc(),
                          child: HomeAppBar(
                            drawer: true,
                            name: state.doctors.name ?? '-',
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const TileBarWidget(title: 'My Appointments'),
                        const SizedBox(
                          height: 6,
                        ),
                        if (state.appointments.isEmpty)
                          SizedBox(
                            height: 190,
                            child: const Center(
                              child: Text('No Appointments'),
                            ),
                          )
                        else
                          IntrinsicGridView.vertical(
                            columnCount: 2,
                            verticalSpace: 10,
                            horizontalSpace: 10,
                            children: [
                              for (Appointment appointment
                                  in state.appointments)
                                UserAppointmentBox(
                                  appointment: appointment,
                                ),
                            ],
                          ), // IntrinsicGridView.vertical
                        const SizedBox(
                          height: 10,
                        ),
                        const TileBarWidget(title: 'Patients List'),
                        if (state.patients.isEmpty)
                          SizedBox(
                            height: 190,
                            child: const Center(
                              child: Text('No Patients'),
                            ),
                          )
                        else
                          for (User patient in state.patients)
                            PatientTileWidget(
                              patient: patient,
                            ),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
