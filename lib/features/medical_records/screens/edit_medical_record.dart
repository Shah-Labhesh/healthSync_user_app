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
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_bloc.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_event.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_state.dart';
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/medical_records/widgets/icon_text_widget.dart';
import 'package:user_mobile_app/features/preview_screen/pdf_preview.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'Package:http_parser/http_parser.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';

class EditRecordScreen extends StatefulWidget {
  const EditRecordScreen({super.key});

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  @override
  void initState() {
    super.initState();
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

  MedicalRecord? record;

  bool isFirstBuild = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MedicalRecord?;
    if (args != null && isFirstBuild) {
      record = args;
      selectedRecordType = record!.recordType!;
      selectedMedicalRecordType = record!.medicalRecordType!;
      isFirstBuild = false;
    }
    return BlocConsumer<RecordBloc, RecordState>(
      listener: (context, state) {
        if (state is RecordUpdated) {
          Utils.showSnackBar(context, 'Record Updated successfully');
          Navigator.pop(context, state.record);
        }
        if (state is RecordUpdateError) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }

        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is UpdatingRecord,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: 'Edit Record',
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
                          : selectedRecordType == 'PDF' &&
                                  record!.recordType == selectedRecordType
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFPreviewScreen(
                                          pdfPath: record!.record!,
                                          isFromNetwork: true,
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
                                            record!.record!.split('/').last,
                                            style: TextStyle(
                                              fontSize: FontSizeManager.f18,
                                              fontWeight:
                                                  FontWeightManager.semiBold,
                                              color: white,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
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
                                              fontWeight:
                                                  FontWeightManager.regular,
                                              color: white,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
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
                                          selectedRecordType == 'IMAGE')
                                        Image.file(
                                          recordImage!,
                                          fit: BoxFit.cover,
                                          height: HeightManager.h300,
                                          width: double.infinity,
                                        ),
                                      if (record!.recordType == "IMAGE" &&
                                          selectedRecordType == 'IMAGE')
                                        Image.network(
                                          BASE_URL + record!.record!,
                                          fit: BoxFit.cover,
                                          height: HeightManager.h300,
                                          width: double.infinity,
                                        ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
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
                              color: selectedRecordType == 'IMAGE'
                                  ? gray700
                                  : gray400,
                              onTap: () {
                                setState(() {
                                  selectedRecordType = 'IMAGE';
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
                                Map<String, dynamic> newRecord = {};
                                if (selectedRecordType == 'PDF' &&
                                    recordPdf == null &&
                                    record!.record == null) {
                                  Utils.showSnackBar(
                                      context, 'Please select a PDF file',
                                      isSuccess: false);
                                  return;
                                }
                                if (selectedRecordType == 'IMAGE' &&
                                    recordImage == null &&
                                    record!.record == null) {
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
                                if (selectedMedicalRecordType.isNotEmpty) {
                                  newRecord['medicalRecordType'] =
                                      selectedMedicalRecordType;
                                }
                                if (selectedRecordType == 'PDF' &&
                                    recordPdf != null) {
                                  newRecord['record'] =
                                      await MultipartFile.fromFile(
                                          recordPdf!.path,
                                          filename:
                                              recordPdf!.path.split('/').last,
                                          contentType:
                                              MediaType('application', 'pdf'));
                                } else if (recordImage != null &&
                                    selectedRecordType == 'IMAGE') {
                                  newRecord['record'] =
                                      await MultipartFile.fromFile(
                                          recordImage!.path,
                                          filename:
                                              recordImage!.path.split('/').last,
                                          contentType:
                                              MediaType('image', 'jpg'));
                                }

                                newRecord['recordType'] =
                                    selectedRecordType.toUpperCase();

                                if (Utils.checkInternetConnection(context)) {
                                  context.read<RecordBloc>().add(UpdateRecord(
                                      record: newRecord,
                                      recordId: record!.id!));
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
