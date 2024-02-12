import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class NotificationRepo {
  final dio = Dio();

  Future<Response> getNotifications() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.notification,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return response;
  }

  Future<Response> markRead() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(
      AppUrls.markRead,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response;
  }

  Future<Response> getNotificationCount() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.notificationCount,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response;
  }
}
