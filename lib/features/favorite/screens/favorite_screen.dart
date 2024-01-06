import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/home/widgets/doctor_tile.dart';
import 'package:user_mobile_app/widgets/appbar.dart';

class MyFavoriteScreen extends StatelessWidget {
  const MyFavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingManager.paddingMedium2,
          vertical: PaddingManager.paddingSmall,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Favorite',
                isBackButton: false,
                notification: true,
              ),
              const SizedBox(
                height: 20,
              ),
              for (int i = 0; i < 8; i++) const DoctorTile(isFav: true,),
            ],
          ),
        ),
      ),
    );
  }
}
