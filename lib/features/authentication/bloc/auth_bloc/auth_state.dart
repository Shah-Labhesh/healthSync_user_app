abstract class LoginState {}

class AuthInitial extends LoginState {}

class AuthLoading extends LoginState {}

class LoginSucess extends LoginState {
  Map<String, dynamic> data = {};

  LoginSucess({required this.data});
}

class UserNotVerified extends LoginState {
  Map<String, dynamic> data = {};

  UserNotVerified({required this.data});
}

class LoginFailed extends LoginState {
  String message = '';

  LoginFailed({required this.message});
}

abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationLoading extends EmailVerificationState {}

class EmailVerificationInitiated extends EmailVerificationState {
  Map<String, dynamic> data = {};

  EmailVerificationInitiated({required this.data});
}

class EmailVerificationInitiationFailed extends EmailVerificationState {
  String message = '';

  EmailVerificationInitiationFailed({required this.message});
}

class EmailVerificationCompleted extends EmailVerificationState {
  Map<String, dynamic> data = {};

  EmailVerificationCompleted({required this.data});
}

class EmailVerificationFailed extends EmailVerificationState {
  String message = '';

  EmailVerificationFailed({required this.message});
}

class EmailVerificationResent extends EmailVerificationState {
  Map<String, dynamic> data = {};

  EmailVerificationResent({required this.data});
}

class EmailVerificationResendFailed extends EmailVerificationState {
  String message = '';

  EmailVerificationResendFailed({required this.message});
}

abstract class PasswordResetState {}

class PasswordResetInitial extends PasswordResetState {}

class PasswordInitiateLoading extends PasswordResetState {}

class PasswordResetLoading extends PasswordResetState {}

class PasswordResendOtpLoading extends PasswordResetState {}

class VerifyPasswordLoading extends PasswordResetState {}

class PasswordInitiated extends PasswordResetState {
  Map<String, dynamic> data = {};

  PasswordInitiated({required this.data});
}

class PasswordInitiationFailed extends PasswordResetState {
  String message = '';

  PasswordInitiationFailed({required this.message});
}

class PasswordResetCompleted extends PasswordResetState {
  Map<String, dynamic> data = {};

  PasswordResetCompleted({required this.data});
}

class PasswordResetFailed extends PasswordResetState {
  String message = '';

  PasswordResetFailed({required this.message});
}

class PasswordResetOtpResent extends PasswordResetState {
  Map<String, dynamic> data = {};

  PasswordResetOtpResent({required this.data});
}

class PasswordResetOtpResendFailed extends PasswordResetState {
  String message = '';

  PasswordResetOtpResendFailed({required this.message});
}

class PasswordVerified extends PasswordResetState {
  Map<String, dynamic> data = {};

  PasswordVerified({required this.data});
}

class PasswordVerificationFailed extends PasswordResetState {
  String message = '';

  PasswordVerificationFailed({required this.message});
}

abstract class UserRegisterState {}

class UserRegisterInitial extends UserRegisterState {}

class UserRegisterLoading extends UserRegisterState {}

class RegistrationCompleted extends UserRegisterState {
  Map<String, dynamic> data = {};

  RegistrationCompleted({required this.data});
}

class RegistrationFailed extends UserRegisterState {
  String message = '';

  RegistrationFailed({required this.message});
}
