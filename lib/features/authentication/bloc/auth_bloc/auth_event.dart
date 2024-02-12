abstract class LoginEvent {}

class RequestLoginEvent extends LoginEvent {
  Map<String, dynamic> credentials = {};

  RequestLoginEvent({required this.credentials});
}

class RequestGoogleLoginEvent extends LoginEvent {}

abstract class RegisterEvent {}

class UserRegisterEvent extends RegisterEvent {
  Map<String, dynamic> userInfo = {};

  UserRegisterEvent({required this.userInfo});
}

abstract class ForgotPasswordEvent {}

class RequestForgotPasswordEvent extends ForgotPasswordEvent {
  String email = '';

  RequestForgotPasswordEvent({required this.email});
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  Map<String, dynamic> credentials = {};

  ResetPasswordEvent({required this.credentials});
}

class ResendPasswordResetEvent extends ForgotPasswordEvent {
  String email = '';

  ResendPasswordResetEvent({required this.email});
}

class VerifyPasswordEvent extends ForgotPasswordEvent {
  Map<String, dynamic> credentials = {};

  VerifyPasswordEvent({required this.credentials});
}

abstract class EmailVerificationEvent {}

class InitiateEmailVerificationEvent extends EmailVerificationEvent {
  String email = '';

  InitiateEmailVerificationEvent({required this.email});
}

class VerifyEmailEvent extends EmailVerificationEvent {
  Map<String, dynamic> credentials = {};

  VerifyEmailEvent({required this.credentials});
}

class ResendEmailVerificationEvent extends EmailVerificationEvent {
  String email = '';

  ResendEmailVerificationEvent({required this.email});
}
