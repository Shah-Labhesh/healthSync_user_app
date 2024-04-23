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
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_bloc.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_event.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_state.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/permission_prescription.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/prescription.dart';
import 'package:user_mobile_app/features/prescriptions/widgets/no_permission_widget.dart';
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

  int _selectedIndex = 0;

  List<PrescriptionPermission> permissions = [];

  fetchData() {
    switch (_selectedIndex) {
      case 0:
        context.read<PrescriptionBloc>().add(FetchPrescriptionsEvent());
        break;
      case 1:
        context.read<PrescriptionBloc>().add(FetchPermissionsEvent());
        break;
    }
  }

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

          if (state is PrescriptionLoaded) {
            prescriptions = state.prescriptions;
            setState(() {});
          }

          if (state is RequestFetched) {
            permissions = state.permission;

            setState(() {});
          }
          if (state is PermissionStatusUpdateError) {
            Utils.showSnackBar(context, state.message, isSuccess: false);
          }
          if (state is PermissionStatusUpdated) {
            for (PrescriptionPermission permission in permissions) {
              if (permission.id == state.id) {
                if (state.status) {
                  permission.accepted = true;
                  permission.rejected = false;
                } else {
                  permission.accepted = false;
                  permission.rejected = true;
                }
                setState(() {});
              }
            }
            Utils.showSnackBar(context, state.message);
          }

          if (state is PermissionRevoked) {
            Utils.showSnackBar(context, 'Revoking permission');
          }
          if (state is PermissionRevokeError) {
            Utils.showSnackBar(context, state.message, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is PrescriptionInitial) {
            context.read<PrescriptionBloc>().add(FetchPrescriptionsEvent());
          }

          if (state is PrescriptionLoaded) {
            prescriptions = state.prescriptions;
          }
          if (state is RequestFetched) {
            permissions = state.permission;
          }
          return LoadingOverlay(
            isLoading:
                state is UpdatePermissionStatus || state is RevokingPermission,
            progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900,
              size: 60,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: [
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
                              .read<PrescriptionBloc>()
                              .add(FetchPrescriptionsEvent());
                        }
                        if (value == 1) {
                          context
                              .read<PrescriptionBloc>()
                              .add(FetchPermissionsEvent());
                        }
                      },
                      tabs: const [
                        Tab(
                          text: 'Prescriptions',
                        ),
                        Tab(
                          text: 'Permissions',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_selectedIndex == 0) ...[
                    if (state is PrescriptionLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (state is PrescriptionError)
                      Center(
                        child: Text(state.message),
                      )
                    else if (prescriptions.isEmpty)
                      const NoPrescriptionWidget()
                    else
                      for (Prescription prescription in prescriptions) ...[
                        PrescriptionTile(
                          isDoctor: doctor,
                          prescription: prescription,
                        ),
                      ]
                  ],
                  if (_selectedIndex == 1) ...[
                    if (state is FetchingRequest)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (state is RequestFetchError)
                      Center(
                        child: Text(state.message),
                      )
                    else if (state is RequestFetched)
                      if (permissions.isNotEmpty)
                        for (PrescriptionPermission permission
                            in permissions) ...[
                          PrescriptionPermissionWidget(permission: permission)
                        ]
                      else
                        const NoPermissionWidget()
                    else
                      const Center(
                        child: Text('No permission request found'),
                      )
                  ]
                ]),
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

class PrescriptionPermissionWidget extends StatelessWidget {
  const PrescriptionPermissionWidget({
    super.key,
    required this.permission,
  });

  final PrescriptionPermission permission;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          vertical: PaddingManager.p14, horizontal: PaddingManager.p18),
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingManager.p12,
        vertical: PaddingManager.p10,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 20,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prescription Permission',
                  style: TextStyle(
                    fontSize: FontSizeManager.f16,
                    fontWeight: FontWeightManager.semiBold,
                    color: gray800,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Permission to : ${permission.doctor!.name!}',
                  style: TextStyle(
                    fontSize: FontSizeManager.f14,
                    fontWeight: FontWeightManager.regular,
                    color: gray800,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                if (permission.accepted == false &&
                    permission.rejected == false)
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (Utils.checkInternetConnection(context)) {
                            context.read<PrescriptionBloc>().add(
                                UpdatePermissionStatus(
                                    permissionId: permission.id!,
                                    status: true));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PaddingManager.p10,
                            vertical: PaddingManager.p12,
                          ),
                          decoration: BoxDecoration(
                            color: blue900,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: blue900,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                fontSize: FontSizeManager.f14,
                                fontWeight: FontWeightManager.semiBold,
                                color: white,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (Utils.checkInternetConnection(context)) {
                            context.read<PrescriptionBloc>().add(
                                UpdatePermissionStatus(
                                    permissionId: permission.id!,
                                    status: false));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PaddingManager.p10,
                            vertical: PaddingManager.p12,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            border: Border.all(
                              color: red600,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              'Reject',
                              style: TextStyle(
                                fontSize: FontSizeManager.f14,
                                fontWeight: FontWeightManager.semiBold,
                                color: red600,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
                else
                  Text(
                    "Status ${permission.expired! ? 'Expired' : permission.accepted! ? 'Accepted' : 'Rejected'}",
                    style: TextStyle(
                      fontSize: FontSizeManager.f14,
                      fontWeight: FontWeightManager.semiBold,
                      color: permission.accepted! ? green900 : red600,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      letterSpacing: 0.5,
                    ),
                  ),
              ],
            ),
          ),
          if (permission.accepted == true && permission.expired == false) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                if (Utils.checkInternetConnection(context)) {
                  context
                      .read<PrescriptionBloc>()
                      .add(RevokePermission(permissionId: permission.id!));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.p10,
                  vertical: PaddingManager.p12,
                ),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(
                    color: red600,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    'Revoke',
                    style: TextStyle(
                      fontSize: FontSizeManager.f14,
                      fontWeight: FontWeightManager.semiBold,
                      color: red600,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
