import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class PatientRepo{

  final dio = Dio();


  Future<Response> getPatients() async {
    final token = await SharedUtils.getToken();
   Response response = await dio.get(
      AppUrls.getDoctorPatients,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  Future<Response> getPatientRecord({required String patientId}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getPatientRecords(userId: patientId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  Future<Response> getPatientPrescriptions({required String patientId}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getPatientPrescriptions(patientId: patientId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  // request permission for prescription
  Future<Response> requestPermission({required String userId}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(
      AppUrls.requestPermission(userId: userId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  // request permission for record
  Future<Response> requestRecordPermission({required String userId}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(
      AppUrls.requestRecordPermission(userId: userId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

}
