import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_mobile_app/.env.dart';
import 'package:user_mobile_app/Utils/location_utils.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class SearchRepo {
  final dio = Dio();
  double latitude = AppEnvironment.latitude;
  double longitude = AppEnvironment.longitude;

  Future<Response> searchDoctors({
    String? text,
    String? speciality,
    String? feeType,
    String? feeFrom,
    String? feeTo,
    bool? popular,
  }) async {
    LatLng location = await LocationUtils().getCurrentLocation() ??
        LatLng(latitude, longitude);
    final token = await SharedUtils.getToken();
    final response = await dio.get(
        AppUrls.searchDoctor(
            latitude: location.latitude, longitude: location.longitude),
        queryParameters: {
          'searchText': text,
          'speciality': speciality,
          'feeType': feeType,
          'feeFrom': feeFrom,
          'feeTo': feeTo,
          'popular': popular,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        print(response);
    return response;
  }

  Future<Response> getSpeciality() async {
    final token = await SharedUtils.getToken();
    final response = await dio.get(AppUrls.getSpeciality,
        options: Options(headers: {'Authorization' : 'Bearer $token'}));
    return response;
  }

  Future<Response> toggleFavorite(String doctorId) async {
    final token = await SharedUtils.getToken();
    final response = await dio.post(AppUrls.toggleFavourite(doctorId:  doctorId),
        options: Options(headers: {'Authorization' : 'Bearer $token'}));
    return response;
  }
}
