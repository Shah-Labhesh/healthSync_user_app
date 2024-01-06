import 'package:dio/dio.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class AuthRepo {
  Dio dio = Dio();

  Future<dynamic> login({Map<String, dynamic>? data}) async {
    Response response1 = await dio.post(AppUrls.login, data: data);
    return response1;
  }

  Future<Response> userRegister({Map<String, dynamic>? data}) async {
    Response response = await dio.post(AppUrls.userRegister, data: data);
    return response;
  }

  Future<Response> doctorRegister({Map<String, dynamic>? data}) async {
    Response response = await dio.post(AppUrls.doctorRegister, data: data);
    print(response);
    return response;
  }

  Future<Response> forgotPassword({required String email}) async {
    Response response = await dio.post(AppUrls.forgotPassword(email: email));
    return response;
  }

  Future<Response> resetPassword({Map<String, dynamic>? data}) async {
    Response response = await dio.post(AppUrls.resetPassword, data: data);
    return response;
  }

  Future<Response> resendPasswordReset({required String email}) async {
    Response response =
        await dio.post(AppUrls.resendPasswordReset(email: email));
    return response;
  }

  Future<Response> verifyPassword({Map<String, dynamic>? data}) async {
    Response response = await dio.post(AppUrls.verifyPassword, data: data);
    return response;
  }

  Future<Response> initiateEmailVerificaation({required String email}) async {
    Response response =
        await dio.post(AppUrls.initiateEmailVerificaation(email: email));
    return response;
  }

  Future<Response> verifyEmail({Map<String, dynamic>? data}) async {
    Response response = await dio.post(AppUrls.verifyEmail, data: data);
    return response;
  }

  Future<Response> resendEmailVerification({required String email}) async {
    Response response =
        await dio.post(AppUrls.resendEmailVerification(email: email));
    return response;
  }

  Future<Response> uploadAddress(
      {required String id, required Map<String, dynamic> data}) async {
    Response response =
        await dio.post(AppUrls.uploadAddress(doctorId: id), data: data);
    return response;
  }

  Future<Response> uploadDetails(
      {required String id, required FormData data}) async {
    Response response = await dio.post(AppUrls.uploadDetails(doctorId: id),
        data: data,
        options: Options(headers: {"Content-Type": "multipart/form-data"}));
    return response;
  }

  Future<Response> addKhaltiId(
      {required String id, required Map<String, dynamic> data}) async {
    Response response = await dio.post(
      AppUrls.addKhaltiPayment(doctorId: id),
      data: data,
    );
    return response;
  }

  Future<Response> addQualification(
      {required String id, required FormData data}) async {
    Response response = await dio.post(
      AppUrls.addQualification(doctorId: id),
      data: data,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );
    print(response);
    return response;
  }

  Future<Response> updateQualification(
      {required String doctorId,
      required String qualificationId,
      required FormData data}) async {
    Response response = await dio.put(
      AppUrls.updateQualification(
          doctorId: doctorId, qualificationId: qualificationId),
      data: data,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );
    return response;
  }

  Future<Response> deleteQualification(
      {required String doctorId, required String qualificationId}) async {
    Response response = await dio.delete(
      AppUrls.deleteQualification(
          doctorId: doctorId, qualificationId: qualificationId),
    );
    return response;
  }

  Future<Response> getQualification({required String doctorId}) async {
    Response response = await dio.get(
      AppUrls.getOfDoctorQualification(doctorId: doctorId),
    );
    return response;
  }
}
