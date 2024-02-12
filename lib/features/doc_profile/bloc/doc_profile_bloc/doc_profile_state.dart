import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/appointment/data/model/ratings.dart';
import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';

abstract class DocProfileState {}

class DocProfileInitial extends DocProfileState {}

class DocProfileLoading extends DocProfileState {}

class DocProfileLoaded extends DocProfileState {
  final User doctor;
  DocProfileLoaded({required this.doctor});
}

class DocProfileError extends DocProfileState {
  final String message;
  DocProfileError({required this.message});
}

class DocQualificationLoading extends DocProfileState {}

class DocQualificationLoaded extends DocProfileState {
  final List<DocQualification> qualification;
  DocQualificationLoaded({required this.qualification});
}

class DocQualificationError extends DocProfileState {
  final String message;
  DocQualificationError({required this.message});
}

class DocRatingsLoading extends DocProfileState {}

class DocRatingsLoaded extends DocProfileState {
  final List<Ratings> rating;
  DocRatingsLoaded({required this.rating});
}

class DocRatingsError extends DocProfileState {
  final String message;
  DocRatingsError({required this.message});
}

class FavouriteToggleLoading extends DocProfileState {}

class FavouriteToggled extends DocProfileState {
  final String id;
  FavouriteToggled({required this.id});
}

class FavouriteToggleError extends DocProfileState {
  final String message;
  FavouriteToggleError({required this.message});
}
class TokenExpired extends DocProfileState {}