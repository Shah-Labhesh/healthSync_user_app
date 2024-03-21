import 'package:user_mobile_app/features/account/data/model/user.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<User> doctors;

  FavoriteLoaded({required this.doctors});
}

class FavoriteLoadFailed extends FavoriteState {
  String message = '';

  FavoriteLoadFailed({required this.message});
}

class TokenExpired extends FavoriteState {}

class ToggleFavouriteLoading extends FavoriteState {}

class ToggleFavouriteSuccess extends FavoriteState {
  
}

class ToggleFavouriteFailed extends FavoriteState {
  final String message;

  ToggleFavouriteFailed({required this.message});
}