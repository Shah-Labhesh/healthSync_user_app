import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class SettingRepo{

  final Dio dio = Dio();

  Future<Response> getSpeciality() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getSpeciality,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  Future<Response> updateCurrentUser(Map<String, dynamic> body) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.put(
      AppUrls.currentUser,
      data: FormData.fromMap(body),
      options: Options(headers: {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data',}),
    );
    return response;
  }
}