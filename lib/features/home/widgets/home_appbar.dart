import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_event.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_state.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    super.key,
    required this.drawer,
    this.name,
    this.onTap,
  });

  final String? name;

  final bool drawer;
  final Function()? onTap;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String Greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NotificationBloc>().add(FetchUnreadNotificationCount());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.drawer) ...[
              InkWell(
                onTap: widget.onTap,
                child: const Icon(
                  CupertinoIcons.bars,
                  color: gray900,
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${widget.name!.split(' ')[0]}',
                  style: TextStyle(
                    fontSize: FontSizeManager.f22,
                    fontWeight: FontWeightManager.semiBold,
                    color: gray900,
                    letterSpacing: 0.5,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Greeting(),
                  style: textTheme.labelSmall!.copyWith(
                    fontSize: FontSizeManager.f14,
                    fontWeight: FontWeightManager.semiBold,
                    color: gray400,
                    letterSpacing: 0.5,
                  ),
                )
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'notification_screen');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: black.withOpacity(0.4),
                            blurRadius: 2,
                            spreadRadius: 1,
                            blurStyle: BlurStyle.outer,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const ImageIcon(
                        AssetImage(
                          notificationIcon,
                        ),
                        size: 30,
                      ),
                    ),
                    if (state is CountLoaded && state.count > 0) ...[
                      Positioned(
                        right: 12,
                        top: 10,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: const BoxDecoration(
                            color: blue900,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                    // Positioned(
                    //   right: 12,
                    //   top: 10,
                    //   child: Container(
                    //     height: 12,
                    //     width: 12,
                    //     decoration: const BoxDecoration(
                    //       color: blue900,
                    //       shape: BoxShape.circle,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
