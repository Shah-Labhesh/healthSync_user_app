// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/image_picker.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_bloc.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_event.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_state.dart';
import 'package:user_mobile_app/features/medical_records/widgets/icon_text_widget.dart';
import 'package:user_mobile_app/features/preview_screen/pdf_preview.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'Package:http_parser/http_parser.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';

class UploadRecordScreen extends StatefulWidget {
  const UploadRecordScreen({super.key});

  @override
  State<UploadRecordScreen> createState() => _UploadRecordScreenState();
}

class _UploadRecordScreenState extends State<UploadRecordScreen> {
  @override
  void initState() {
    super.initState();
    initializeRole();
  }

  bool doctor = false;

  void initializeRole() async {
    final role = await SharedUtils.getRole();
    if (role == 'DOCTOR') {
      doctor = true;
    } else {
      doctor = false;
    }

    setState(() {});
  }

  void pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      recordPdf = File(result.files.single.path!);
      setState(() {});
    } else {
      Utils.showSnackBar(context, 'No file selected', isSuccess: false);
    }
  }

  List<User> users = [];

  Widget showImageDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Image'),
      children: [
        SimpleDialogOption(
          onPressed: () async {
            recordImage = await ImagePick.pickImage(source: ImageSource.camera);
            if (recordImage != null) {
              Navigator.pop(context);
            }
            setState(() {});
          },
          child: const Text('Camera'),
        ),
        SimpleDialogOption(
          onPressed: () async {
            recordImage =
                await ImagePick.pickImage(source: ImageSource.gallery);
            if (recordImage != null) {
              Navigator.pop(context);
            }
            setState(() {});
          },
          child: const Text('Gallery'),
        ),
      ],
    );
  }

  File? recordPdf;
  File? recordImage;
  String selectedRecordType = 'PDF';
  String selectedMedicalRecordType = '';
  User? selectedUser;
  List<String> medicalRecordType = [
    'VITAL_SIGNS_RECORD',
    'LAB_TEST_RESULTS',
    'RADIOLOGY_REPORTS'
  ];

  Map<String, dynamic> desc = {
    'VITAL_SIGNS_RECORD':
        'blood pressure, heart rate, temperature, respiratory rate, and oxygen saturation',
    'LAB_TEST_RESULTS': ' lab tests, including blood tests, urine tests',
    'RADIOLOGY_REPORTS': 'X-rays, CT scans, MRIs'
  };

  String? patientId;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    if (args != null) {
      patientId = args;
    }
    return BlocConsumer<RecordBloc, RecordState>(
      listener: (context, state) {
        print(state);
        if (state is UploadRecordSuccess) {
          Utils.showSnackBar(context, 'Record uploaded successfully');
          Navigator.pop(context, state.record);
        }
        if (state is UploadRecordError) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }

        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }
      },
      builder: (context, state) {
        if (state is RecordInitial && doctor) {
          context.read<RecordBloc>().add(FetchPatientList());
        }
        if (state is PatientListLoaded) {
          for (var user in state.patients) {
            if (user.id == patientId) {
              selectedUser = user;
              setState(() {});
            }
          }
        }

        if (state is PatientListError) {
          return Center(
            child: Text(state.message),
          );
        }
        return LoadingOverlay(
          isLoading: state is UploadRecordLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: 'Upload Record',
                isBackButton: true,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: WidthManager.w20,
                  vertical: HeightManager.h20,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (selectedRecordType == 'PDF') {
                          pickPdf();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => showImageDialog(context),
                          );
                        }
                      },
                      child: recordPdf != null && selectedRecordType == 'PDF'
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFPreviewScreen(
                                      pdfPath: recordPdf!.path,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: WidthManager.w20,
                                  vertical: HeightManager.h20,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: blue700,
                                  border: Border.all(
                                    color: gray200,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        recordPdf!.path.split('/').last,
                                        style: TextStyle(
                                          fontSize: FontSizeManager.f18,
                                          fontWeight:
                                              FontWeightManager.semiBold,
                                          color: white,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.upload_file_outlined,
                                      size: 18,
                                      color: white,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        pickPdf();
                                      },
                                      child: Text(
                                        'Change PDF',
                                        style: TextStyle(
                                          fontSize: FontSizeManager.f14,
                                          fontWeight: FontWeightManager.regular,
                                          color: white,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: HeightManager.h300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: gray50,
                                border: Border.all(
                                  color: gray200,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (recordImage != null &&
                                      selectedRecordType == 'Image')
                                    Image.file(
                                      recordImage!,
                                      fit: BoxFit.cover,
                                      height: HeightManager.h300,
                                      width: double.infinity,
                                    ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.upload_file_outlined,
                                        size: 28,
                                        color: blue700,
                                      ),
                                      const SizedBox(
                                        height: HeightManager.h8,
                                      ),
                                      Text(
                                        '${recordImage != null ? 'Change' : 'Upload'} Record',
                                        style: TextStyle(
                                          fontSize: FontSizeManager.f18,
                                          fontWeight:
                                              FontWeightManager.semiBold,
                                          color: blue800,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: HeightManager.h20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: WidthManager.w20,
                        vertical: HeightManager.h20,
                      ),
                      decoration: BoxDecoration(
                        color: gray50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -2),
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (doctor) ...[
                            Text(
                              'Record for',
                              style: TextStyle(
                                fontSize: FontSizeManager.f18,
                                fontWeight: FontWeightManager.medium,
                                color: gray900,
                                fontFamily: GoogleFonts.rubik().fontFamily,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // if (users.isEmpty) {
                                //   Utils.showSnackBar(
                                //       context, 'No patient available',
                                //       isSuccess: false);
                                //   return;
                                // }
                              },
                              child: DropdownButton<User>(
                                hint: const Text('Select Patient'),
                                style: TextStyle(
                                  fontSize: FontSizeManager.f18,
                                  fontWeight: FontWeightManager.semiBold,
                                  color: gray700,
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                ),
                                value: selectedUser,
                                dropdownColor: white,
                                underline: const SizedBox(),
                                isExpanded: true,
                                items: users
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name!),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedUser = value;
                                  });
                                },
                              ),
                            ),
                            const Divider(
                              color: gray200,
                              thickness: 1.5,
                            ),
                            const SizedBox(
                              height: HeightManager.h20,
                            ),
                          ],
                          Text(
                            'File Type',
                            style: TextStyle(
                              fontSize: FontSizeManager.f18,
                              fontWeight: FontWeightManager.medium,
                              color: gray900,
                              fontFamily: GoogleFonts.rubik().fontFamily,
                            ),
                          ),
                          Row(children: [
                            IconWithText(
                              icon: pdfIcon,
                              title: 'PDF',
                              iconSize: 28,
                              color: selectedRecordType == 'PDF'
                                  ? gray700
                                  : gray400,
                              onTap: () {
                                setState(() {
                                  selectedRecordType = 'PDF';
                                });
                              },
                            ),
                            IconWithText(
                              icon: imageIcon,
                              title: 'Image',
                              iconSize: 28,
                              color: selectedRecordType == 'Image'
                                  ? gray700
                                  : gray400,
                              onTap: () {
                                setState(() {
                                  selectedRecordType = 'Image';
                                });
                              },
                            )
                          ]),
                          const Divider(
                            color: gray200,
                            thickness: 1.5,
                          ),
                          const SizedBox(
                            height: HeightManager.h20,
                          ),
                          InkWell(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: ShapeBorder.lerp(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      0.5),
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: WidthManager.w20,
                                      vertical: HeightManager.h20),
                                  child: SingleChildScrollView(
                                    child: Column(children: [
                                      const SizedBox(
                                        height: HeightManager.h20,
                                      ),
                                      Text(
                                        'Select Record Type',
                                        style: TextStyle(
                                          color: gray800,
                                          fontWeight:
                                              FontWeightManager.semiBold,
                                          fontSize: FontSizeManager.f18,
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: HeightManager.h20,
                                      ),
                                      for (String type in medicalRecordType)
                                        ListTile(
                                          title: Text(
                                            type.removeUnderScore(),
                                            style: TextStyle(
                                              color: gray800,
                                              fontWeight:
                                                  FontWeightManager.semiBold,
                                              fontSize: FontSizeManager.f18,
                                              fontFamily:
                                                  GoogleFonts.lato().fontFamily,
                                            ),
                                          ),
                                          subtitle: Text(
                                            desc[type] ?? '-',
                                            style: TextStyle(
                                              color: gray400,
                                              fontWeight:
                                                  FontWeightManager.medium,
                                              fontSize: FontSizeManager.f14,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context, type);
                                          },
                                        )
                                    ]),
                                  ),
                                );
                              },
                            ).then((value) {
                              if (value == null) {
                                Utils.showSnackBar(
                                    context, 'Please select a record type',
                                    isSuccess: false);
                                return;
                              }
                              ;
                              setState(() {
                                selectedMedicalRecordType = value.toString();
                              });
                            }),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Record Type',
                                          style: TextStyle(
                                            fontSize: FontSizeManager.f18,
                                            fontWeight:
                                                FontWeightManager.medium,
                                            color: gray900,
                                            fontFamily:
                                                GoogleFonts.rubik().fontFamily,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: HeightManager.h10,
                                        ),
                                        Text(
                                          selectedMedicalRecordType
                                              .removeUnderScore(),
                                          style: TextStyle(
                                            fontSize: FontSizeManager.f20,
                                            fontWeight: FontWeightManager.bold,
                                            color: blue800,
                                            fontFamily:
                                                GoogleFonts.rubik().fontFamily,
                                          ),
                                        ),
                                      ]),
                                  const Icon(
                                    CupertinoIcons.pencil,
                                    size: 22,
                                    color: gray600,
                                  )
                                ]),
                          ),
                          const SizedBox(
                            height: HeightManager.h20,
                          ),
                          const Divider(
                            color: gray200,
                            thickness: 1.5,
                          ),
                          const SizedBox(
                            height: HeightManager.h20,
                          ),
                          CustomButtom(
                              title: 'Upload',
                              onPressed: () async {
                                Map<String, dynamic> record = {};
                                if (selectedRecordType == 'PDF' &&
                                    recordPdf == null) {
                                  Utils.showSnackBar(
                                      context, 'Please select a PDF file',
                                      isSuccess: false);
                                  return;
                                }
                                if (selectedRecordType == 'Image' &&
                                    recordImage == null) {
                                  Utils.showSnackBar(
                                      context, 'Please select an image file',
                                      isSuccess: false);
                                  return;
                                }
                                if (selectedMedicalRecordType.isEmpty) {
                                  Utils.showSnackBar(
                                      context, 'Please select a record type',
                                      isSuccess: false);
                                  return;
                                }

                                // upload record
                                if (doctor && selectedUser == null) {
                                  Utils.showSnackBar(
                                      context, 'Please select a patient',
                                      isSuccess: false);
                                  return;
                                }

                                // upload record
                                if (selectedMedicalRecordType.isNotEmpty) {
                                  record['medicalRecordType'] =
                                      selectedMedicalRecordType;
                                }

                                if (selectedRecordType == 'PDF' &&
                                    recordPdf != null) {
                                  record['record'] =
                                      await MultipartFile.fromFile(
                                          recordPdf!.path,
                                          filename:
                                              recordPdf!.path.split('/').last,
                                          contentType:
                                              MediaType('application', 'pdf'));
                                } else if (recordImage != null) {
                                  record['record'] =
                                      await MultipartFile.fromFile(
                                          recordImage!.path,
                                          filename:
                                              recordImage!.path.split('/').last,
                                          contentType:
                                              MediaType('image', 'jpg'));
                                } else {
                                  Utils.showSnackBar(
                                      context, 'Please select a file',
                                      isSuccess: false);
                                  return;
                                }

                                record['recordType'] =
                                    selectedRecordType.toUpperCase();
                                if (doctor && selectedUser != null) {
                                  context.read<RecordBloc>().add(
                                      UploadRecordByDoctor(
                                          patientId: selectedUser!.id!,
                                          record: record));
                                  return;
                                }
                                if (Utils.checkInternetConnection(context)) {
                                  context
                                      .read<RecordBloc>()
                                      .add(UploadRecordEvent(record: record));
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
