// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/settings/bloc/qualification_bloc/qualification_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/qualification_bloc/qualification_event.dart';
import 'package:user_mobile_app/features/settings/bloc/qualification_bloc/qualification_state.dart';

import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_outlined_button.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';
import 'package:http_parser/http_parser.dart';

class AuthQualificationScreen extends StatefulWidget {
  const AuthQualificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthQualificationScreen> createState() =>
      _AuthQualificationScreenState();
}

class _AuthQualificationScreenState extends State<AuthQualificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _instituteController = TextEditingController();
  final _passoutYearController = TextEditingController();
  DateTime? passed;
  File? _certificate;

  Widget showImageDialog(
    BuildContext context,
  ) {
    return SimpleDialog(
      title: const Text('Select Image'),
      children: [
        SimpleDialogOption(
          onPressed: () async {
            _certificate =
                await ImagePick.pickImage(source: ImageSource.camera);
            if (_certificate != null) {
              Navigator.pop(context);
            }
            setState(() {});
          },
          child: const Text('Camera'),
        ),
        SimpleDialogOption(
          onPressed: () async {
            _certificate =
                await ImagePick.pickImage(source: ImageSource.gallery);
            if (_certificate != null) {
              Navigator.pop(context);
            }
            setState(() {});
          },
          child: const Text('Gallery'),
        ),
      ],
    );
  }

  formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return '${date.year}-${date.month}-${date.day}';
  }

  setData(Map<String, dynamic> args) {
    _titleController.text = args['qualification']['title'];
    _instituteController.text = args['qualification']['institute'];
    _passoutYearController.text =
        formatDate(args['qualification']['passOutYear']);
  }

  Map<String, dynamic> prepareData() {
    Map<String, dynamic> data = {};
    if (_titleController.text.isNotEmpty) {
      data['qualification'] = _titleController.text.trim();
    }
    if (_instituteController.text.isNotEmpty) {
      data['institute'] = _instituteController.text.trim();
    }
    if (passed != null) {
      data['passOutYear'] = passed!.toIso8601String();
    }
    if (_certificate != null) {
      data['certificate'] = MultipartFile.fromFileSync(
        _certificate!.path,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpg'),
      );
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['qualification'] != null) {
      setData(args);
    }
    return BlocConsumer<QualificationBloc, QualificationState>(
      listener: (context, state) {
        if (state is QualificationAdded) {
          Navigator.pop(context, state.qualification);
        }
        if (state is QualificationAddingFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
        if (state is QualificationUpdated) {
          Navigator.pop(context, state.qualification);
        }
        if (state is QualificationUpdatingFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: context.watch<QualificationBloc>().state
                  is QualificationAdding ||
              context.watch<QualificationBloc>().state is QualificationUpdating,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900, size: 60),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: args == null || args['qualification'] == null
                    ? 'Add Qualification'
                    : 'Edit Qualification',
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingMedium2,
                vertical: PaddingManager.paddingMedium2,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: HeightManager.h20,
                      ),
                      CustomTextfield(
                        label: 'Title',
                        hintText: 'MBBS',
                        controller: _titleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                      ),
                      CustomTextfield(
                        label: 'Institute',
                        hintText: 'Institute',
                        controller: _instituteController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter institute';
                          }
                          return null;
                        },
                      ),
                      CustomTextfield(
                        label: 'Pass out year',
                        hintText: 'yyyy-mm-dd',
                        controller: _passoutYearController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please select passout year from calendar';
                          }
                          return null;
                        },
                        suffixIcon: const Icon(
                          Icons.calendar_month_rounded,
                          color: blue900,
                          size: 28,
                        ),
                        readOnly: true,
                        suffixPressed: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          passed = date;
                          if (date != null) {
                            _passoutYearController.text =
                                '${date.year}-${date.month}-${date.day}';
                          }
                        },
                      ),
                      if (args == null || args['qualification'] == null)
                        InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => showImageDialog(
                              context,
                            ),
                          ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Certificate Photo",
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontSize: FontSizeManager.f18,
                                    fontWeight: FontWeightManager.semiBold,
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
                                        GoogleFonts.montserrat().fontFamily,
                                    fontSize: FontSizeManager.f14,
                                    fontWeight: FontWeightManager.medium,
                                    color: gray600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(
                                  height: HeightManager.h8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: WidthManager.w16,
                                        vertical: HeightManager.h16,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: blue900,
                                          width: WidthManager.w2,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        _certificate != null
                                            ? "Change Photo"
                                            : "Upload Photo",
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.inter().fontFamily,
                                          fontSize: FontSizeManager.f16,
                                          fontWeight:
                                              FontWeightManager.semiBold,
                                          color: blue900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      else ...[
                        Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: HeightManager.h240,
                            decoration: BoxDecoration(
                             
                              border: Border.all(
                                color: gray200,
                                width: WidthManager.w2,
                              ),
                              color: gray100,
                              borderRadius: BorderRadius.circular(
                                4,
                              ),
                            ),
                            child: _certificate != null
                                ? Image.file(
                                    _certificate!,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: BASE_URL +
                                        args['qualification']['image'],
                                    fit: BoxFit.cover,
                                  )),
                        const SizedBox(
                          height: HeightManager.h20,
                        ),
                        CustomOutlineButtom(
                          title: 'Change Photo',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => showImageDialog(
                                context,
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(
                        height: HeightManager.h20,
                      ),
                      CustomButtom(
                        title: args == null || args['qualification'] == null
                            ? 'Save'
                            : 'Update Qualification',
                        onPressed: () async {
                          if (_certificate == null &&
                              (args == null || args['qualification'] == null)) {
                            Utils.showSnackBar(
                              context,
                              'Please upload certificate image',
                              isSuccess: false,
                            );
                            return;
                          }
                          if (Utils.checkInternetConnection(context) == false){
                            return;
                          }
                          if (args != null ) {
                            context.read<QualificationBloc>().add(
                                  UpdateQualification(
                                    id: args['qualification']['id'],
                                    body: prepareData(),
                                  ),
                                );
                          } else if (_formKey.currentState!.validate()) {
                            context.read<QualificationBloc>().add(
                                  AddQualification(
                                    body: {
                                      'title': _titleController.text.trim(),
                                      'institute': _instituteController.text.trim(),
                                      'passOutYear': passed!.toIso8601String(),
                                      'certificate':
                                          await MultipartFile.fromFile(
                                        _certificate!.path,
                                        filename: 'image.jpg',
                                        contentType: MediaType('image', 'jpg'),
                                      ),
                                    },
                                  ),
                                );
                          }
                        },
                      ),
                    ],
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
