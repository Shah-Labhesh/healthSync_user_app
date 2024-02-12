import 'package:dio/dio.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class AuthRepo {
  Dio dio = Dio();

  Future<dynamic> login({Map<String, dynamic>? data}) async {
    Response response1 = await dio.post(AppUrls.login, data: data);
    return response1;
  }

  Future<Response> googleLogin(
      {required String name, required String email}) async {
    Response response =
        await dio.post(AppUrls.googleLogin(name: name, email: email));
    return response;
  }

  Future<Response> userRegister({Map<String, dynamic>? data}) async {
    Response response = await dio.post(AppUrls.userRegister, data: data);
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
    print(AppUrls.uploadAddress(doctorId: id));
    Response response =
        await dio.post(AppUrls.uploadAddress(doctorId: id), data: data);
    print("response is $response");
    return response;
  }

  Future<Response> uploadDetails(
      {required String id, required FormData data}) async {
    Response response = await dio.post(AppUrls.uploadDetails(doctorId: id),
        data: data,
        options: Options(headers: {"Content-Type": "multipart/form-data"}));
    return response;
  }

  Future<Response> fetchSpecialities() async {
    Response response = await dio.get(AppUrls.getSpeciality);
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
      AppUrls.updateOrDeleteQualification(
          doctorId: doctorId, qualificationId: qualificationId),
      data: data,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );
    return response;
  }

  Future<Response> deleteQualification(
      {required String doctorId, required String qualificationId}) async {
    Response response = await dio.delete(
      AppUrls.updateOrDeleteQualification(
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

  // firebase token
  Future<Response> postFirebaseToken(
      {required String token, required String firebaseToken}) async {
    Response response = await dio.post(
      AppUrls.firebaseToken,
      data: firebaseToken,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type" : "application/json"
        },
      ),
    );
    return response;
  }
}
