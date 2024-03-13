import 'package:user_mobile_app/features/account/data/model/user.dart';

class RecordRequest {
    String? id;
    User? user;
    User? doctor;
    bool? accepted;
    bool? rejected;
    bool? expired;

    RecordRequest({
        this.id,
        this.user,
        this.doctor,
        this.accepted,
        this.rejected,
        this.expired,
    });



  factory RecordRequest.fromMap(Map<String, dynamic> map) {
    return RecordRequest(
      id: map['id'] != null ? map['id'] as String : null,
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String,dynamic>) : null,
      doctor: map['doctor'] != null ? User.fromMap(map['doctor'] as Map<String,dynamic>) : null,
      accepted: map['accepted'] != null ? map['accepted'] as bool : null,
      rejected: map['rejected'] != null ? map['rejected'] as bool : null,
      expired: map['expired'] != null ? map['expired'] as bool : null,
    );
  }

}
