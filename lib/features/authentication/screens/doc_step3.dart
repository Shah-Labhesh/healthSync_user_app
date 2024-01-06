import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/image_picker.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_event.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_state.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';
import 'package:http_parser/http_parser.dart';


class DocStep3 extends StatefulWidget {
  const DocStep3({super.key});

  @override
  State<DocStep3> createState() => _DocStep3State();
}

class _DocStep3State extends State<DocStep3> {
  final _formKey = GlobalKey<FormState>();

  final _specialityController = TextEditingController();
  final _feeController = TextEditingController();
  final _experienceController = TextEditingController();
  FocusNode? _specialityFocusNode;
  FocusNode? _feeFocusNode;
  FocusNode? _experienceFocusNode;

  File? image;

  Widget showImageDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Image'),
      children: [
        SimpleDialogOption(
          onPressed: () async {
            image = await ImagePick.pickImage(source: ImageSource.camera);
            if (image != null) {
              Navigator.pop(context);
            }
            setState(() {});
          },
          child: const Text('Camera'),
        ),
        SimpleDialogOption(
          onPressed: () async {
            image = await ImagePick.pickImage(source: ImageSource.gallery);
            if (image != null) {
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
    return BlocConsumer<DocDetailsBloc, DocDetailsState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is DocDetailsFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
        if (state is DocDetailsSuccess) {
          Utils.showSnackBar(context, 'Details uploaded successfully.',
              isSuccess: true);
          Navigator.pushNamed(context, 'doc_step4',arguments: args);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          isLoading: context.watch<DocDetailsBloc>().state is DocDetailsLoading,
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
                              "Details",
                              style: TextStyle(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontSize: FontSizeManager.f32,
                                fontWeight: FontWeightManager.semiBold,
                                color: gray900,
                              ),
                            ),
                            Spacer(),
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
                                    text: '3',
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
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            image != null
                                ? Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(60),
                                      ),
                                      image: DecorationImage(
                                        image: FileImage(image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 120,
                                    width: 120,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(60),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          AppImages.defaultAvatar,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      showImageDialog(context),
                                );
                              },
                              child: Image.asset(
                                pickImageIcon,
                                height: 45,
                                width: 45,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: HeightManager.h18,
                        ),
                        CustomTextfield(
                          label: "Speciality",
                          hintText: "Dentist",
                          controller: _specialityController,
                          focusNode: _specialityFocusNode,
                          textInputType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your speciality";
                            }
                            return null;
                          },
                        ),
                        CustomTextfield(
                          label: "Fee/Appointment",
                          hintText: "NRs. 500",
                          suffixIcon: const Icon(
                            Icons.money_outlined,
                            color: gray400,
                          ),
                          controller: _feeController,
                          focusNode: _feeFocusNode,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your fee per appointment";
                            }

                            return null;
                          },
                        ),
                        CustomTextfield(
                          label: "Experience",
                          hintText: "Share Your Experience",
                          minLines: 4,
                          maxLines: 4,
                          controller: _experienceController,
                          focusNode: _experienceFocusNode,
                          textInputType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your experience";
                            }
                            if (value.length < 20) {
                              return "Password must be at least 20 characters";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(
                          height: HeightManager.h32,
                        ),
                        CustomButtom(
                          title: "Next",
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                image != null &&
                                args != null) {
                              context
                                  .read<DocDetailsBloc>()
                                  .add(AddDocDetailsEvent(
                                      doctorId: args,
                                      details: FormData.fromMap({
                                        'speciality':
                                            _specialityController.text,
                                        'fee': _feeController.text,
                                        'experience':
                                            _experienceController.text,
                                        'image': await MultipartFile.fromFile(
                                          image!.path,
                                          filename: 'image.jpg',
                                          contentType:
                                              MediaType('image', 'jpg'),
                                        ),
                                      })));
                              // Navigator.pushReplacementNamed(context, 'doc_step4');
                            } else {
                              Utils.showSnackBar(
                                  context, 'Please fill all the details',
                                  isSuccess: false);
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
