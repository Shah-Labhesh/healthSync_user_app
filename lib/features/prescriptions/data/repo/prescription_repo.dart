import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class PrescriptionRepo {
  final dio = Dio();

  Future<Response> getPrescriptions() async {
    // get prescriptions from server
    final token = await SharedUtils.getToken();
    Response response = await dio.get(AppUrls.prescription,
        options: Options(headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    return response;
  }

  Future<Response> uploadPrescription(Map<String, dynamic> prescription) async {
    // upload prescription to server
    final token = await SharedUtils.getToken();
    Response response = await dio.post(AppUrls.prescription,
        data: FormData.fromMap(prescription),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "multipart/form-data"
        }));
    return response;
  }

  Future<Response> getAllRequestPermission() async {
    // get patient prescriptions from server
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.allPrescriptionRequest,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  // update permission status 
  Future<Response> updatePermissionStatus(
      {required String permissionId, required bool status}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(
      AppUrls.updatePermissionStatus(requestId: permissionId, value: status),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  // revoke 
  Future<Response> revokePermission({required String permissionId}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.delete(
      AppUrls.revokePermissionPrescription(requestId: permissionId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }
}
