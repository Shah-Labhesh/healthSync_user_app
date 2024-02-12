import 'package:user_mobile_app/.env.dart';
  String BASE_URL = AppEnvironment.androidBaseUrl;

class AppUrls{
  
  // authenticaion
  static String login = '$BASE_URL/auth/login';
  static String userRegister = '$BASE_URL/auth/register-user';
  static String forgotPassword({required String email}) => '$BASE_URL/auth/initiate-password-reset/$email';
  static String resetPassword = '$BASE_URL/auth/reset-password';
  static String resendPasswordReset({required String email}) => '$BASE_URL/auth/resend-password-reset/$email';
  static String verifyPassword = '$BASE_URL/auth/verify-password-reset';
  static String initiateEmailVerificaation({required String email}) => '$BASE_URL/auth/initiate-email-verification/$email';
  static String verifyEmail = '$BASE_URL/auth/verify-email';
  static String resendEmailVerification({required String email}) => '$BASE_URL/auth/resend-email-verification/$email';
  static String googleLogin({required String name, required String email}) => '$BASE_URL/auth/google-authenticate/$name/$email';

  // user
  static String currentUser = '$BASE_URL/user/current-user';
  static String uploadDetails({required String doctorId}) => '$BASE_URL/user/upload-details/$doctorId';
  static String uploadAddress({required String doctorId}) => '$BASE_URL/user/upload-address/$doctorId';
  static String addKhaltiPayment({required String doctorId}) => '$BASE_URL/user/khaltiId/$doctorId';
  static String firebaseToken = '$BASE_URL/user/firebase-token';


  //qualification
  static String updateOrDeleteQualification({required String doctorId, required String qualificationId}) => '$BASE_URL/qualification/$doctorId/$qualificationId';
  static String authUpdateOrDeleteQualification({required String qualificationId}) => '$BASE_URL/qualification/auth/$qualificationId';
  static String authQualification = '$BASE_URL/qualification/auth';
  static String addQualification({required String doctorId}) => '$BASE_URL/qualification/$doctorId';
  static String getQualification({required String doctorId}) => '$BASE_URL/qualification/doctor/$doctorId'; // for user
  static String getOfDoctorQualification({required String doctorId}) => '$BASE_URL/qualification/user/$doctorId';
  static String getMyQualification = '$BASE_URL/qualification/my-qualification';

  // slots
  static String getDoctorSlots({required String doctorId}) => '$BASE_URL/slots/doctor-slots/$doctorId';
  static String getMySlots = '$BASE_URL/slots/my-slots';
  static String addSlot = '$BASE_URL/slots';
  static String updateOrDeleteSlot({required String slotId}) => '$BASE_URL/slots/$slotId';


  // speciality
  static String getSpeciality = '$BASE_URL/speciality/all';


  // doctor
  static String getDoctors({required double latitude, required double longitude}) => '$BASE_URL/doctor/nearby-doctors/$latitude/$longitude';
  static String toggleFavourite({required String doctorId}) => '$BASE_URL/doctor/toggle-favorite/$doctorId';
  static String getFavouriteDoctors = '$BASE_URL/doctor/my-favorites';
  static String getDoctor({required String doctorId}) => '$BASE_URL/doctor/doctor-details/$doctorId';
  static String doctorQualification({required String doctorId}) => '$BASE_URL/doctor/qualification/$doctorId';
  static String doctorRatings({required String doctorId}) => '$BASE_URL/doctor/ratings/$doctorId';
  static String getDoctorPatients= '$BASE_URL/doctor/my-patients';
  static String haveAppointment= '$BASE_URL/doctor/have-appointments';
  static String searchDoctor({required double latitude, required double longitude})=> '$BASE_URL/doctor/filter-doctors/$latitude/$longitude';

  // appointment
  static String bookAppointment = '$BASE_URL/appointment';
  static String getMyAppointments = '$BASE_URL/appointment/my-appointments';

  // medical record 
  static String uploadRecord = '$BASE_URL/medical-record';
  static String medicalRecords({required String sort}) => '$BASE_URL/medical-record?sort=$sort';
  static String medicalRecordsByDoctor({required String sort}) => '$BASE_URL/medical-record/doctor?sort=$sort';
  static String uploadRecordByDoctor({required String userId}) => '$BASE_URL/medical-record/$userId';
  static String shareMedicalRecord({required String recordId, required String doctorId}) => '$BASE_URL/medical-record/share/$recordId/$doctorId';
  static String revokeSharedRecord({required String recordId}) => '$BASE_URL/medical-record/revoke/$recordId';

  // prescription
  static String prescription = '$BASE_URL/prescription';

  // contact
  static String contactMessage({required String email, required String message}) => '$BASE_URL/contact?email=$email&message=$message';

  // notification
  static String notification = '$BASE_URL/notification';
  static String markRead = '$BASE_URL/notification/mark-read';
  static String notificationCount = '$BASE_URL/notification/unread-count';

}