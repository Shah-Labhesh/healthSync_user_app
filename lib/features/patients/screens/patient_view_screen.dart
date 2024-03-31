import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/medical_records/widgets/record_tile.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_view_bloc/patient_view_bloc.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_view_bloc/patient_view_event.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_view_bloc/patient_view_state.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/prescription.dart';
import 'package:user_mobile_app/features/prescriptions/widgets/prescription_tile.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class PatientViewScreen extends StatefulWidget {
  const PatientViewScreen({super.key});

  @override
  State<PatientViewScreen> createState() => _PatientViewScreenState();
}

class _PatientViewScreenState extends State<PatientViewScreen> {
  bool isFirstBuild = true;
  User? patient;

  int _selectedIndex = 0;

  List<MedicalRecord> medicalRecords = [];
  List<Prescription> prescriptions = [];

  bool recordPermission = false;

  bool prescriptionPermission = false;
  String message = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User?;
    if (isFirstBuild) {
      patient = args;
      isFirstBuild = false;
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'Patient Details',
          isBackButton: true,
        ),
      ),
      body: BlocConsumer<PatientViewBloc, PatientViewState>(
          listener: (context, state) {
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }

        if (state is RecordsLoaded) {
          medicalRecords = state.medicalRecords;

          setState(() {});
        }
        if (state is PrescriptionLoaded) {
          prescriptions = state.prescriptions;
          setState(() {});
        }

        if (state is PermissionRequestError) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }

        if (state is PermissionRequested) {
          Utils.showSnackBar(context, state.message);
        }

        if (state is RecordPermissionRequestError) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }

        if (state is RecordPermissionRequested) {
          Utils.showSnackBar(context, state.message);
        }

        if (state is NoPremissionForRecords) {
          recordPermission = true;
          message = state.message;
          setState(() {});
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
        if (state is NoPremissionForPrescription) {
          prescriptionPermission = true;
          message = state.message;
          setState(() {});
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
      }, builder: (context, state) {
        if (state is PatientViewInitial) {
          context
              .read<PatientViewBloc>()
              .add(FetchMedicalRecords(patientId: patient!.id!));
        }
        if (state is RecordsLoaded) {
          medicalRecords = state.medicalRecords;
        }
        if (state is PrescriptionLoaded) {
          prescriptions = state.prescriptions;
        }

        return SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingManager.paddingMedium,
              vertical: PaddingManager.paddingMedium,
            ),
            child: Column(children: [
              Container(),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: patient!.avatar != null
                    ? Utils.ImageWidget(
                        BASE_URL + patient!.avatar!,
                        height: HeightManager.h100,
                        width: WidthManager.w100,
                      )
                    : Image.asset(
                        AppImages.defaultAvatar,
                        height: HeightManager.h100,
                        width: WidthManager.w100,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 20),
              Text(
                patient!.name ?? "-",
                style: TextStyle(
                  fontSize: FontSizeManager.f22,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  color: gray900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
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
                    if (value == 0) {
                      context
                          .read<PatientViewBloc>()
                          .add(FetchMedicalRecords(patientId: patient!.id!));
                    }
                    if (value == 1) {
                      context
                          .read<PatientViewBloc>()
                          .add(FetchPrescriptions(patientId: patient!.id!));
                    }
                  },
                  tabs: const [
                    Tab(
                      text: 'Medical Records',
                    ),
                    Tab(
                      text: 'Prescriptions',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (_selectedIndex == 0) ...[
                if (state is RecordsLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (state is RecordsError)
                  Center(
                    child: Text(state.message),
                  )
                else if (recordPermission)
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
                            message,
                            style: TextStyle(
                              fontSize: FontSizeManager.f12,
                              color: gray800,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeightManager.regular,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: WidthManager.w10,
                        ),
                        if (state is RequestingRecordPermission)
                          const CupertinoActivityIndicator()
                        else
                          GestureDetector(
                            onTap: () {
                              if (Utils.checkInternetConnection(context)) {
                                context.read<PatientViewBloc>().add(
                                    RequestPermissonForRecords(
                                        patientId: patient!.id!));
                              }
                            },
                            child: Text('Request Now',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f12,
                                  color: red600,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeightManager.regular,
                                )),
                          ),
                      ],
                    ),
                  )
                else if (medicalRecords.isNotEmpty)
                  for (var record in medicalRecords)
                    RecordTile(
                      records: record,
                      popupMenuItems: PopupMenuItem(
                        child: PopupMenuItem(
                          child: Column(
                            children: [],
                          ),
                        ),
                      ),
                    )
                else
                  const Center(
                    child: Text('No Medical Records'),
                  ),
              ] else ...[
                if (state is PrescriptionLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (prescriptionPermission)
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
                            message,
                            style: TextStyle(
                              fontSize: FontSizeManager.f12,
                              color: gray800,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeightManager.regular,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: WidthManager.w10,
                        ),
                        if (state is RequestPermissonForPrescription)
                          const CupertinoActivityIndicator()
                        else
                          GestureDetector(
                            onTap: () {
                              if (Utils.checkInternetConnection(context)) {
                                context.read<PatientViewBloc>().add(
                                    RequestPermissonForPrescription(
                                        patientId: patient!.id!));
                              }
                            },
                            child: Text('Request Now',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f12,
                                  color: red600,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeightManager.regular,
                                )),
                          ),
                      ],
                    ),
                  )
                else if (state is PrescriptionError)
                  Center(
                    child: Text(state.message),
                  )
                else if (prescriptions.isNotEmpty)
                  for (var prescription in prescriptions)
                    PrescriptionTile(
                      prescription: prescription,
                      isDoctor: true,
                    )
                else
                  const Center(
                    child: Text('No Prescriptions'),
                  ),
              ]
            ]),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (Utils.checkInternetConnection(context)) {
            if (_selectedIndex == 0) {
              Navigator.pushNamed(context, 'upload_record_screen', arguments: patient!.id!)
                  .then((value) {
                if (value != null) {
                  medicalRecords.add(value as MedicalRecord);
                  setState(() {});
                }
              });
            } else {
              Navigator.pushNamed(context, 'upload_prescription_screen', arguments: patient!.id!)
                  .then((value) {
                if (value != null) {
                  prescriptions.add(value as Prescription);
                  setState(() {});
                }
              });
            }
          }
        },
        backgroundColor: blue900,
        child: const Icon(
          Icons.add,
          color: white,
          size: 22,
        ),
      ),
    );
  }
}
