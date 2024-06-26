import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class AppointmentRepo{

  final dio = Dio();
  
  Future<Response> getSlots({required String doctorId}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getDoctorSlots(
        doctorId: doctorId,
      ),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print(response);

    return response;
  }

  Future<Response> bookAppointment({required Map<String, dynamic> data}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(
      AppUrls.bookAppointment,
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print(response);
    return response;
  }

  Future<Response> getMyAppointments() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getMyAppointments,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print(response);

    return response;
  }
}