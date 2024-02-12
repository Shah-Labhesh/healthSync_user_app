import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class AccountRepo {
  final Dio dio = Dio();
  Future<Response> currentUser() async {
    final token = await SharedUtils.getToken();
    print(token);
    Response response = await dio.get(AppUrls.currentUser,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return response;
  }

  Future<Response> logout({required String deviceToken}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.delete(AppUrls.firebaseToken,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Content-Type": "application/json",
          },
        ),
        data: deviceToken);
    return response;
  }
}
