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
import 'package:user_mobile_app/widgets/custom_popup_item.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  bool doctor = false;

  @override
  void initState() {
    // TODO: implement initState
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
          // TODO: implement listener
          if (state is TokenExpired) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'login_screen', (route) => false);
            Utils.showSnackBar(context, 'Token Expired Please login again',
                isSuccess: false);
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
              context.read<PrescriptionBloc>().add(FetchPrescriptionsEvent());
              return Future.delayed(const Duration(seconds: 1));
            },
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (prescriptions.isEmpty)
                      NoPrescriptionWidget()
                    else
                      for (Prescription prescription in prescriptions) ...[
                        PrescriptionTile(
                          isDoctor: doctor,
                          prescription: prescription,
                          popupMenuItems: PopupMenuItem(
                            child: Column(
                              children: [
                                CustomPopupItem(
                                  title: 'Save',
                                  icon: CupertinoIcons.arrow_down_doc_fill,
                                  onTap: () async {
                                    // final picker = FilePicker.platform;
                                    // try {
                                    //   await picker.getDirectoryPath().then(
                                    //       (value) => Dio().download(
                                    //           BASE_URL + record.record!,
                                    //           value));
                                    // } catch (e) {
                                    //   print(' error in downloading file $e');
                                    // }
                                  },
                                ),
                              ],
                            ),
                          ),
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
