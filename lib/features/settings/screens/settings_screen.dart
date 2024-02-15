// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
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
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_bloc.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_event.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_event.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_state.dart';
import 'package:user_mobile_app/features/settings/widgets/tileWithIcon.dart';
import 'package:user_mobile_app/features/settings/widgets/tileWithText.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool doctor = false;
  bool traditional = false;

  @override
  void initState() {
    super.initState();
    _initializeRole();
  }

  Future<void> _initializeRole() async {
    doctor = await isDoctor();
    traditional = await isTraditional();
    setState(() {});
  }

  Future<bool> isDoctor() async {
    if (await SharedUtils.getRole() == 'DOCTOR') {
      return true;
    }
    return false;
  }

  // authType
  Future<bool> isTraditional() async {
    if (await SharedUtils.getAuthType() == 'Traditional') {
      return true;
    }
    return false;
  }

  final _formKey = GlobalKey<FormState>();
  final feeController = TextEditingController();

  bool isFeeEdit = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User?;
    return BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }

        if (state is ChangeNotificationStatusSuccess) {
          setState(() {
            args!.textNotification = !args.textNotification!;
          });
        }

        if (state is ChangeNotificationStatusFailed) {
          Utils.showSnackBar(
            context,
            state.message,
            isSuccess: false,
          );
        }

        if (state is UpdateFeeSuccess) {
          setState(() {
            args!.fee = state.fee;
            isFeeEdit = false;
          });
          Utils.showSnackBar(
            context,
            'Profile updated successfully',
            isSuccess: true,
          );
        }

        if (state is UpdateFeeFailed) {
          Utils.showSnackBar(
            context,
            state.message,
            isSuccess: false,
          );
        }

        if (state is UpdateAddressSuccess) {
          Utils.showSnackBar(
            context,
            'Profile updated successfully',
            isSuccess: true,
          );
          context.read<DocHomeBloc>().add(GetDocHome());
          Navigator.pushReplacementNamed(
            context,
            'doctor_home_screen',
          );
        }

        if (state is UpdateAddressFailed) {
          Utils.showSnackBar(
            context,
            state.message,
            isSuccess: false,
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is UpdatingAddress || state is UpdateFeeLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900, size: 60),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: 'Settings',
                isBackButton: true,
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: PaddingManager.paddingMedium2,
                vertical: PaddingManager.p8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: FontSizeManager.f18,
                      color: gray800,
                      fontWeight: FontWeightManager.semiBold,
                    ),
                  ),
                  TileWithIcon(
                    text: 'Update Profile',
                    icon: Icons.edit,
                    color: blue500,
                    onTap: () => Navigator.pushNamed(
                      context,
                      'update_profile_screen',
                      arguments: args,
                    ),
                  ),
                  if (args!.authType == 'Traditional') ...[
                    TileWithIcon(
                      text: 'Change Password',
                      icon: Icons.lock,
                      color: red500,
                      onTap: () => Navigator.pushNamed(
                        context,
                        'change_password_screen',
                      ),
                    ),
                  ],
                  if (doctor == true) ...[
                    TileWithIcon(
                      text: 'Change Speciality',
                      icon: Icons.medical_services,
                      color: yellow300,
                      onTap: () => Navigator.pushNamed(
                        context,
                        'change_speciality_screen',
                      ),
                    ),
                    TileWithIcon(
                      text: 'Qualifications',
                      icon: Icons.card_membership_rounded,
                      color: green500,
                      onTap: () => Navigator.pushNamed(
                        context,
                        'my_qualification_screen',
                      ),
                    ),
                  ],
                  TileWithIcon(
                    text: 'About Us',
                    icon: CupertinoIcons.person_2_fill,
                    color: orange500,
                    onTap: () => Navigator.pushNamed(
                      context,
                      'about_us_screen',
                    ),
                  ),
                  const SizedBox(
                    height: HeightManager.h20,
                  ),
                  Text(
                    'More Options',
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: FontSizeManager.f18,
                      color: gray800,
                      fontWeight: FontWeightManager.semiBold,
                    ),
                  ),
                  TileWithText(
                    notification: args.textNotification ?? true,
                    text: 'Text messages Notification',
                    isSwitch: true,
                    onChanged: (value) {
                      if (state is ChangeNotificationStatusLoading) return;
                      context.read<UpdateProfileBloc>().add(
                            ChangeNotificationStatus(
                              data: {'textNotification': value},
                            ),
                          );
                    },
                  ),
                  if (doctor == true) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'update_address',
                        ).then((value) {
                          if (value != null) {
                            context.read<UpdateProfileBloc>().add(
                                  UpdateAddressEvent(
                                    data: value as Map<String, dynamic>,
                                  ),
                                );
                          }
                        });
                      },
                      child: TileWithText(
                        text: 'Address',
                        isSwitch: false,
                        value: args.address ?? '-',
                      ),
                    ),
                    if (isFeeEdit)
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'fee',
                            hintText: '120',
                            suffixIcon: Icon(
                              CupertinoIcons.creditcard_fill,
                              size: 24,
                              color: gray500,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: PaddingManager.p6,
                              vertical: PaddingManager.p5,
                            ),
                          ),
                          controller: feeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fee';
                            }

                            if (int.tryParse(value) == null) {
                              return 'Please enter valid fee';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              context.read<UpdateProfileBloc>().add(
                                    UpdateFeeEvent(
                                      data: {'fee': int.parse(value)},
                                    ),
                                  );
                            }
                          },
                          onTapOutside: (event) {
                            setState(() {
                              isFeeEdit = false;
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          if (state is UpdateFeeLoading) return;
                          setState(() {
                            feeController.text =
                                args.fee != null ? args.fee.toString() : '';
                            isFeeEdit = true;
                          });
                        },
                        child: TileWithText(
                          text: 'Fee/Appointment',
                          isSwitch: false,
                          value: 'NPR ${args.fee ?? '-'}',
                        ),
                      ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
