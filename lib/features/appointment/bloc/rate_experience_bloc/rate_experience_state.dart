abstract class RateExperienceState{}

class RateExperienceInitial extends RateExperienceState{}

class RateExperienceLoading extends RateExperienceState{}

class RateExperienceSuccess extends RateExperienceState{
  final String message;

  RateExperienceSuccess({required this.message});
}

class RateExperienceFailure extends RateExperienceState{
  final String message;

  RateExperienceFailure({required this.message});
}

class TokenExpired extends RateExperienceState{}