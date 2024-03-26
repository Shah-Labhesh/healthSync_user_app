import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_mobile_app/.env.dart';
import 'package:user_mobile_app/Utils/firebase.dart';
import 'package:user_mobile_app/constants/theme.dart';
import 'package:user_mobile_app/features/account/bloc/account_bloc.dart';
import 'package:user_mobile_app/features/appointment/bloc/book_appointment_bloc/book_appointment_bloc.dart';
import 'package:user_mobile_app/features/appointment/bloc/my_appointment_bloc/my_appointment_bloc.dart';
import 'package:user_mobile_app/features/appointment/bloc/rate_experience_bloc/rate_experience_bloc.dart';
import 'package:user_mobile_app/features/appointment/screens/appointment_list_screen.dart';
import 'package:user_mobile_app/features/appointment/screens/appointment_summary_screen.dart';
import 'package:user_mobile_app/features/appointment/screens/book_appointment.dart';
import 'package:user_mobile_app/features/appointment/screens/rate_experience.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/bloc/doc_auth_bloc/doc_auth_bloc.dart';
import 'package:user_mobile_app/features/authentication/screens/doc_step1.dart';
import 'package:user_mobile_app/features/authentication/screens/doc_step2.dart';
import 'package:user_mobile_app/features/authentication/screens/doc_step3.dart';
import 'package:user_mobile_app/features/authentication/screens/doc_step4.dart';
import 'package:user_mobile_app/features/authentication/screens/email_verification.dart';
import 'package:user_mobile_app/features/authentication/screens/forgot_password.dart';
import 'package:user_mobile_app/features/authentication/screens/login_page.dart';
import 'package:user_mobile_app/features/authentication/screens/otp_verify.dart';
import 'package:user_mobile_app/features/authentication/screens/qualification_screen.dart';
import 'package:user_mobile_app/features/authentication/screens/reset_password.dart';
import 'package:user_mobile_app/features/authentication/screens/signup_page.dart';
import 'package:user_mobile_app/features/chats/screens/chat_room_screen.dart';
import 'package:user_mobile_app/features/chats/screens/chat_screen.dart';
import 'package:user_mobile_app/features/contact_support/bloc/contact_bloc/contact_bloc.dart';
import 'package:user_mobile_app/features/contact_support/screens/contact_support_screen.dart';
import 'package:user_mobile_app/features/doc_profile/bloc/doc_profile_bloc/doc_profile_bloc.dart';
import 'package:user_mobile_app/features/doc_profile/screen/doc_profile.dart';
import 'package:user_mobile_app/features/faqs/bloc/faqs_bloc/faqs_bloc.dart';
import 'package:user_mobile_app/features/faqs/screen/faqs_screen.dart';
import 'package:user_mobile_app/features/favorite/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:user_mobile_app/features/favorite/screens/favorite_screen.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_bloc.dart';
import 'package:user_mobile_app/features/home/bloc/user_home_bloc/user_home_bloc.dart';
import 'package:user_mobile_app/features/home/screens/doctor_home_screen.dart';
import 'package:user_mobile_app/features/home/screens/home.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_bloc.dart';
import 'package:user_mobile_app/features/medical_records/screens/edit_medical_record.dart';
import 'package:user_mobile_app/features/medical_records/screens/medical_record_screen.dart';
import 'package:user_mobile_app/features/medical_records/screens/upload_record_screen.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/features/notification/screens/notification_screen.dart';
import 'package:user_mobile_app/features/onboarding/page_view.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_bloc/patient_bloc.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_view_bloc/patient_view_bloc.dart';
import 'package:user_mobile_app/features/patients/screens/patient_view_screen.dart';
import 'package:user_mobile_app/features/patients/screens/patients_list_screen.dart';
import 'package:user_mobile_app/features/payment/bloc/make_payment_bloc/make_payment_bloc.dart';
import 'package:user_mobile_app/features/payment/bloc/payment_bloc/payment_bloc.dart';
import 'package:user_mobile_app/features/payment/screens/make_payment_screen.dart';
import 'package:user_mobile_app/features/payment/screens/payment_screen.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_bloc.dart';
import 'package:user_mobile_app/features/prescriptions/screens/prescription_screen.dart';
import 'package:user_mobile_app/features/prescriptions/screens/upload_prescription_screen.dart';
import 'package:user_mobile_app/features/privacy_policy/screens/privacy_policy_screen.dart';
import 'package:user_mobile_app/features/search_doctors/bloc/search_bloc/search_bloc.dart';
import 'package:user_mobile_app/features/search_doctors/screens/search_screen.dart';
import 'package:user_mobile_app/features/settings/bloc/qualification_bloc/qualification_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/request_deletion_bloc/request_deletion_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_bloc.dart';
import 'package:user_mobile_app/features/settings/screens/aboutus_screen.dart';
import 'package:user_mobile_app/features/settings/screens/auth_qualification_screen.dart';
import 'package:user_mobile_app/features/settings/screens/change_password_screen.dart';
import 'package:user_mobile_app/features/settings/screens/change_specialty_screen.dart';
import 'package:user_mobile_app/features/settings/screens/data_deletion_screen.dart';
import 'package:user_mobile_app/features/settings/screens/my_qualification_screen.dart';
import 'package:user_mobile_app/features/settings/screens/settings_screen.dart';
import 'package:user_mobile_app/features/settings/screens/update_location_screen.dart';
import 'package:user_mobile_app/features/settings/screens/update_profile.dart';
import 'package:user_mobile_app/features/slots/bloc/slots_bloc.dart';
import 'package:user_mobile_app/features/slots/screens/my_slots_screen.dart';
import 'package:user_mobile_app/features/splash_screen/splash_screen.dart';
import 'package:user_mobile_app/firebase_options.dart';
import 'package:user_mobile_app/network/bloc/network_bloc.dart';
import 'package:user_mobile_app/widgets/google_map_widget.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseService.initMessaging();
  FirebaseService.initLocalNotification();
  AppEnvironment.setupEnv(Environment.local);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NetworkBloc(),
      child: MaterialApp(
        title: 'Health Sync',
        debugShowCheckedModeBanner: false,
        theme: lighTheme,
        navigatorKey: navigatorKey,
        initialRoute: 'splash_screen',
        routes: {
          'splash_screen': (context) => const SplashScreen(),
          'onboarding_screen': (context) => const OnBoardingScreen(),
          'login_screen': (context) => BlocProvider(
                create: (context) => LoginBloc(),
                child: const LoginPage(),
              ),
          'signup_screen': (context) => BlocProvider(
                create: (context) => UserRegisterBloc(),
                child: const SignUpPage(),
              ),
          'forgot_password': (context) => BlocProvider(
                create: (context) => PasswordResetBloc(),
                child: ForgotPasswordScreen(),
              ),
          'doc_step1': (context) => BlocProvider(
                create: (context) => DocRegisterBloc(),
                child: const DocStep1(),
              ),
          'doc_step2': (context) => BlocProvider(
                create: (context) => DocAddressBloc(),
                child: const DocStep2(),
              ),
          'doc_step3': (context) => BlocProvider(
                create: (context) => DocDetailsBloc(),
                child: const DocStep3(),
              ),
          'doc_step4': (context) => BlocProvider(
                create: (context) => MoreDocDetailsBloc(),
                child: const DocStep4(),
              ),
          'email_verification': (context) => BlocProvider(
                create: (context) => EmailVerificationBloc(),
                child: const EmailVerificationScreen(),
              ),
          'otp_verification': (context) => BlocProvider(
                create: (context) => PasswordResetBloc(),
                child: const OTPVerificationScreen(),
              ),
          'reset_password': (context) => BlocProvider(
                create: (context) => PasswordResetBloc(),
                child: const ResetPasswordScreen(),
              ),
          'user_home_screen': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AccountBloc(),
                  ),
                  BlocProvider(
                    create: (context) => MyAppointmentBloc(),
                  ),
                  BlocProvider(
                    create: (context) => UserHomeBloc(),
                  ),
                ],
                child: const HomeScreen(),
              ),
          'doctor_home_screen': (context) => BlocProvider(
                create: (context) => DocHomeBloc(),
                child: const DoctorHomeScreen(),
              ),
          'map_screen': (context) => const MapWidget(),
          'qualification_screen': (context) => BlocProvider(
                create: (context) => MoreDocDetailsBloc(),
                child: const QualificationScreen(),
              ),
          'doc_profile': (context) => BlocProvider(
                create: (context) => DocProfileBloc(),
                child: const DoctorProfileScreen(),
              ),
          'book_slot': (context) => BlocProvider(
                create: (context) => BookAppointmentBloc(),
                child: const BookAppointmentScreen(),
              ),
          'book_summary': (context) => BlocProvider(
                create: (context) => BookAppointmentBloc(),
                child: const AppointmentSummary(),
              ),
          'search_doctor': (context) => BlocProvider(
                create: (context) => SearchBloc(),
                child: const SearchDoctorScreen(),
              ),
          'notification_screen': (context) => BlocProvider(
                create: (context) => NotificationBloc(),
                child: const NotificationScreen(),
              ),
          'favorite_screen': (context) => BlocProvider(
                create: (context) => FavoriteBloc(),
                child: const MyFavoriteScreen(),
              ),
          'chat_screen': (context) => const ChatScreen(),
          'chat_room_screen': (context) => const MyChatRoomScreen(),
          'my_appointment_screen': (context) => BlocProvider(
                create: (context) => MyAppointmentBloc(),
                child: const MyAppointmentScreen(),
              ),
          'contact_support': (context) => BlocProvider(
                create: (context) => ContactBloc(),
                child: const ContactSupportScreen(),
              ),
          'medical_record_screen': (context) => BlocProvider(
                create: (context) => RecordBloc(),
                child: const MedicalRecordScreen(),
              ),
          'edit_medical_record': (context) => BlocProvider(
                create: (context) => RecordBloc(),
                child: const EditRecordScreen(),
              ),
          'prescription_screen': (context) => BlocProvider(
                create: (context) => PrescriptionBloc(),
                child: const PrescriptionScreen(),
              ),
          'privacy_policy_screen': (context) => const PrivacyPolicyScreen(),
          'payment_screen': (context) => BlocProvider(
                create: (context) => PaymentBloc(),
                child: const PaymentsScreen(),
              ),
          'settings_screen': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AccountBloc(),
                  ),
                  BlocProvider(
                    create: (context) => DocHomeBloc(),
                  ),
                  BlocProvider(
                    create: (context) => UpdateProfileBloc(),
                  ),
                ],
                child: const SettingsScreen(),
              ),
          'my_slots_screen': (context) => BlocProvider(
                create: (context) => SlotsBloc(),
                child: const MySlotsScreen(),
              ),
          'change_password_screen': (context) => BlocProvider(
                create: (context) => UpdateProfileBloc(),
                child: const ChangePasswordScreen(),
              ),
          'update_profile_screen': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AccountBloc(),
                  ),
                  BlocProvider(
                    create: (context) => DocHomeBloc(),
                  ),
                  BlocProvider(
                    create: (context) => UpdateProfileBloc(),
                  ),
                ],
                child: const UpdateProfileScreen(),
              ),
          'my_patient_screen': (context) => BlocProvider(
                create: (context) => MyPatientBloc(),
                child: const MyPatientsScreen(),
              ),
          'about_us_screen': (context) => const AboutUsScreen(),
          'upload_record_screen': (context) => BlocProvider(
                create: (context) => RecordBloc(),
                child: const UploadRecordScreen(),
              ),
          'rate_experience': (context) => BlocProvider(
                create: (context) => RateExperienceBloc(),
                child: const RateExperienceScreen(),
              ),
          'upload_prescription_screen': (context) => BlocProvider(
                create: (context) => PrescriptionBloc(),
                child: const UploadPrescriptionScreen(),
              ),
          'my_qualification_screen': (context) => BlocProvider(
                create: (context) => QualificationBloc(),
                child: const MyQualificationScreen(),
              ),
          'auth_qualification_screen': (context) => BlocProvider(
                create: (context) => QualificationBloc(),
                child: const AuthQualificationScreen(),
              ),
          'update_address': (context) => const UpdateLocationScreen(),
          'change_speciality_screen': (context) => BlocProvider(
                create: (context) => UpdateProfileBloc(),
                child: const ChangeSpecialtyScreen(),
              ),
          'faqs_screen': (context) => BlocProvider(
                create: (context) => FAQBloc(),
                child: const FAQsScreen(),
              ),
          'make_payment': (context) => BlocProvider(
                create: (context) => MakePaymentBloc(),
                child: const MakePayment(),
              ),
          'data_deletion_screen': (context) => BlocProvider(
                create: (context) => RequestDeletionBloc(),
                child: const DataDeletionScreen(),
              ),
          'patient_view_screen': (context) => BlocProvider(
                create: (context) => PatientViewBloc(),
                child: const PatientViewScreen(),
              ),
        },
      ),
    );
  }
}
