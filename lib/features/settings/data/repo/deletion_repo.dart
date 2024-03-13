import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class DeletionRepo {
  final dio = Dio();

  Future<Response> requestForDeletion(Map<String, dynamic> data) async {
    final token = await SharedUtils.getToken();
    final response = await dio.post(
      AppUrls.dataRemoval,
      data: data,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return response;
  }

  Future<Response> fetchRequestDeletion() async {
    final token = await SharedUtils.getToken();
    final response = await dio.get(
      AppUrls.dataRemoval,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return response;
  }
}
