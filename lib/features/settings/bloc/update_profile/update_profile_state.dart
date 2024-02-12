import 'package:user_mobile_app/features/authentication/data/model/specialities.dart';

abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {}

class EmailVerificationState extends UpdateProfileState {}

class UpdateProfileFailed extends UpdateProfileState {
  final String message;

  UpdateProfileFailed({required this.message});
}

class TokenExpired extends UpdateProfileState {}

class ChangePasswordLoading extends UpdateProfileState {}

class ChangePasswordSuccess extends UpdateProfileState {}

class ChangePasswordFailed extends UpdateProfileState {
  final String message;

  ChangePasswordFailed({required this.message});
}

class ChangeNotificationStatusLoading extends UpdateProfileState {}

class ChangeNotificationStatusSuccess extends UpdateProfileState {}

class ChangeNotificationStatusFailed extends UpdateProfileState {
  final String message;

  ChangeNotificationStatusFailed({required this.message});
}

class UpdateFeeLoading extends UpdateProfileState {}

class UpdateFeeSuccess extends UpdateProfileState {
  final int fee;

  UpdateFeeSuccess({required this.fee});
}

class UpdateFeeFailed extends UpdateProfileState {
  final String message;

  UpdateFeeFailed({required this.message});
}

class UpdatingAddress extends UpdateProfileState {}

class UpdateAddressSuccess extends UpdateProfileState {}

class UpdateAddressFailed extends UpdateProfileState {
  final String message;

  UpdateAddressFailed({required this.message});
}


class FetchingSpecialities extends UpdateProfileState {}

class FetchSpecialitiesSuccess extends UpdateProfileState {
  final List<Specialities> specialities;

  FetchSpecialitiesSuccess({required this.specialities});
}

class FetchSpecialitiesFailed extends UpdateProfileState {
  final String message;

  FetchSpecialitiesFailed({required this.message});
}

class UpdatingSpecialities extends UpdateProfileState {}

class UpdateSpecialitiesSuccess extends UpdateProfileState {}

class UpdateSpecialitiesFailed extends UpdateProfileState {
  final String message;

  UpdateSpecialitiesFailed({required this.message});
}