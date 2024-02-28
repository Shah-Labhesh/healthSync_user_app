import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class RatingRepo {
  final dio = Dio();

  Future<Response> rateExperience(
      {required String id, required Map<String, dynamic> data}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(
      AppUrls.rate(id: id),
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }
}
