import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_event.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_state.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool hideOldPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;
  bool isMatch = true;

  checkPassword() {
    print('check..');
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        isMatch = true;
      });
    } else if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        isMatch = false;
      });
    } else {
      setState(() {
        isMatch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

        if (state is ChangePasswordSuccess) {
          Utils.showSnackBar(context, 'Password changed successfully',
              isSuccess: true);

          Navigator.pop(context);
        }

        if (state is ChangePasswordFailed) {
          showDialog(
            context: context,
            builder: (context) {
              return Utils.errorDialog(
                context,
                state.message,
                onPressed: () => Navigator.pop(context),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is ChangePasswordLoading,
          child: Scaffold(
            appBar: const PreferredSize(
                preferredSize: Size.fromHeight(HeightManager.h73),
                child: AppBarCustomWithSceenTitle(
                  title: 'Change Password',
                  isBackButton: true,
                )),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextfield(
                      label: '',
                      hintText: 'Current Password',
                      controller: _oldPasswordController,
                      suffixPressed: () {
                        setState(() {
                          hideOldPassword = !hideOldPassword;
                        });
                      },
                      bottomPadding: 18,
                      obscure: hideOldPassword,
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your current password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      suffixIcon: hideOldPassword
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: gray400,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: gray400,
                            ),
                    ),
                    CustomTextfield(
                      label: '',
                      hintText: 'New Password',
                      controller: _newPasswordController,
                      onChanged: (p0) {
                        checkPassword();
                      },
                      suffixPressed: () {
                        setState(() {
                          hideNewPassword = !hideNewPassword;
                        });
                      },
                      bottomPadding: 18,
                      obscure: hideNewPassword,
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your new password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      suffixIcon: hideNewPassword
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: gray400,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: gray400,
                            ),
                    ),
                    CustomTextfield(
                      label: '',
                      hintText: 'Re-enter Password',
                      onChanged: (p0) {
                        checkPassword();
                      },
                      suffixPressed: () {
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      },
                      bottomPadding: 18,
                      controller: _confirmPasswordController,
                      obscure: hideConfirmPassword,
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please re-enter your new password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      suffixIcon: hideConfirmPassword
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: gray400,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: gray400,
                            ),
                    ),
                    if (!isMatch) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Password does not match',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: FontSizeManager.f12,
                            fontWeight: FontWeightManager.regular,
                            color: errorColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: HeightManager.h12,
                      )
                    ],
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomButtom(
                title: 'Change Password',
                onPressed: () {
                  if (_formKey.currentState!.validate() && isMatch) {
                    context.read<UpdateProfileBloc>().add(
                          ChangePassword(
                            data: {
                              'oldPassword': _oldPasswordController.text,
                              'newPassword': _newPasswordController.text,
                            },
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
