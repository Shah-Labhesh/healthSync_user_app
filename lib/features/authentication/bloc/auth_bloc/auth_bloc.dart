import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_mobile_app/Utils/firebase.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_event.dart';
import 'package:user_mobile_app/features/authentication/bloc/auth_bloc/auth_state.dart';
import 'package:user_mobile_app/features/authentication/data/repo/auth_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(AuthInitial()) {
    on<RequestLoginEvent>((event, emit) => login(emit, event));
    on<RequestGoogleLoginEvent>((event, emit) => googleLogin(emit, event));
  }

  login(Emitter<LoginState> emit, RequestLoginEvent event) async {
    emit(AuthLoading());
    Response response;
    try {
      response = await AuthRepo().login(data: event.credentials);

      if (response.statusCode == 201) {
        final firebaseResponse = await AuthRepo().postFirebaseToken(
            token: response.data["token"],
            firebaseToken: await FirebaseService.requestPermission());
        if (firebaseResponse.statusCode == 201) {
          emit(LoginSucess(data: {'role': response.data["role"]}));
          SharedUtils.setToken(response.data["token"]);
          SharedUtils.setRole(response.data["role"]);
          SharedUtils.setAuthType(response.data["authType"]);
        } else {
          emit(LoginFailed(
              message: 'Something went wrong. Please try again later'));
        }
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(LoginFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(LoginFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"][0]
                .toLowerCase()
                .contains('verify your email')) {
              emit(UserNotVerified(data: {
                "email": event.credentials["email"],
                "password": event.credentials["password"]
              }));
            }

            if (e.response?.data["message"].runtimeType != String) {
              emit(LoginFailed(message: e.response?.data["message"][0]));
            } else {
              emit(LoginFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(LoginFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(LoginFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  void googleLogin(
      Emitter<LoginState> emit, RequestGoogleLoginEvent event) async {
    emit(AuthLoading());
    Response response;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      emit(LoginFailed(message: "Google Sign In Failed"));
      return;
    }
    try {
      response = await AuthRepo()
          .googleLogin(name: googleUser.displayName!, email: googleUser.email);

      if (response.statusCode == 201) {
        final firebaseResponse = await AuthRepo().postFirebaseToken(
            token: response.data["token"],
            firebaseToken: await FirebaseService.requestPermission());
        if (firebaseResponse.statusCode == 201) {
          emit(LoginSucess(data: {'role': response.data["role"]}));
          SharedUtils.setToken(response.data["token"]);
          SharedUtils.setRole(response.data["role"]);
        } else {
          emit(LoginFailed(
              message: 'Something went wrong. Please try again later'));
        }
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;

          if (statusCode == 522) {
            emit(LoginFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(LoginFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(LoginFailed(message: e.response?.data["message"][0]));
            } else {
              emit(LoginFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(LoginFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(LoginFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}

class UserRegisterBloc extends Bloc<RegisterEvent, UserRegisterState> {
  UserRegisterBloc() : super(UserRegisterInitial()) {
    on<UserRegisterEvent>((event, emit) => login(emit, event));
  }

  login(Emitter<UserRegisterState> emit, UserRegisterEvent event) async {
    emit(UserRegisterLoading());
    Response response;
    try {
      response = await AuthRepo().userRegister(data: event.userInfo);

      if (response.statusCode == 201) {
        emit(RegistrationCompleted(data: {
          "message":
              "Registration Successful. Please verify your email while logging in."
        }));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RegistrationFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(RegistrationFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RegistrationFailed(message: e.response?.data["message"][0]));
            } else {
              emit(RegistrationFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RegistrationFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(RegistrationFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc() : super(EmailVerificationInitial()) {
    on<InitiateEmailVerificationEvent>((event, emit) => sentOtp(emit, event));
    on<ResendEmailVerificationEvent>((event, emit) => resendOtp(emit, event));
    on<VerifyEmailEvent>((event, emit) => verify(emit, event));
  }

  sentOtp(Emitter<EmailVerificationState> emit,
      InitiateEmailVerificationEvent event) async {
    emit(EmailVerificationLoading());
    Response response;
    try {
      response =
          await AuthRepo().initiateEmailVerificaation(email: event.email);

      if (response.statusCode == 201) {
        emit(EmailVerificationInitiated(data: {
          "message":
              "Email Verification Otp sent. Please check your email for the verification code."
        }));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(EmailVerificationInitiationFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(EmailVerificationInitiationFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(EmailVerificationInitiationFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(EmailVerificationInitiationFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(EmailVerificationInitiationFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(EmailVerificationInitiationFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  resendOtp(Emitter<EmailVerificationState> emit,
      ResendEmailVerificationEvent event) async {
    emit(EmailVerificationLoading());
    Response response;
    try {
      response = await AuthRepo().resendEmailVerification(email: event.email);

      if (response.statusCode == 201) {
        emit(EmailVerificationResent(data: {
          "message":
              "Email Verification Otp sent. Please check your email for the verification code."
        }));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(EmailVerificationResendFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(EmailVerificationResendFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(EmailVerificationResendFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(EmailVerificationResendFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(EmailVerificationResendFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(EmailVerificationResendFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  verify(Emitter<EmailVerificationState> emit, VerifyEmailEvent event) async {
    emit(EmailVerificationLoading());
    Response response;
    try {
      response = await AuthRepo().verifyEmail(data: event.credentials);

      if (response.statusCode == 201) {
        emit(EmailVerificationCompleted(data: {
          "message": "Email Verification Successful. Please login to continue."
        }));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(EmailVerificationFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(EmailVerificationFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(EmailVerificationFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(EmailVerificationFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(EmailVerificationFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(EmailVerificationFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}

class PasswordResetBloc extends Bloc<ForgotPasswordEvent, PasswordResetState> {
  PasswordResetBloc() : super(PasswordResetInitial()) {
    on<RequestForgotPasswordEvent>((event, emit) => sendOtp(emit, event));
    on<ResendPasswordResetEvent>((event, emit) => resendOtp(emit, event));
    on<ResetPasswordEvent>((event, emit) => reset(emit, event));
    on<VerifyPasswordEvent>((event, emit) => verify(emit, event));
  }

  sendOtp(Emitter<PasswordResetState> emit,
      RequestForgotPasswordEvent event) async {
    emit(PasswordInitiateLoading());
    Response response;
    try {
      response = await AuthRepo().forgotPassword(email: event.email);

      if (response.statusCode == 201) {
        emit(PasswordInitiated(data: {
          "message":
              "Email Verification Otp sent. Please check your email for the verification code."
        }));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PasswordInitiationFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(PasswordInitiationFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PasswordInitiationFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(PasswordInitiationFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PasswordInitiationFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(PasswordInitiationFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  resendOtp(
      Emitter<PasswordResetState> emit, ResendPasswordResetEvent event) async {
    emit(PasswordResendOtpLoading());
    Response response;
    try {
      response = await AuthRepo().resendPasswordReset(email: event.email);

      if (response.statusCode == 201) {
        emit(PasswordResetOtpResent(data: {
          "message":
              "Email Verification Otp sent. Please check your email for the verification code."
        }));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PasswordResetOtpResendFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(PasswordResetOtpResendFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PasswordResetOtpResendFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(PasswordResetOtpResendFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PasswordResetOtpResendFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(PasswordResetOtpResendFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  reset(Emitter<PasswordResetState> emit, ResetPasswordEvent event) async {
    emit(PasswordResetLoading());
    Response response;
    try {
      response = await AuthRepo().resetPassword(data: event.credentials);

      if (response.statusCode == 201) {
        emit(PasswordResetCompleted(data: {
          "message": "Password reset successful. Please login to continue."
        }));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PasswordResetFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(PasswordResetFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(
                  PasswordResetFailed(message: e.response?.data["message"][0]));
            } else {
              emit(PasswordResetFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PasswordResetFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(PasswordResetFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  verify(Emitter<PasswordResetState> emit, VerifyPasswordEvent event) async {
    emit(VerifyPasswordLoading());
    Response response;
    try {
      response = await AuthRepo().verifyPassword(data: event.credentials);

      if (response.statusCode == 201) {
        emit(PasswordVerified(data: {
          "message":
              "OTP verified successfully. Please enter your new password."
        }));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PasswordVerificationFailed(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(PasswordVerificationFailed(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PasswordVerificationFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(PasswordVerificationFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PasswordVerificationFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(PasswordVerificationFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}
