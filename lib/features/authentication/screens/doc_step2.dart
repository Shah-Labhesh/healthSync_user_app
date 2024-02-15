import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_event.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_state.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';

class DocStep2 extends StatefulWidget {
  const DocStep2({super.key});

  @override
  State<DocStep2> createState() => _DocStep2State();
}

class _DocStep2State extends State<DocStep2> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return BlocConsumer<DocAddressBloc, DocAddressState>(
      listener: (context, state) {
        if (state is DocAddressSuccess) {
          Utils.showSnackBar(context, 'Address uploaded successfully.',
              isSuccess: true);
          Navigator.pushNamed(context, 'doc_step3', arguments: args);
        }
        if (state is DocAddressFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: LoadingAnimationWidget.threeArchedCircle(
            color: blue900,
            size: 60,
          ),
          isLoading: context.watch<DocAddressBloc>().state is DocAddressLoading,
          child: Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.padding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: HeightManager.h50,
                    ),
                    Row(
                      children: [
                        Text(
                          "Location",
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
                                text: '2',
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
                      "Please Provide Us Your Location.",
                      style: TextStyle(
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontSize: FontSizeManager.f16,
                        fontWeight: FontWeightManager.regular,
                        color: gray400,
                      ),
                    ),
                    const SizedBox(
                      height: HeightManager.h64,
                    ),
                    Center(
                        child: Image.asset(
                      AppImages.locationImage,
                      height: HeightManager.h266,
                    )),
                    const SizedBox(
                      height: HeightManager.h80,
                    ),
                    Center(
                      child: Text(
                        "Your location can help user to find you. Select location using google map.",
                        style: TextStyle(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontSize: FontSizeManager.f16,
                          fontWeight: FontWeightManager.regular,
                          color: gray400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: HeightManager.h40,
                    ),
                    CustomButtom(
                        title: "Select Location",
                        onPressed: () {
                          if (args == null || args.isEmpty) {
                            Utils.showSnackBar(context,
                                'Please fill the previous steps first.',
                                isSuccess: false);
                            return;
                          }
                          if (Utils.checkInternetConnection(context)) {
                            Navigator.pushNamed(context, 'map_screen')
                                .then((value) => {
                                      if (value != null || args.isEmpty)
                                        {
                                          context.read<DocAddressBloc>().add(
                                              AddAddressEvent(
                                                  doctorId: args,
                                                  address: value
                                                      as Map<String, dynamic>))
                                        }
                                    });
                          }
                        }),
                    const SizedBox(
                      height: HeightManager.h50,
                    ),
                  ],
                ),
              ),
            )),
          ),
        );
      },
    );
  }
}
