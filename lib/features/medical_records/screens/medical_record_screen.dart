import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_bloc.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_event.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_state.dart';
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/medical_records/widgets/record_tile.dart';
import 'package:user_mobile_app/features/medical_records/widgets/NoMedicalRecord.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_popup_item.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  List<MedicalRecord> records = [];
  List<ShareMedicalRecord> sharedRecords = [];
  List<User> doctors = [];
  String sort = 'ALL';

  void shareRecord(String? id) {
    context
        .read<RecordBloc>()
        .add(ShareRecord(recordId: selectedRecord!.id!, doctorId: id!));
  }

  MedicalRecord? selectedRecord;
  @override
  void initState() {
    super.initState();
    context.read<RecordBloc>().add(FetchRecords(sort: sort));
  }

  void fetchData() {
    context.read<RecordBloc>().add(FetchRecords(sort: sort));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchData();
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBarCustomWithSceenTitle(
            title: 'Medical Records',
            isBackButton: true,
          ),
        ),
        body: BlocConsumer<RecordBloc, RecordState>(
          listener: (context, state) {
            if (state is TokenExpired) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login_screen', (route) => false);
              Utils.showSnackBar(context, 'Session expired. Please login again',
                  isSuccess: false);
            }

            if (state is DoctorListFetched) {
              doctors = state.doctors;

              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('Select Doctor'),
                      children: [
                        for (User doctor in doctors)
                          ListTile(
                            title: Text(doctor.name!),
                            onTap: () {
                              shareRecord(doctor.id);
                              Navigator.pop(context);
                            },
                          ),
                      ],
                    );
                  });
            }

            if (state is DoctorListError) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Utils.errorDialog(context, state.message,
                        onPressed: () => Navigator.pop(context));
                  });
            }

            if (state is RecordShared) {
              Utils.showSnackBar(context, state.message);
              sort = 'SHARED';
              fetchData();
            }

            if (state is RecordShareError) {
              showDialog(
                context: context,
                builder: (context) {
                  return Utils.errorDialog(context, state.message,
                      onPressed: () => Navigator.pop(context));
                },
              );
            }

            if (state is RecordRevokedSuccess) {
              Utils.showSnackBar(context, 'Record revoked successfully');
              sharedRecords.removeWhere((element) => element.id == state.id);
            }

            if (state is RecordRevokedError) {
              showDialog(
                context: context,
                builder: (context) {
                  return Utils.errorDialog(context, state.message,
                      onPressed: () => Navigator.pop(context));
                },
              );
            }
          },
          builder: (context, state) {
            if (state is RecordLoading) {
              Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: blue900,
                  size: 60,
                ),
              );
            }
            if (state is RecordError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              );
            }
            if (state is RecordLoaded) {
              records = state.records;
            }

            if (state is ShareRecordLoaded) {
             sharedRecords = state.records;
            }

            return LoadingOverlay(
              isLoading: state is SharingRecord || state is FetchingDoctorList,
              progressIndicator: LoadingAnimationWidget.threeArchedCircle(
                color: blue900,
                size: 60,
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            border: Border.all(
                              color: gray200,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const ImageIcon(
                            AssetImage(
                              funnelIcon,
                            ),
                            color: gray700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (sort == 'ALL') {
                              sort = 'SHARED';
                            } else {
                              sort = 'ALL';
                            }
                            setState(() {});
                            fetchData();
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                color: gray200,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Shared',
                                  style: TextStyle(
                                    color: gray700,
                                    fontSize: FontSizeManager.f16,
                                    fontWeight: FontWeightManager.semiBold,
                                  ),
                                ),
                                if (sort == 'SHARED') ...[
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  const Icon(
                                    CupertinoIcons.xmark_circle_fill,
                                    size: 18,
                                  )
                                ]
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (records.isEmpty && state is RecordLoaded)
                    const NoMedicalRecordWidget(),
                  if (records.isNotEmpty && sort == 'ALL')
                    for (MedicalRecord record in records)
                      RecordTile(
                        records: record,
                        popupMenuItems: PopupMenuItem(
                          child: Column(
                            children: [
                                CustomPopupItem(
                                  title: 'Save',
                                  icon: CupertinoIcons.arrow_down_doc_fill,
                                  onTap: () async {
                                    final picker = FilePicker.platform;
                                    try {
                                      await picker.getDirectoryPath().then(
                                          (value) => Dio().download(
                                              BASE_URL + record.record!,
                                              value));
                                    } catch (e) {
                                      print(' error in downloading file $e');
                                    }
                                  },
                                ),
                                CustomPopupItem(
                                  title: 'Share',
                                  icon: Icons.share_rounded,
                                  onTap: () {
                                    selectedRecord = record;
                                    context
                                        .read<RecordBloc>()
                                        .add(FetchDoctorList());
                                  },
                                ),
                                const CustomPopupItem(
                                  title: 'Edit',
                                  icon: CupertinoIcons.pencil,
                                ),
                                const CustomPopupItem(
                                  title: 'Delete',
                                  icon: Icons.delete,
                                )
                              
                            ],
                          ),
                        ),
                      ),
                  if (sharedRecords.isNotEmpty && sort == 'SHARED')
                    for (ShareMedicalRecord record in sharedRecords)
                      RecordTile(
                        records: record.medicalRecords!,
                        popupMenuItems: PopupMenuItem(
                          child: Column(
                            children: [
                              CustomPopupItem(
                                title: 'Save',
                                icon: CupertinoIcons.arrow_down_doc_fill,
                                onTap: () async {
                                  final picker = FilePicker.platform;
                                  try {
                                    await picker.getDirectoryPath().then(
                                        (value) => Dio().download(
                                            BASE_URL + record.medicalRecords!.record!,
                                            value));
                                  } catch (e) {
                                    print(' error in downloading file $e');
                                  }
                                },
                              ),
                              CustomPopupItem(
                                title: 'Revoke',
                                icon: Icons.backspace_rounded,
                                onTap: () {
                                  context
                                      .read<RecordBloc>()
                                      .add(RevokeSharedRecord(recordId: record.id!));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                ]),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'upload_record_screen').then((value) {
              if (value != null) {
                records.add(value as MedicalRecord);
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
        ),
      ),
    );
  }
}
