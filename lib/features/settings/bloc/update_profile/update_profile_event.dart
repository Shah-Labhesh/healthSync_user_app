abstract class UpdateProfileEvent {}

class UpdateProfile extends UpdateProfileEvent {
  final Map<String,dynamic> data;

  UpdateProfile({required this.data});
}

class ChangePassword extends UpdateProfileEvent {
  final Map<String,dynamic> data;

  ChangePassword({required this.data});
}

class ChangeNotificationStatus extends UpdateProfileEvent {
  final Map<String,dynamic> data;

  ChangeNotificationStatus({required this.data});
}

class UpdateFeeEvent extends UpdateProfileEvent {
  final Map<String,dynamic> data;

  UpdateFeeEvent({required this.data});
}

class UpdateAddressEvent extends UpdateProfileEvent {
  final Map<String,dynamic> data;

  UpdateAddressEvent({required this.data});
}

class FetchSpecialitiesEvent extends UpdateProfileEvent {
  
}

class UpdateSpecialitiesEvent extends UpdateProfileEvent {
  final Map<String,dynamic> data;

  UpdateSpecialitiesEvent({required this.data});
}
