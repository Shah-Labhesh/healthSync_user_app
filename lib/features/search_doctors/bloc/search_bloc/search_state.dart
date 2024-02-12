import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/authentication/data/model/specialities.dart';

abstract class SearchState{}

class SearchInitial extends SearchState{}

class SearchLoading extends SearchState{}

class SearchSuccess extends SearchState{
  final List<User> doctors;
  SearchSuccess({required this.doctors});
}

class SearchFailure extends SearchState{
  final String message;
  SearchFailure({required this.message});
}

class SpecialityLoading extends SearchState{}

class SpecialitySuccess extends SearchState{
  final List<Specialities> specialities;
  SpecialitySuccess({required this.specialities});
}

class SpecialityFailure extends SearchState{
  final String message;
  SpecialityFailure({required this.message});
}

class ToogleFavoriteLoading extends SearchState{}

class ToogleFavoriteSuccess extends SearchState{
  final String id;
  
  ToogleFavoriteSuccess({required this.id});
}

class ToogleFavoriteFailure extends SearchState{
  final String message;
  ToogleFavoriteFailure({required this.message});
}

class TokenExpired extends SearchState{}