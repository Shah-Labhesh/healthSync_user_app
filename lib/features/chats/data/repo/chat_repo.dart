import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class ChatRepo {
  Future<Response> getChatRooms() async {
    final token = await SharedUtils.getToken();
    return await Dio().get(
      AppUrls.chatRoom,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }
}
