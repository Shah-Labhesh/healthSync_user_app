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
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_bloc.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_event.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_state.dart';
import 'package:user_mobile_app/features/prescriptions/widgets/icon_text_widget.dart';
import 'package:user_mobile_app/features/preview_screen/pdf_preview.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'Package:http_parser/http_parser.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
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

  String recordText = '';

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

  String date = '';

  User? selectedUser;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrescriptionBloc, PrescriptionState>(
      listener: (context, state) {
        if (state is PrescriptionUploaded) {
          Utils.showSnackBar(context, 'Record uploaded successfully');
          Navigator.pop(context, state.prescription);
        }
        if (state is PrescriptionUploadError) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }

        if (state is TokenExpired) {
         Utils.handleTokenExpired(context);
        }
      },
      builder: (context, state) {
        if (state is PrescriptionInitial && doctor) {
          context.read<PrescriptionBloc>().add(FetchPatientsEvent());
        }
        if (state is PatientListLoaded) {
          users = state.patients;
        }

        if (state is PatientListError) {
          return Center(
            child: Text(state.message),
          );
        }
        return LoadingOverlay(
          isLoading: state is UploadingPrescription,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: 'Upload Prescription',
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
                                      width: WidthManager.w8,
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
                          : selectedRecordType == 'TEXT'
                              ? CustomTextfield(
                                  label: 'Prescription',
                                  hintText: 'Write prescription here...',
                                  minLines: 6,
                                  maxLines: 6,
                                  onChanged: (p0) {
                                    recordText = p0;
                                  },
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
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
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
                    DropdownButton<User>(
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
                    const Divider(
                      color: gray200,
                      thickness: 1.5,
                    ),
                    const SizedBox(
                      height: HeightManager.h20,
                    ),
                  ],
                  Text(
                    'Type of Prescription',
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
                      color: selectedRecordType == 'PDF' ? gray700 : gray400,
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
                      color: selectedRecordType == 'Image' ? gray700 : gray400,
                      onTap: () {
                        setState(() {
                          selectedRecordType = 'Image';
                        });
                      },
                    ),
                    IconWithText(
                      icon: textIcon,
                      title: 'Text',
                      iconSize: 28,
                      color: selectedRecordType == 'TEXT' ? gray700 : gray400,
                      onTap: () {
                        setState(() {
                          selectedRecordType = 'TEXT';
                        });
                      },
                    ),
                  ]),
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
                        Map<String, dynamic> prescription = {};
                        if (selectedRecordType == 'PDF' && recordPdf == null) {
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
                        if (selectedRecordType == 'TEXT' && recordText.isEmpty){
                           Utils.showSnackBar(context, 'Please write prescription',
                              isSuccess: false);
                          return;
                        }
                        // upload record
                        if (doctor && selectedUser == null) {
                          Utils.showSnackBar(context, 'Please select a patient',
                              isSuccess: false);
                          return;
                        } else {
                          prescription['userId'] = selectedUser!.id;
                        }
                        if (selectedRecordType == 'TEXT' && recordText.isNotEmpty) {
                          prescription['prescriptionText'] = recordText;
                        } else
                        if (selectedRecordType == 'PDF' && recordPdf != null) {
                          prescription['prescription'] = await MultipartFile.fromFile(
                              recordPdf!.path,
                              filename: recordPdf!.path.split('/').last,
                              contentType: MediaType('application', 'pdf'));
                        }else if (selectedRecordType == 'Image' && recordImage != null) {
                          prescription['prescription'] = await MultipartFile.fromFile(
                              recordImage!.path,
                              filename: recordImage!.path.split('/').last,
                              contentType: MediaType('image', 'jpg'));
                        }
                        prescription['recordType'] =
                            selectedRecordType.toUpperCase();
                            if (Utils.checkInternetConnection(context)){

                        context.read<PrescriptionBloc>().add(
                            UploadPrescriptionEvent(
                                prescription: prescription));
                            }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
