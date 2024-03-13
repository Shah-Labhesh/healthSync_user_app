import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_bloc/patient_bloc.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_bloc/patient_event.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_bloc/patient_state.dart';
import 'package:user_mobile_app/features/patients/widgets/patient_tile_widget.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class MyPatientsScreen extends StatefulWidget {
  const MyPatientsScreen({super.key});

  @override
  State<MyPatientsScreen> createState() => _MyPatientsScreenState();
}

class _MyPatientsScreenState extends State<MyPatientsScreen> {
  List<User> patients = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(HeightManager.h73),
          child: AppBarCustomWithSceenTitle(
            title: 'My Patients',
            isBackButton: true,
          ),
        ),
        body: BlocConsumer<MyPatientBloc, PatientState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is TokenExpired) {
              Utils.handleTokenExpired(context);
            }
            if (state is PatientLoaded) {
              patients = state.patients;
              setState(() {});
            }
          },
          builder: (context, state) {
            if (state is PatientInitial) {
              context.read<MyPatientBloc>().add(GetPatients());
            }
            if (state is PatientLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PatientLoaded) {
              patients = state.patients;
            } else if (state is PatientError) {
              return Center(
                child: Text(state.message),
              );
            }
            return SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.paddingMedium,
                  vertical: PaddingManager.paddingMedium,
                ),
                child: Column(
                  children: [
                    // search bar
                    // list of patients
                    if (patients.isEmpty)
                      const Center(
                        child: Text('No Patients'),
                      )
                    else
                    for (var patient in patients)
                      PatientTileWidget(patient: patient)
                  ],
                ),
              ),
            );
          },
        ));
  }
}
