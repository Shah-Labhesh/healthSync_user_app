import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_mobile_app/.env.dart';
import 'package:user_mobile_app/Utils/location_utils.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class HomeRepo {
  final Dio dio = Dio();

  double latitude = AppEnvironment.latitude;
  double longitude = AppEnvironment.longitude;

  Future<Response> getSpeciality() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getSpeciality,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  Future<Response> getDoctors() async {
    LatLng location = await LocationUtils().getCurrentLocation() ??
        LatLng(latitude, longitude);
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getDoctors(
          latitude: location.latitude, longitude: location.longitude),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  Future<Response> getMyAppointments() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getMyAppointments,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  // current user
  Future<Response> currentUser() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.currentUser,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  Future<Response> toggleFavourite(String doctorId) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(
      AppUrls.toggleFavourite(doctorId: doctorId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  //doc appointments
  Future<Response> getDoctorAppointments() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getMyAppointments,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  //doc patients
  Future<Response> getDoctorPatients() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getDoctorPatients,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }
}
