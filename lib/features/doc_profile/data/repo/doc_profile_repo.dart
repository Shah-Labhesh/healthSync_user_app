import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class DocProfileRepo {

  Future<Response> getDocProfile(String id) async {
    final token = await SharedUtils.getToken();
    Response response = await Dio().get(
        AppUrls.getDoctor(doctorId: id),
        options: Options(
          headers: {
            'Authorization' : 'Bearer $token'
          }
        )
      );
      return response;
  }

  Future<Response> getDocQualification(String id) async {
    final token = await SharedUtils.getToken();
    Response response = await Dio().get(
        AppUrls.doctorQualification(doctorId: id),
        options: Options(
          headers: {
            'Authorization' : 'Bearer $token'
          }
        )
      );
      return response;
  }

  //  toogle favourite
  Future<Response> toggleFavourite(String id) async {
    final token = await SharedUtils.getToken();
    Response response = await Dio().post(
        AppUrls.toggleFavourite(doctorId: id),
        options: Options(
          headers: {
            'Authorization' : 'Bearer $token'
          }
        )
      );
      return response;
  }

  // get ratings of doctor 
  Future<Response> getDocRatings(String id) async {
    final token = await SharedUtils.getToken();
    Response response = await Dio().get(
        AppUrls.doctorRatings(doctorId: id),
        options: Options(
          headers: {
            'Authorization' : 'Bearer $token'
          }
        )
      );
      return response;
  }
}