import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/appointment/widgets/no_appointment_widget.dart';
import 'package:user_mobile_app/features/authentication/data/model/specialities.dart';
import 'package:user_mobile_app/features/home/bloc/user_home_bloc/user_home_bloc.dart';
import 'package:user_mobile_app/features/home/bloc/user_home_bloc/user_home_event.dart';
import 'package:user_mobile_app/features/home/bloc/user_home_bloc/user_home_state.dart';
import 'package:user_mobile_app/features/home/widgets/appointment_widget.dart';
import 'package:user_mobile_app/features/home/widgets/doctor_tile.dart';
import 'package:user_mobile_app/features/home/widgets/home_appbar.dart';
import 'package:user_mobile_app/features/home/widgets/no_doctor_widget.dart';
import 'package:user_mobile_app/features/home/widgets/tile_bar.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/features/search_doctors/data/model/search_param.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String name = '';
  List<Appointment> appointment = [];
  List<User> doctors = [];
  List<Specialities> specialities = [];

  bool isViewAll = false;
  int count = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserHomeBloc>().add(FetchUserHomeEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return BlocConsumer<UserHomeBloc, UserHomeState>(
      listener: (context, state) {
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }

        if (state is ToggleFavouriteSuccess) {
          for (var element in doctors) {
            if (element.id == state.doctorId) {
              element.favorite = !element.favorite!;
            }
          }
        }

        if (state is ToggleFavouriteFailed) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        if (state is UserHomeInitial) {
          context.read<UserHomeBloc>().add(FetchUserHomeEvent());
        }
        if (state is UserHomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is UserHomeLoadFailed) {
          return InkWell(
            onTap: () async {
              if (Utils.checkInternetConnection(context)) {
                context.read<UserHomeBloc>().add(FetchUserHomeEvent());
              }
            },
            child: Center(
              child: Text(state.message),
            ),
          );
        }
        if (state is UserHomeLoaded) {
          name = state.user.name!;
          doctors = state.doctors;
          appointment = state.appointment;
          specialities = state.specialities;
          if (isViewAll) {
            count = doctors.length;
          } else {
            count = doctors.length > 5 ? 5 : doctors.length;
          }
        }
        return RefreshIndicator(
          onRefresh: () async {
            if (Utils.checkInternetConnection(context)) {
              context.read<UserHomeBloc>().add(FetchUserHomeEvent());
            }
            await Future.delayed(const Duration(seconds: 1));
          },
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.paddingMedium2,
                  vertical: PaddingManager.paddingLarge),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    BlocProvider(
                      create: (context) => NotificationBloc(),
                      child:
                          HomeAppBar(name: name.split(' ')[0], drawer: false),
                    ),

                    const SizedBox(
                      height: 45,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'search_doctor');
                      },
                      child: Container(
                        height: HeightManager.h60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: gray200, width: WidthManager.w2),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: PaddingManager.padding,
                            ),
                            const ImageIcon(
                              AssetImage(searchIcon),
                              color: gray500,
                              size: 28,
                            ),
                            const SizedBox(
                              width: PaddingManager.paddingMedium2,
                            ),
                            Text(
                              'Search',
                              style: textTheme.labelMedium!.copyWith(
                                color: gray500,
                                fontWeight: FontWeightManager.medium,
                              ),
                            ),
                            const Spacer(),
                            const ImageIcon(
                              AssetImage(filterIcon),
                              color: gray500,
                              size: 28,
                            ),
                            const SizedBox(
                              width: PaddingManager.padding,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: PaddingManager.paddingSmall,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        primary: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: PaddingManager.paddingMedium2,
                          vertical: PaddingManager.p12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (Specialities speciality in specialities)
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    'search_doctor',
                                    arguments: SearchParam(
                                      speciality: speciality.id,
                                      specialityName: speciality.name,
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: HeightManager.h60,
                                      width: WidthManager.w60,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: PaddingManager.p12,
                                        vertical: PaddingManager.p12,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: white,
                                        border: Border.all(
                                          color: gray200,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: speciality.image != null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  BASE_URL + speciality.image!,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Center(
                                                child: Icon(Icons.error),
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              AppImages.defaultAvatar,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    const SizedBox(
                                      height: HeightManager.h10,
                                    ),
                                    Text(
                                      speciality.name ?? '-',
                                      style: TextStyle(
                                        color: gray600,
                                        fontWeight: FontWeightManager.medium,
                                        fontFamily:
                                            GoogleFonts.roboto().fontFamily,
                                        fontSize: FontSizeManager.f12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    TileBarWidget(
                      title: 'Upcoming Schedules',
                      subTitle: ' (${appointment.length})',
                      padding: PaddingManager.paddingMedium2,
                    ),
                    if (appointment.isNotEmpty)
                      AppointmentWidget(appointment: appointment[0])
                    else
                      const NoAppointmentWidget(),

                    TileBarWidget(
                      title: 'NearBy Doctors',
                      more: true,
                      moreText: isViewAll ? 'See Less' : 'See All',
                      onTap: () {
                        setState(() {
                          isViewAll = !isViewAll;
                          if (isViewAll) {
                            count = doctors.length;
                          } else {
                            count = doctors.length > 5 ? 5 : doctors.length;
                          }
                        });
                      },
                      padding: PaddingManager.paddingMedium2,
                    ),
                    // list generate
                    if (doctors.isEmpty)
                      const NoDoctorWidget()
                    else
                      for (int i = 0; i < count; i++)
                        DoctorTile(
                          doctor: doctors[i],
                          onPressed: () {
                            if (state is ToggleFavouriteLoading) return;
                            final bloc = context.read<UserHomeBloc>();
                            bloc.add(
                                ToggleFavouriteEvent(doctorId: doctors[i].id!));
                          },
                        ),

                    const SizedBox(
                      height: HeightManager.h73,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
