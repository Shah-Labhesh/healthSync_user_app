// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_event.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_state.dart';
import 'package:user_mobile_app/features/notification/data/model/notification.dart';
import 'package:user_mobile_app/features/notification/widgets/notification_tile.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Notifications> notificationList = [];
  Map<String, List<Notifications>> notificationMap = {};
  List<String> dateList = [];

  mapNotificationAccordingDate(List<Notifications> notifications) {
    for (Notifications notification in notifications) {
      String date = notification.createdAt!.splitDate();
      if (notificationMap.containsKey(date)) {
        notificationMap[date]!.add(notification);
      } else {
        dateList.add(date);
        notificationMap[date] = [notification];
      }
    }
  }

 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NotificationBloc>().add(MarkNotificationAsRead());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBarCustomWithSceenTitle(
            title: 'Notification',
          ),
        ),
        body: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is TokenExpired) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login_screen', (route) => false);

              Utils.showSnackBar(
                context,
                'Session Expired. Please login again',
                isSuccess: false,
              );
            }

            if (state is NotificationLoaded) {
              notificationList = state.notifications;

              mapNotificationAccordingDate(notificationList);
            }
          },
          builder: (context, state) {
            if (state is NotificationInitial) {
              context.read<NotificationBloc>().add(FetchNotification());
            }

            if (state is NotificationLoading) {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: blue900,
                  size: 60,
                ),
              );
            }
            return SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (notificationList.isEmpty)
                      const Center(
                        child: Text(
                          'No Notification Found',
                        ),
                      ),
              
                    for (String date in dateList) ...[
                      Text(
                        date == DateTime.now().toString().splitDate()
                            ? 'Today'
                            : date ==
                                    DateTime.now()
                                        .subtract(Duration(days: 1))
                                        .toString()
                                        .splitDate()
                                ? 'Yesterday'
                                : 'Past',
                        style: TextStyle(
                          color: gray800,
                          fontSize: 20,
                          fontWeight: FontWeightManager.semiBold,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (Notifications notification
                          in notificationMap[date]!) ...[
                        NotificationTile(
                          index: notificationList.indexOf(
                            notification,
                          ),
                          notificationType: notification.notificationType ?? '',
                          title: notification.title ?? '',
                          subTitle: notification.body ?? '',
                          time: notification.createdAt!.formatTimeAgo(),
                        ),
                      ],
                    ],
                    // Text(
                    //   'Today',
                    //   style: TextStyle(
                    //     color: gray800,
                    //     fontSize: 20,
                    //     fontWeight: FontWeightManager.semiBold,
                    //     fontFamily: GoogleFonts.montserrat().fontFamily,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // for (Notifications notification in notificationList) ...[
                    //   NotificationTile(
                    //     index: notificationList.indexOf(
                    //       notification,
                    //     ),
                    //     notificationType: notification.notificationType ?? '',
                    //     title: notification.title ?? '',
                    //     subTitle: notification.body ?? '',
                    //     time: notification.createdAt!.splitDate(),
                    //   ),
                    // ],
                    // ],
                  ],
                ),
              ),
            );
          },
        ));
  }
}
