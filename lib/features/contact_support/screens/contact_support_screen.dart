import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/contact_support/bloc/contact_bloc/contact_bloc.dart';
import 'package:user_mobile_app/features/contact_support/bloc/contact_bloc/contact_event.dart';
import 'package:user_mobile_app/features/contact_support/bloc/contact_bloc/contact_state.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final emailController = TextEditingController();
  final queriesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void perform() {
    if (Utils.checkInternetConnection(context)) {
      context.read<ContactBloc>().add(
            ContactFormSubmitted(
              email: emailController.text,
              message: queriesController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }
        if (state is ContactSuccess) {
          Navigator.pop(context);
          Utils.showSnackBar(context, state.message, isSuccess: true);
        }
        if (state is ContactFailed) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is ContactLoading,
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBarCustomWithSceenTitle(
                title: 'Contact Support',
                isBackButton: true,
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingMedium2,
                vertical: PaddingManager.paddingMedium2,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextfield(
                      label: 'Email',
                      hintText: 'johndoe@gmail.com',
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (EmailValidator.validate(value) == false) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      suffixIcon: const Icon(
                        CupertinoIcons.mail,
                        color: gray500,
                      ),
                    ),
                    CustomTextfield(
                      label: 'Queries',
                      hintText: 'Write Your Queries...',
                      minLines: 5,
                      maxLines: 5,
                      controller: queriesController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter queries';
                        }
                        if (value.length < 10) {
                          return 'Please enter valid queries';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingMedium2,
                vertical: PaddingManager.paddingMedium2,
              ),
              child: CustomButtom(
                title: 'Submit',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    perform();
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
