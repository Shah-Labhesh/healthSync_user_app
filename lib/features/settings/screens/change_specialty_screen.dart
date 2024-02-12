import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/authentication/data/model/specialities.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_event.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_state.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';

class ChangeSpecialtyScreen extends StatefulWidget {
  const ChangeSpecialtyScreen({super.key});

  @override
  State<ChangeSpecialtyScreen> createState() => _ChangeSpecialtyScreenState();
}

class _ChangeSpecialtyScreenState extends State<ChangeSpecialtyScreen> {
  List<Specialities> specialities = [];
  int? selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UpdateProfileBloc>().add(FetchSpecialitiesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'Change Specialty',
          isBackButton: true,
        ),
      ),
      body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is TokenExpired) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'login_screen', (route) => false);
            Utils.showSnackBar(context, 'Token Expired Please Login Again',
                isSuccess: false);
          }

          if (state is FetchSpecialitiesSuccess) {
            specialities = state.specialities;
          }

          if (state is UpdateSpecialitiesSuccess) {
            Utils.showSnackBar(context, 'Speciality Updated Successfully');
            Navigator.pop(context);
          }

          if (state is UpdateSpecialitiesFailed) {
            Utils.showSnackBar(context, state.message, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is FetchSpecialitiesFailed) {
            return Center(
              child: Text(state.message),
            );
          }
          return LoadingOverlay(
            isLoading: state is UpdatingSpecialities,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.paddingMedium2,
                  vertical: PaddingManager.paddingSmall,
                ),
                child: Column(
                  children: [
                    Text(
                      "Specialities",
                      style: TextStyle(
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontSize: FontSizeManager.f16,
                        fontWeight: FontWeightManager.semiBold,
                        color: gray900,
                      ),
                    ),
                    const SizedBox(
                      height: HeightManager.h12,
                    ),
                    if (state is FetchingSpecialities)
                      Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: blue900,
                          size: 40,
                        ),
                      )
                    else if (specialities.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          runSpacing: 12,
                          spacing: 19,
                          children: List.generate(
                            specialities.length,
                            (index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedIndex != index
                                        ? gray50
                                        : blue900,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    specialities[index].name!,
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.montserrat().fontFamily,
                                      fontSize: FontSizeManager.f14,
                                      fontWeight: FontWeightManager.medium,
                                      color: selectedIndex == index
                                          ? gray50
                                          : gray800,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Text(
                          "No Specialities Found",
                          style: TextStyle(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            fontSize: FontSizeManager.f14,
                            fontWeight: FontWeightManager.regular,
                            color: gray500,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: HeightManager.h18,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: CustomButtom(
            title: 'Update',
            onPressed: () {
              if (selectedIndex != null) {
                context.read<UpdateProfileBloc>().add(
                      UpdateSpecialitiesEvent(
                        data: {
                          "speciality":
                              specialities[selectedIndex!].id.toString()
                        },
                      ),
                    );
              } else {
                Utils.showSnackBar(context, 'Please Select a Speciality',
                    isSuccess: false);
              }
            }),
      ),
    );
  }
}
