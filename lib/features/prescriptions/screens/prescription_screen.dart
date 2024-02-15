import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_bloc.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_event.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_state.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/prescription.dart';
import 'package:user_mobile_app/features/prescriptions/widgets/no_prescription_widget.dart';
import 'package:user_mobile_app/features/prescriptions/widgets/prescription_tile.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
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

  List<Prescription> prescriptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarCustomWithSceenTitle(
          title: 'Prescriptions',
          isBackButton: true,
        ),
      ),
      body: BlocConsumer<PrescriptionBloc, PrescriptionState>(
        listener: (context, state) {
          if (state is TokenExpired) {
            Utils.handleTokenExpired(context);
          }
        },
        builder: (context, state) {
          if (state is PrescriptionInitial) {
            context.read<PrescriptionBloc>().add(FetchPrescriptionsEvent());
          }
          if (state is PrescriptionLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is PrescriptionError) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is PrescriptionLoaded) {
            prescriptions = state.prescriptions;
          }
          return RefreshIndicator(
            onRefresh: () {
              if (Utils.checkInternetConnection(context)){
              context.read<PrescriptionBloc>().add(FetchPrescriptionsEvent());
              }
              return Future.delayed(const Duration(seconds: 1));
            },
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (prescriptions.isEmpty)
                      const NoPrescriptionWidget()
                    else
                      for (Prescription prescription in prescriptions) ...[
                        PrescriptionTile(
                          isDoctor: doctor,
                          prescription: prescription,
                          // popupMenuItems: PopupMenuItem(
                          //   child: Column(
                          //     children: [
                          //       CustomPopupItem(
                          //         title: 'Save',
                          //         icon: CupertinoIcons.arrow_down_doc_fill,
                          //         onTap: () async {
                          //           try {
                          //           String path = await PdfApi()
                          //               .getApplicationDocumentsDirectoryPath();
                          //           print(path);
                          //             Dio().download(
                          //                     BASE_URL + prescription.prescription!,
                          //                     path);
                          //           } catch (e) {
                          //             print(' error in downloading file $e');
                          //           }
                          //           if (prescription.recordType == 'TEXT') {
                          //             final pdf = await PdfInvoiceApi.generate(
                          //                 prescription);
                                          
                          //           }
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ),
                      ]
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: doctor
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, 'upload_prescription_screen')
                    .then((value) {
                  if (value != null) {
                    prescriptions.add(value as Prescription);
                    setState(() {});
                  }
                });
              },
              backgroundColor: blue900,
              child: const Icon(
                Icons.add,
                color: white,
                size: 22,
              ),
            )
          : null,
    );
  }
}
