import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/home/widgets/appointment_widget.dart';
import 'package:user_mobile_app/features/home/widgets/doctor_tile.dart';
import 'package:user_mobile_app/features/home/widgets/home_appbar.dart';
import 'package:user_mobile_app/features/home/widgets/tile_bar.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: PaddingManager.paddingMedium2,
            vertical: PaddingManager.paddingLarge),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const HomeAppBar(),
              const SizedBox(
                height: 45,
              ),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: gray200, width: 2),
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
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
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
              const SizedBox(
                height: PaddingManager.paddingMedium2,
              ),
              const TileBarWidget(
                title: 'Upcoming Schedules',
                subTitle: ' (2)',
                padding: 20,
              ),
              const AppointmentWidget(),
              const TileBarWidget(
                title: 'Popular Doctors',
                more: true,
                padding: 20,
              ),
              for (int i = 0; i < 4; i++) const DoctorTile(),
              const SizedBox(
                height: HeightManager.h73,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
