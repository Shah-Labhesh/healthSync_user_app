import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/appointment/data/model/ratings.dart';
import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';
import 'package:user_mobile_app/features/doc_profile/bloc/doc_profile_bloc/doc_profile_bloc.dart';
import 'package:user_mobile_app/features/doc_profile/bloc/doc_profile_bloc/doc_profile_event.dart';
import 'package:user_mobile_app/features/doc_profile/bloc/doc_profile_bloc/doc_profile_state.dart';
import 'package:user_mobile_app/features/doc_profile/widgets/custom_icon_button.dart';
import 'package:user_mobile_app/features/doc_profile/widgets/doc_profile_tile.dart';
import 'package:user_mobile_app/features/doc_profile/widgets/expandable_container.dart';
import 'package:user_mobile_app/features/doc_profile/widgets/ratingbar_widget.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  User? doctor;
  List<DocQualification> qualification = [];
  List<Ratings> rating = [];
  
  String? docId;

  bool isFirstBuild = true;

  void fetchData() {
    if (Utils.checkInternetConnection(context)) {
      context.read<DocProfileBloc>().add(GetDocProfile(doctorId: docId!));
    }
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    if (isFirstBuild) {
      docId = args;
      isFirstBuild = false;
    }
    return Scaffold(
      backgroundColor: blue900,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'Doctor Profile',
          onPop: () {
            Navigator.pop(context, doctor!.favorite);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          fetchData();
        },
        child: BlocConsumer<DocProfileBloc, DocProfileState>(
          listener: (context, state) {
            if (state is TokenExpired) {
              Utils.handleTokenExpired(context);
            }
        
            if (state is DocProfileLoaded) {
              doctor = state.doctor;
              context
                  .read<DocProfileBloc>()
                  .add(GetDocQualification(doctorId: args));
            }
            if (state is DocQualificationLoaded) {
              qualification = state.qualification;
        
              context.read<DocProfileBloc>().add(GetDocRatings(doctorId: args));
            }
            if (state is FavouriteToggleError) {
              Utils.showSnackBar(context, state.message, isSuccess: false);
            }
        
            if (state is FavouriteToggled) {
              doctor!.favorite = !doctor!.favorite!;
            }
        
            if (state is DocRatingsLoaded) {
              rating = state.rating;
            }
          },
          builder: (context, state) {
            if (state is DocProfileInitial) {
              context.read<DocProfileBloc>().add(GetDocProfile(doctorId: args));
            }
            if (state is DocProfileLoading || doctor == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is DocProfileError) {
              return InkWell(
                onTap: () {
                  context.read<DocProfileBloc>().add(
                        GetDocProfile(doctorId: args),
                      );
                },
                child: Center(
                  child: Text(
                    state.message,
                  ),
                ),
              );
            }
        
            return PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (didPop) {
                  return;
                }
                Navigator.pop(context, doctor!.favorite);
              },
              child: SingleChildScrollView(
                child: Column(children: [
                  DocProfileTile(doctor: doctor!),
                  const SizedBox(height: HeightManager.h20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: PaddingManager.paddingMedium2),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: PaddingManager.paddingMedium2, vertical: PaddingManager.p10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const CustomIconbutton(
                                  iconImage: ImageIcon(
                                    AssetImage(chatIcon),
                                    color: white,
                                    size: 50,
                                  ),
                                  iconTitle: 'Message',
                                ),
                                CustomIconbutton(
                                  iconImage: ImageIcon(
                                    AssetImage(doctor!.favorite!
                                        ? heartFilledIcon
                                        : heartIcon),
                                    color: doctor!.favorite! ? red900 : white,
                                    size: 50,
                                  ),
                                  iconTitle: 'Favorite',
                                  onTap: () {
                                    if (state is FavouriteToggleLoading) return;
                                    if (Utils.checkInternetConnection(context)) {
                                      context
                                        .read<DocProfileBloc>()
                                        .add(ToggleFavourite(doctorId: args));
                                    }
                                    
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: gray500,
                            thickness: 1.5,
                          ),
                          const SizedBox(height: HeightManager.h20),
                          if (doctor != null)
                            ExpandableContainer(
                                title: 'My Experience',
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: PaddingManager.paddingMedium2, vertical: PaddingManager.p10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (doctor!.experience == null)
                                        Text(
                                          'No experience added yet',
                                          style: TextStyle(
                                            fontSize: FontSizeManager.f16,
                                            fontWeight: FontWeightManager.medium,
                                            color: gray200,
                                            fontFamily: GoogleFonts.montserrat()
                                                .fontFamily,
                                          ),
                                        )
                                      else
                                        Text(
                                          doctor!.experience!,
                                          style: TextStyle(
                                            fontSize: FontSizeManager.f16,
                                            fontWeight: FontWeightManager.medium,
                                            color: gray200,
                                            fontFamily: GoogleFonts.montserrat()
                                                .fontFamily,
                                          ),
                                        ),
                                      const SizedBox(height: HeightManager.h10),
                                    ],
                                  ),
                                )),
                          const SizedBox(height: HeightManager.h10),
                          const Divider(
                            color: gray500,
                            thickness: 1.5,
                          ),
                          const SizedBox(height: HeightManager.h10),
                          if (state is DocQualificationLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          if (state is DocQualificationError)
                            InkWell(
                              onTap: () {
                                if (Utils.checkInternetConnection(context)){
                                  context
                                      .read<DocProfileBloc>()
                                      .add(GetDocQualification(doctorId: args));
                                }
                              },
                              child: Center(
                                child: Text(
                                  state.message,
                                ),
                              ),
                            ),
                          ExpandableContainer(
                            title: 'Qualification',
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: PaddingManager.paddingMedium2, vertical: PaddingManager.p10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (qualification.isEmpty)
                                    Text(
                                      'No qualification added yet',
                                      style: TextStyle(
                                        fontSize: FontSizeManager.f16,
                                        fontWeight: FontWeightManager.medium,
                                        color: gray200,
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
                                      ),
                                    )
                                  else
                                    for (DocQualification qualification
                                        in qualification)
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: gray400,
                                            size: 10,
                                          ),
                                          const SizedBox(width: WidthManager.w10),
                                          Text(
                                            '${qualification.title}, ${qualification.institute}',
                                            style: TextStyle(
                                              fontSize: FontSizeManager.f16,
                                              fontWeight:
                                                  FontWeightManager.medium,
                                              color: gray200,
                                              fontFamily: GoogleFonts.montserrat()
                                                  .fontFamily,
                                            ),
                                          ),
                                        ],
                                      ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: HeightManager.h10),
                          const Divider(
                            color: gray500,
                            thickness: 1.5,
                          ),
                          const SizedBox(height: HeightManager.h10),
                          Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: FontSizeManager.f20,
                              fontWeight: FontWeightManager.semiBold,
                              color: gray50,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                          const SizedBox(height: HeightManager.h10),
                          if (state is DocRatingsLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          if (state is DocRatingsError)
                            InkWell(
                              onTap: () {
                                if (Utils.checkInternetConnection(context)){
                                  context
                                    .read<DocProfileBloc>()
                                    .add(GetDocRatings(doctorId: args));
                                }
                              },
                              child: Center(
                                child: Text(
                                  state.message,
                                ),
                              ),
                            ),
                          if (rating.isEmpty)
                            Text(
                              'No reviews yet',
                              style: TextStyle(
                                fontSize: FontSizeManager.f16,
                                fontWeight: FontWeightManager.medium,
                                color: gray200,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                            )
                          else
                            for (Ratings rating in rating)
                              RatingBarWidget(
                                userAvatar: rating.user!.avatar!,
                                userName: rating.user!.name!,
                                rating: rating.ratings!,
                                review: rating.comment ?? '',
                              ),
                          const SizedBox(height: HeightManager.h50),
                        ]),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
