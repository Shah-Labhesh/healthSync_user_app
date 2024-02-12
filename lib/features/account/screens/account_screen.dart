import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/bloc/account_bloc.dart';
import 'package:user_mobile_app/features/account/bloc/account_event.dart';
import 'package:user_mobile_app/features/account/bloc/account_state.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/account/widgets/tile_bar.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/widgets/appbar.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  User? user;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is TokenExpired) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'login_screen', (route) => false);

          Utils.showSnackBar(context, 'Token Expired Please Login Again',
              isSuccess: false);
        }

        if (state is LoggedOut) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'login_screen', (route) => false);
          SharedUtils.setRole('');
          SharedUtils.setToken('');
          Utils.showSnackBar(context, 'Logout Successfully', isSuccess: true);
        }

        if (state is AccountLoadFailed) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        if (state is AccountInitial) {
          context.read<AccountBloc>().add(FetchCurrentUserEvent());
        }
        if (state is AccountLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is AccountLoadFailed) {
          return Scaffold(
            body: Center(
              child: Text(state.message),
            ),
          );
        }
        if (state is AccountLoaded) {
          user = state.data;
        }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingMedium2,
                vertical: PaddingManager.paddingSmall,
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  children: [
                    BlocProvider(
                      create: (context) => NotificationBloc(),
                      child: const CustomAppBar(
                        title: 'Profile',
                        isBackButton: false,
                        notification: true,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: user!.avatar != null
                          ? CachedNetworkImage(
                              imageUrl: BASE_URL + user!.avatar!,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(Icons.error),
                              ),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              AppImages.defaultAvatar,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(
                      height: HeightManager.h10,
                    ),
                    Text(
                      user!.name!,
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
                      user!.email!,
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
                    const TileBarWidget(
                      icon: recordIcon,
                      title: 'Medical Records',
                      route: 'medical_record_screen',
                    ),
                    const TileBarWidget(
                      icon: heartFilledIcon,
                      title: 'My Favorite',
                      route: 'favorite_screen',
                    ),
                    const TileBarWidget(
                      icon: paymentIcon,
                      title: 'Payments',
                      route: 'payment_screen',
                    ),
                    const TileBarWidget(
                      icon: prescriptionIcon,
                      title: 'Prescriptions',
                      route: 'prescription_screen',
                    ),
                    const TileBarWidget(
                      icon: policyIcon,
                      title: 'Privacy Policy',
                      route: 'privacy_policy_screen',
                    ),
                    const TileBarWidget(
                      icon: queryIcon,
                      title: 'Contact Support',
                      route: 'contact_support',
                    ),
                    TileBarWidget(
                      icon: settingsIcon,
                      title: 'Settings',
                      onPressed: () {
                        Navigator.pushNamed(context, 'settings_screen',
                            arguments: user);
                      },
                    ),
                    TileBarWidget(
                      icon: logoutIcon,
                      title: 'Logout',
                      isLogout: true,
                      onPressed: () {
                        final bloc = BlocProvider.of<AccountBloc>(context); 
                        showDialog(
                          context: context,
                          builder: (context) =>
                              Utils().logoutDialog(context, () {
                            bloc.add(LogoutEvent());
                          }),
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
        
      },
    );
  }
}
