import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class RecordRepo {
  final Dio dio = Dio();

  Future<Response> getRecords({required String sort}) async {
    final token = await SharedUtils.getToken();
    final role = await SharedUtils.getRole();
    Response response = await dio.get(role=='USER' ? AppUrls.medicalRecords(sort: sort ) : AppUrls.medicalRecordsByDoctor(sort: sort),
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return response;
  }

  Future<Response> uploadRecord(Map<String, dynamic> record) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(AppUrls.uploadRecord,
        data: FormData.fromMap(record),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "multipart/form-data"
        }));
    return response;
  }

  Future<Response> getPatientList() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(AppUrls.getDoctorPatients,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return response;
  }

  Future<Response> uploadRecordByDoctor(String id, Map<String, dynamic> record) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(AppUrls.uploadRecordByDoctor(userId: id),
        data: FormData.fromMap(record),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "multipart/form-data"
        }));
    return response;
  }

  Future<Response> getDoctorList() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(AppUrls.haveAppointment,
        options: Options(headers: {'Authorization' : 'Bearer $token'}));
    return response;
  }

  Future<Response> shareRecord(String recordId, String doctorId) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(AppUrls.shareMedicalRecord(recordId: recordId, doctorId: doctorId),
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return response;
  }

  Future<Response> revokeSharedRecord(String recordId) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.delete(AppUrls.revokeSharedRecord(recordId: recordId),
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return response;
  }

  Future<Response> updateRecord(String recordId, Map<String, dynamic> record) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.put(AppUrls.updateRecord(recordId: recordId),
        data: FormData.fromMap(record),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "multipart/form-data"
        }));
    return response;
  }

}
