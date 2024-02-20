import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/Utils/utils.dart';
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
                drawer: BlocProvider(
                  create: (context) => AccountBloc(),
                  child: DoctorDrawer(doctor: state.doctors),
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
                            name: state.doctors.name ?? '-',
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: HeightManager.h6,
                        ),
                        const TileBarWidget(title: 'My Appointments'),
                        const SizedBox(
                          height: HeightManager.h6,
                        ),
                        if (state.appointments.isEmpty)
                          const NoAppointmentWidget()
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
                          height: HeightManager.h10,
                        ),
                        const TileBarWidget(title: 'Patients List'),
                        if (state.patients.isEmpty)
                          const SizedBox(
                            height: HeightManager.h190,
                            child: Center(
                              child: Text('No Patients'),
                            ),
                          )
                        else
                          for (User patient in state.patients)
                            PatientTileWidget(
                              patient: patient,
                            ),

                        const SizedBox(
                          height: HeightManager.h30,
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
