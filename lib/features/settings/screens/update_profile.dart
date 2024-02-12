// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/image_picker.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/bloc/account_bloc.dart';
import 'package:user_mobile_app/features/account/bloc/account_event.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_bloc.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_event.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_event.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_state.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';
import 'package:http_parser/http_parser.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _khaltiIdController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  bool doctor = false;

  User? user;

  @override
  void initState() {
    super.initState();
    _initializeRole();
  }

  Future<void> _initializeRole() async {
    doctor = await isDoctor();
    setState(() {});
  }

  Future<bool> isDoctor() async {
    if (await SharedUtils.getRole() == 'DOCTOR') {
      return true;
    }
    return false;
  }

  final _formKey = GlobalKey<FormState>();

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
    final args = ModalRoute.of(context)!.settings.arguments as User?;
    if (args == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    _nameController.text = args.name ?? '';
    _emailController.text = args.email ?? '';
    _khaltiIdController.text = args.khaltiId ?? '';
    _experienceController.text = args.experience ?? '';
    user = args;

    return BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is TokenExpired) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'login_screen', (route) => false);

          showDialog(
            context: context,
            builder: (context) {
              return Utils.errorDialog(
                context,
                "Token Expired Please login again",
                onPressed: () => Navigator.pop(context),
              );
            },
          );
        }
        if (state is UpdateProfileSuccess) {
          if (doctor) {
            Utils.showSnackBar(context, 'Profile Updated Successfully',
                isSuccess: true);
            context.read<DocHomeBloc>().add(GetDocHome());
            Navigator.pushReplacementNamed(
              context,
              'doctor_home_screen',
            );
          } else {
            Utils.showSnackBar(context, 'Profile Updated Successfully',
                isSuccess: true);
            context.read<AccountBloc>().add(FetchCurrentUserEvent());
            Navigator.pushReplacementNamed(context, 'user_home_screen',
                arguments: 3);
          }
        }
        if (state is UpdateProfileFailed) {
          showDialog(
            context: context,
            builder: (context) {
              return Utils.errorDialog(context, state.message,
                  onPressed: () => Navigator.pop(context));
            },
          );
        }
        if (state is EmailVerificationState) {
          showDialog(
            context: context,
            builder: (context) {
              return Utils.errorDialog(context, 'Email Verification Required',
                  onPressed: () => Navigator.pop(context));
            },
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is UpdateProfileLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: 'Update Profile',
                isBackButton: true,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: WidthManager.w20,
                  vertical: HeightManager.h20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                              : args.avatar != null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            BASE_URL + args.avatar!,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value: downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Icon(Icons.error),
                                        ),
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
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
                                builder: (context) => showImageDialog(context),
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
                        height: HeightManager.h20,
                      ),
                      CustomTextfield(
                        label: 'Name',
                        hintText: 'Enter your name',
                        controller: _nameController,
                        suffixIcon:
                            const Icon(Icons.person_outline, color: gray400),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          if (value.length < 3) {
                            return 'Name must be at least 3 characters long';
                          }
                          return null;
                        },
                      ),
                      if (args.authType == 'Traditional')
                        CustomTextfield(
                          label: 'Email',
                          hintText: 'Enter your email',
                          controller: _emailController,
                          suffixIcon:
                              const Icon(Icons.email_outlined, color: gray400),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            if (EmailValidator.validate(value) == false) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      if (doctor) ...[
                        CustomTextfield(
                          label: 'Khalti Id',
                          hintText: 'Enter your khalti id',
                          controller: _khaltiIdController,
                          suffixIcon: const Icon(Icons.payment_outlined,
                              color: gray400),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Khalti Id cannot be empty';
                            }
                            if (value.length != 10) {
                              return 'Khalti Id must be 10 characters long';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Khalti Id must be a number';
                            }
                            return null;
                          },
                        ),
                        CustomTextfield(
                          label: 'Experience',
                          hintText: 'Share your experience...',
                          controller: _experienceController,
                          minLines: 4,
                          maxLines: 4,
                          suffixIcon:
                              const Icon(Icons.work_outline, color: gray400),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Experience cannot be empty';
                            }
                            if (value.length < 10) {
                              return 'Experience must be at least 10 characters long';
                            }
                            return null;
                          },
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: WidthManager.w20,
                vertical: HeightManager.h20,
              ),
              child: CustomButtom(
                title: 'Update Profile',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> data = {};
                    if (_nameController.text != user!.name) {
                      data['name'] = _nameController.text;
                    }
                    if (_emailController.text.trim() != user!.email) {
                      data['email'] = _emailController.text;
                    }
                    if (_khaltiIdController.text != user!.khaltiId &&
                        doctor == true) {
                      data['khaltiId'] = _khaltiIdController.text;
                    }
                    if (_experienceController.text != user!.experience &&
                        doctor == true) {
                      data['experience'] = _experienceController.text;
                    }
                    if (image != null) {
                      data['profileImage'] = await MultipartFile.fromFile(
                          image!.path,
                          filename: 'image.jpg',
                          contentType: MediaType('image', 'jpg'));
                    }
                    context.read<UpdateProfileBloc>().add(
                          UpdateProfile(
                            data: data,
                          ),
                        );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
