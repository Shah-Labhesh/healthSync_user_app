import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class QualificationRepo {
  final dio = Dio();

  Future<Response> getQualification() async {
    final token = await SharedUtils.getToken();
    final response = await dio.get(
      AppUrls.getMyQualification,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print("getQualification: $response");
    return response;
  }

  Future<Response> addQualification(Map<String, dynamic> body) async {
    final token = await SharedUtils.getToken();
    final response = await dio.post(
      AppUrls.authQualification,
      data: FormData.fromMap(body),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "multipart/form-data",
        },
      ),
    );
    return response;
  }

  Future<Response> updateQualification(
      {required String id, required Map<String, dynamic> body}) async {
    final token = await SharedUtils.getToken();
    final response = await dio.put(
      AppUrls.authUpdateOrDeleteQualification(qualificationId: id),
      data: FormData.fromMap(body),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "multipart/form-data",
        },
      ),
    );
    return response;
  }

  Future<Response> deleteQualification({required String id}) async {
    final token = await SharedUtils.getToken();
    final response = await dio.delete(
      AppUrls.authUpdateOrDeleteQualification(qualificationId: id),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return response;
  }
}
