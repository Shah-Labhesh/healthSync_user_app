import 'package:flutter/material.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatefulWidget {
  const CallScreen(
      {Key? key,
      required this.appointment})
      : super(key: key);
  final Appointment appointment;


  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    initializeRole();

  }

  void initializeRole() async {
    doctor = await SharedUtils.getRole() == 'DOCTOR';
    setState(() {});
  }

  bool doctor = false;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
          1498060823, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          "1a5f7c2f4c255c95156d3f86b4cba674d29af22966031f4650024f82f92247c4", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (endReason, state) {
          // You can handle the call end event here.
          Navigator.pushReplacementNamed(context, 'rate_experience',
              arguments: {
                'user': doctor ? widget.appointment.user : widget.appointment.doctor,
                'ratingType': doctor ? 'USER' : 'DOCTOR',
              });
        },
        onHangUpConfirmation: (event, defaultAction) {
          // You can handle the hang up confirmation event here.
          return defaultAction();
        },
        onError: (p0) {
          // You can handle the error event here.
        },
      ),
      userID: doctor ?  widget.appointment.doctor!.id! : widget.appointment.user!.id!,
      userName: doctor ?  widget.appointment.doctor!.name! : widget.appointment.user!.name!,
      callID: widget.appointment.id!,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
