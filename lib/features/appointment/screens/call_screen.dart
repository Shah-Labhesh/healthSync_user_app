import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';


class CallScreen extends StatelessWidget {
  const CallScreen({Key? key, required this.callID, required this.userId, required this.userName}) : super(key: key);
  final String callID;
  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1498060823, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: "1a5f7c2f4c255c95156d3f86b4cba674d29af22966031f4650024f82f92247c4", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (endReason, state) {
          // You can handle the call end event here.
          Navigator.pushReplacementNamed(context, 'rate_experience');
        },

        onHangUpConfirmation: (event, defaultAction) {
          // You can handle the hang up confirmation event here.
          return defaultAction();
        },
      
        onError: (p0) {
          // You can handle the error event here.
        },

      ),
      userID: userId,
      userName: userName,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }

  void onCallInit(){
    ZegoUIKitPrebuiltCallInvitationService().init(
    appID: 1498060823 /*input your AppID*/,
    appSign: "1a5f7c2f4c255c95156d3f86b4cba674d29af22966031f4650024f82f92247c4" /*input your AppSign*/,
    userID: userId,
    userName: userName,
    plugins: [ZegoUIKitSignalingPlugin()],
  );
  }
}
