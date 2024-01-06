import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/widgets/tile_bar.dart';
import 'package:user_mobile_app/widgets/appbar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

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
                title: 'Profile',
                isBackButton: false,
                notification: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  '$BASE_URL/files/get-avatar/44f95792-9353-4d57-be9f-d59e1a65925a',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: HeightManager.h10,
              ),
              Text(
                "Logan Filop",
                style: TextStyle(
                  fontSize: FontSizeManager.f18,
                  fontWeight: FontWeightManager.semiBold,
                  color: gray800,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "JohnEmma32@gmail.com",
                style: TextStyle(
                  fontSize: FontSizeManager.f14,
                  fontWeight: FontWeightManager.medium,
                  color: blue900,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              const SizedBox(
                height: HeightManager.h20,
              ),
              const TileBarWidget(icon: recordIcon, title: 'Medical Records'),
              const TileBarWidget(icon: paymentIcon, title: 'Payments'),
              const TileBarWidget(icon: prescriptionIcon, title: 'Prescriptions'),
              const TileBarWidget(icon: messageIcon, title: 'Messages'),
              const TileBarWidget(icon: policyIcon, title: 'Privacy Policy'),
              const TileBarWidget(icon: queryIcon, title: 'Contact Support'),
              const TileBarWidget(icon: settingsIcon, title: 'Settings'),
              TileBarWidget(
                icon: logoutIcon,
                title: 'Logout',
                isLogout: true,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Utils().logoutDialog(context, () {
                        Navigator.pushReplacementNamed(context, 'login_screen');
                        SharedUtils.setRole('');
                        SharedUtils.setToken('');
                      });
                    },
                  );
                },
              ),
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
