import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_event.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_state.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackButton = true,
    this.notification = false,
  });

  final String title;
  final bool? isBackButton;
  final bool notification;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NotificationBloc>().add(FetchUnreadNotificationCount());
  }
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return SizedBox(
          height: 70,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.isBackButton!)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: gray800,
                  ),
                )
              else
                const SizedBox(
                  width: 60,
                ),
              Text(
                widget.title,
                style: textTheme.labelMedium!.copyWith(
                  letterSpacing: 0.5,
                  fontSize: FontSizeManager.f18,
                  color: gray800,
                ),
              ),
              if (widget.notification == false)
                const SizedBox(
                  width: 50,
                  height: 50,
                )
              else
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
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
