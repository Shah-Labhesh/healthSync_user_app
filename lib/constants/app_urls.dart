import 'package:user_mobile_app/.env.dart';
  String BASE_URL = AppEnvironment.androidBaseUrl;

class AppUrls{
  // multipart
  static String getFiles({required String path}) => '$BASE_URL/files/$path';
  // authenticaion
  static String login = '$BASE_URL/auth/login';
  static String userRegister = '$BASE_URL/auth/register-user';
  static String doctorRegister = '$BASE_URL/auth/register-doctor';
  static String forgotPassword({required String email}) => '$BASE_URL/auth/initiate-password-reset/$email';
  static String resetPassword = '$BASE_URL/auth/reset-password';
  static String resendPasswordReset({required String email}) => '$BASE_URL/auth/resend-password-reset/$email';
  static String verifyPassword = '$BASE_URL/auth/verify-password-reset';
  static String initiateEmailVerificaation({required String email}) => '$BASE_URL/auth/initiate-email-verification/$email';
  static String verifyEmail = '$BASE_URL/auth/verify-email';
  static String resendEmailVerification({required String email}) => '$BASE_URL/auth/resend-email-verification/$email';

  // doctor
  static String currentDoctor = '$BASE_URL/doctor/current-doctor';
  static String uploadDetails({required String doctorId}) => '$BASE_URL/doctor/upload-details/$doctorId';
  static String uploadAddress({required String doctorId}) => '$BASE_URL/doctor/upload-address/$doctorId';

  //qualification
  static String updateQualification({required String doctorId, required String qualificationId}) => '$BASE_URL/qualification/update-qualification/$doctorId/$qualificationId';
  static String authUpdateQualification({required String qualificationId}) => '$BASE_URL/qualification/auth/update-qualification/$qualificationId';
  static String authAddQualification = '$BASE_URL/qualification/auth/add-qualification';
  static String addQualification({required String doctorId}) => '$BASE_URL/qualification/add-qualification/$doctorId';
  static String addKhaltiPayment({required String doctorId}) => '$BASE_URL/qualification/add-khaltiId/$doctorId';
  static String getQualification({required String doctorId}) => '$BASE_URL/qualification/$doctorId'; // for user
  static String getOfDoctorQualification({required String doctorId}) => '$BASE_URL/qualification/doctor/$doctorId';
  static String getMyQualification = '$BASE_URL/qualification/auth/my-qualification';
  static String deleteQualification({required String doctorId, required String qualificationId}) => '$BASE_URL/qualification/delete-qualification/$doctorId/$qualificationId';
  static String authDeletedQualification({required String qualificationId}) => '$BASE_URL/qualification/auth/delete-qualification/$qualificationId';

  
}