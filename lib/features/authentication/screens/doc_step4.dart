// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/image_picker.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_event.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_state.dart';
import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';
import 'package:user_mobile_app/widgets/custom_outlined_button.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';
// import 'package:http_parser/http_parser.dart';

formatDate(String dateTime) {
  DateTime date = DateTime.parse(dateTime);
  return "${date.year}-${date.month}-${date.day}";
}

class DocStep4 extends StatefulWidget {
  const DocStep4({super.key});

  @override
  State<DocStep4> createState() => _DocStep4State();
}

class _DocStep4State extends State<DocStep4> {
  final _formKey = GlobalKey<FormState>();

  final _khaltiIdController = TextEditingController();
  FocusNode? _khaltiIdFocusNode;

  List<DocQualification> qualificationList = [];

  checkEachQualification(List<DocQualification> qualificationList) {
    if (qualificationList.isEmpty) {
      Utils.showSnackBar(context, 'Please add atleast one qualification.',
          isSuccess: false);
      return false;
    }
    return true;
  }

  fetchQualification(String doctorId) {
    context
        .read<MoreDocDetailsBloc>()
        .add(GetDocQualificationEvent(doctorId: doctorId));
  }

  Widget showImageDialog(BuildContext context, Qualification qualification) {
    return SimpleDialog(
      title: const Text('Select Image'),
      children: [
        SimpleDialogOption(
          onPressed: () async {
            qualification.image =
                await ImagePick.pickImage(source: ImageSource.camera);
            if (qualification.image != null) {
              Navigator.pop(context);
            }
            setState(() {});
          },
          child: const Text('Camera'),
        ),
        SimpleDialogOption(
          onPressed: () async {
            qualification.image =
                await ImagePick.pickImage(source: ImageSource.gallery);
            if (qualification.image != null) {
              Navigator.pop(context);
            }
            setState(() {});
          },
          child: const Text('Gallery'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    TextTheme textTheme = theme.textTheme;

    return BlocConsumer<MoreDocDetailsBloc, MoreDocDetailsState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is MoreDocDetailsSuccess) {
          Utils.showSnackBar(context, 'Details uploaded successfully.',
              isSuccess: true);
          Navigator.pushReplacementNamed(context, 'login_screen');
        }
        if (state is MoreDocDetailsFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }

        if (state is GetDocQualificationSuccess) {
          qualificationList = state.qualifications;
        }

        if (state is GetDocQualificationFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }

        if (state is DeleteDocQualificationSuccess) {
          Utils.showSnackBar(context, 'Qualification deleted successfully.',
              isSuccess: true);
          fetchQualification(args!);
        }
        if (state is DeleteDocQualificationFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          isLoading: context.watch<MoreDocDetailsBloc>().state
              is MoreDocDetailsLoading,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PaddingManager.padding,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: HeightManager.h50,
                        ),
                        Row(
                          children: [
                            Text(
                              "More Details",
                              style: TextStyle(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontSize: FontSizeManager.f32,
                                fontWeight: FontWeightManager.semiBold,
                                color: gray900,
                              ),
                            ),
                            const Spacer(),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Step ',
                                    style: textTheme.displaySmall!.copyWith(
                                      fontSize: FontSizeManager.f14,
                                      fontWeight: FontWeightManager.regular,
                                      color: gray500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '4',
                                    style: textTheme.displaySmall!.copyWith(
                                      fontSize: FontSizeManager.f14,
                                      fontWeight: FontWeightManager.bold,
                                      color: red500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '/4',
                                    style: textTheme.displaySmall!.copyWith(
                                      fontSize: FontSizeManager.f14,
                                      fontWeight: FontWeightManager.regular,
                                      color: gray500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: HeightManager.h12,
                        ),
                        Text(
                          "Please Provide Us Your details for completing your profile.",
                          style: TextStyle(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            fontSize: FontSizeManager.f16,
                            fontWeight: FontWeightManager.regular,
                            color: gray400,
                          ),
                        ),
                        const SizedBox(
                          height: HeightManager.h32,
                        ),
                        for (DocQualification qualification
                            in qualificationList) ...[
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                border: Border.all(
                                  color: gray200,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: WidthManager.w16,
                                      vertical: HeightManager.h16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              qualification.title ?? "Title",
                                              style: TextStyle(
                                                  fontFamily:
                                                      GoogleFonts.inter()
                                                          .fontFamily,
                                                  fontSize: FontSizeManager.f18,
                                                  fontWeight: FontWeightManager
                                                      .semiBold,
                                                  color: gray900,
                                                  letterSpacing: 0.5),
                                            ),
                                            const SizedBox(
                                              height: HeightManager.h8,
                                            ),
                                            Text(
                                              qualification.institute ??
                                                  "Institute",
                                              style: TextStyle(
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                  fontSize: FontSizeManager.f14,
                                                  fontWeight:
                                                      FontWeightManager.medium,
                                                  color: gray600,
                                                  letterSpacing: 0.5),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Pass out year",
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.inter()
                                                    .fontFamily,
                                                fontSize: FontSizeManager.f16,
                                                fontWeight:
                                                    FontWeightManager.medium,
                                                color: gray600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: HeightManager.h8,
                                            ),
                                            Text(
                                              qualification.passOutYear != null
                                                  ? formatDate(qualification
                                                      .passOutYear!)
                                                  : "yyyy-mm-dd",
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.inter()
                                                    .fontFamily,
                                                fontSize: FontSizeManager.f14,
                                                fontWeight:
                                                    FontWeightManager.medium,
                                                color: gray600,
                                                letterSpacing: 0.5,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: HeightManager.h8,
                                  ),
                                  InkWell(
                                    // onTap: () => showDialog(
                                    //   context: context,
                                    //   builder: (context) => showImageDialog(
                                    //     context,
                                    //     add,
                                    //   ),
                                    // ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: WidthManager.w16,
                                        vertical: HeightManager.h16,
                                      ),
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: gray100,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Certificate Photo",
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                              fontSize: FontSizeManager.f18,
                                              fontWeight:
                                                  FontWeightManager.semiBold,
                                              color: gray900,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: HeightManager.h8,
                                          ),
                                          Text(
                                            "Please provide a clear potrait picture of certificate. ",
                                            style: TextStyle(
                                              fontFamily:
                                                  GoogleFonts.montserrat()
                                                      .fontFamily,
                                              fontSize: FontSizeManager.f14,
                                              fontWeight:
                                                  FontWeightManager.medium,
                                              color: gray600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: HeightManager.h8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (qualificationList
                                                      .isEmpty) {
                                                    return;
                                                  }
                                                  context
                                                      .read<
                                                          MoreDocDetailsBloc>()
                                                      .add(
                                                          DeleteDocQualificationEvent(
                                                              doctorId: args!,
                                                              qualificationId:
                                                                  qualification
                                                                          .id ??
                                                                      ''));
                                                },
                                                child: const Icon(
                                                  CupertinoIcons.delete,
                                                  color: red600,
                                                ),
                                              ),
                                              CustomOutlineButtom(
                                                title: 'Edit',
                                                widget: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.edit,
                                                      color: blue900,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter()
                                                                .fontFamily,
                                                        fontSize:
                                                            FontSizeManager.f16,
                                                        fontWeight:
                                                            FontWeightManager
                                                                .medium,
                                                        color: blue900,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      'qualification_screen',
                                                      arguments: {
                                                        'doctorId': args,
                                                        'qualification': {
                                                          'qualificationId':
                                                              qualification
                                                                      .id ??
                                                                  '',
                                                          'title': qualification
                                                                  .title ??
                                                              '',
                                                          'institute':
                                                              qualification
                                                                      .institute ??
                                                                  '',
                                                          'passOutYear':
                                                              qualification
                                                                      .passOutYear ??
                                                                  '',
                                                          'image': qualification
                                                                  .image ??
                                                              '',
                                                        },
                                                      }).then(
                                                    (value) {
                                                      if (value == null) {
                                                        return;
                                                      }

                                                      fetchQualification(args!);
                                                    },
                                                  );
                                                },
                                              ),
                                              // Container(
                                              //   alignment: Alignment.center,
                                              //   padding:
                                              //       const EdgeInsets.symmetric(
                                              //     horizontal: WidthManager.w16,
                                              //     vertical: HeightManager.h16,
                                              //   ),
                                              //   decoration: BoxDecoration(
                                              //     border: Border.all(
                                              //       color: blue900,
                                              //       width: 2,
                                              //     ),
                                              //     borderRadius:
                                              //         BorderRadius.circular(5),
                                              //   ),
                                              //   child: Text(
                                              //     qualification.image != null
                                              //         ? "Change Photo"
                                              //         : "Upload Photo",
                                              //     style: TextStyle(
                                              //       fontFamily:
                                              //           GoogleFonts.inter()
                                              //               .fontFamily,
                                              //       fontSize:
                                              //           FontSizeManager.f16,
                                              //       fontWeight:
                                              //           FontWeightManager
                                              //               .semiBold,
                                              //       color: blue900,
                                              //       letterSpacing: 0.5,
                                              //     ),
                                              //   ),
                                              // )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: HeightManager.h16,
                          ),
                        ],
                        const SizedBox(
                          height: HeightManager.h32,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'qualification_screen',
                                arguments: {
                                  'doctorId': args,
                                }).then(
                              (value) {
                                if (value == null) {
                                  return;
                                }

                                fetchQualification(args!);
                              },
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: WidthManager.w16,
                              vertical: HeightManager.h16,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                              border: Border.all(
                                color: blue900,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              "+ Add ${qualificationList.isEmpty ? '' : 'More '}Qualification",
                              style: TextStyle(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontSize: FontSizeManager.f18,
                                fontWeight: FontWeightManager.bold,
                                color: blue900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: HeightManager.h18,
                        ),
                        CustomTextfield(
                          label: "Khalti ID",
                          hintText: "9845612378",
                          controller: _khaltiIdController,
                          focusNode: _khaltiIdFocusNode,
                          textInputType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your khalti id";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: HeightManager.h32,
                        ),
                        CustomButtom(
                          title: "Upload Details",
                          onPressed: () async {
                            if (!checkEachQualification(qualificationList)) {
                              return;
                            }
                            if (_formKey.currentState!.validate() &&
                                args != null) {
                              context.read<MoreDocDetailsBloc>().add(
                                      AddMoreDocDetailsEvent(
                                          doctorId: args,
                                          details: {
                                        'khaltiId':
                                            _khaltiIdController.text.trim(),
                                      }));
                            }
                          },
                        ),
                        const SizedBox(
                          height: HeightManager.h50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
