import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class ContactRepo{

  final dio = Dio();
  Future<Response> sendContactUs({required String email, required String message}) async {
    // send message to server
    final token = await SharedUtils.getToken();
    Response response = await dio.post(AppUrls.contactMessage(email: email, message: message), options: Options(headers: {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization' : 'Bearer $token'
    }));
    return response;
  }
}