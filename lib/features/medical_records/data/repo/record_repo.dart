import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class RecordRepo {
  final Dio dio = Dio();

  Future<Response> getRecords() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(AppUrls.medicalRecords,
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

  // get all req
  Future<Response> getAllRequest() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(AppUrls.allRequest,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return response;
  }

  // approve or reject req
  Future<Response> approveOrRejectReq(String requestId, bool status) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.put(AppUrls.updateRequestStatus(requestId: requestId, value: status),
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return response;
  }

}
