import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_bloc.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_event.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_state.dart';
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/medical_records/data/model/record_request.dart';
import 'package:user_mobile_app/features/medical_records/widgets/permission_widget.dart';
import 'package:user_mobile_app/features/medical_records/widgets/record_tile.dart';
import 'package:user_mobile_app/features/medical_records/widgets/NoMedicalRecord.dart';
import 'package:user_mobile_app/features/prescriptions/widgets/no_permission_widget.dart';
import 'package:user_mobile_app/features/preview_screen/image_preview.dart';
import 'package:user_mobile_app/features/preview_screen/pdf_preview.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_popup_item.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<RecordBloc>().add(FetchRecords());
  }

  void fetchData() {
    if (Utils.checkInternetConnection(context)) {
      switch (_selectedIndex) {
        case 0:
          context.read<RecordBloc>().add(FetchRecords());
          break;
        case 1:
          context.read<RecordBloc>().add(FetchAllRequest());
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchData();
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(HeightManager.h73),
          child: AppBarCustomWithSceenTitle(
            title: 'Medical Records',
            isBackButton: true,
          ),
        ),
        body: BlocConsumer<RecordBloc, RecordState>(
          listener: (context, state) {
            if (state is TokenExpired) {
              Utils.handleTokenExpired(context);
            }

            if (state is RequestStatusError) {
              Utils.showSnackBar(context, state.message, isSuccess: false);
            }

            if (state is RequestStatusUpdated) {
              fetchData();
              Utils.showSnackBar(context, state.message, isSuccess: true);
            }

            if (state is PermissionRevoked) {
              fetchData();
              Utils.showSnackBar(context, 'Permission revoked',
                  isSuccess: true);
            }

            if (state is PermissionRevokeError) {
              Utils.showSnackBar(context, state.message, isSuccess: false);
            }
          },
          builder: (context, state) {
            return LoadingOverlay(
              isLoading:
                  state is UpdatingRequestStatus || state is RevokingPermission,
              progressIndicator: LoadingAnimationWidget.threeArchedCircle(
                color: blue900,
                size: 60,
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
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
                          context.read<RecordBloc>().add(FetchRecords());
                        }
                        if (value == 1) {
                          context.read<RecordBloc>().add(FetchAllRequest());
                        }
                      },
                      tabs: const [
                        Tab(
                          text: 'Medical Records',
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
                    if (state is RecordLoading)
                      Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: blue900,
                          size: 60,
                        ),
                      )
                    else if (state is RecordError)
                      Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            color: red700,
                            fontSize: FontSizeManager.f16,
                          ),
                        ),
                      )
                    else if (state is RecordLoaded) ...[
                      if (state.records.isEmpty)
                        const NoMedicalRecordWidget()
                      else if (state.records.isNotEmpty)
                        for (MedicalRecord record in state.records)
                          RecordTile(
                            records: record,
                            popupMenuItems: PopupMenuItem(
                              child: Column(
                                children: [
                                  CustomPopupItem(
                                    title: 'Edit',
                                    icon: CupertinoIcons.pencil,
                                    onTap: () {
                                      if (Utils.checkInternetConnection(
                                              context) ==
                                          false) {
                                        return;
                                      }
                                      if (record.selfAdded == false) {
                                        Utils.showSnackBar(context,
                                            'You have no permission to edit this record.',
                                            isSuccess: false);
                                        return;
                                      }
                                      Navigator.pushNamed(
                                        context,
                                        'edit_medical_record',
                                        arguments: record,
                                      ).then((value) {
                                        if (value != null) {
                                          _selectedIndex = 0;
                                          context
                                              .read<RecordBloc>()
                                              .add(FetchRecords());
                                          setState(() {});
                                        }
                                      });
                                    },
                                  ),
                                  CustomPopupItem(
                                    title: 'Preview',
                                    icon: CupertinoIcons.eye_fill,
                                    onTap: () {
                                      if (Utils.checkInternetConnection(
                                              context) ==
                                          false) {
                                        return;
                                      }
                                      if (record.recordType == 'PDF') {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return PDFPreviewScreen(
                                              pdfPath: record.record!,
                                              isFromNetwork: true,
                                            );
                                          },
                                        ));
                                      }

                                      if (record.recordType == 'IMAGE') {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return ImagePreviewScreen(
                                              imageUrl: record.record!,
                                            );
                                          },
                                        ));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ] else if (_selectedIndex == 1) ...[
                    if (state is FetchingRequest)
                      Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: blue900,
                          size: 60,
                        ),
                      )
                    else if (state is RequestError)
                      Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            color: red700,
                            fontSize: FontSizeManager.f16,
                          ),
                        ),
                      )
                    else if (state is RequestFetched) ...[
                      if (state.requests.isEmpty)
                        NoPermissionWidget()
                      else if (state.requests.isNotEmpty)
                        for (RecordRequest request in state.requests)
                          RecordRequestWidget(request: request)
                    ],
                  ],
                ]),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (Utils.checkInternetConnection(context)) {
              Navigator.pushNamed(context, 'upload_record_screen')
                  .then((value) {
                if (value != null) {
                  _selectedIndex = 0;
                  context.read<RecordBloc>().add(FetchRecords());
                  setState(() {});
                }
              });
            }
          },
          backgroundColor: blue900,
          child: const Icon(
            Icons.add,
            color: white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
