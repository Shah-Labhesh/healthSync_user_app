
import 'package:user_mobile_app/features/account/data/model/user.dart';

class PrescriptionPermission {
    String? id;
    User? doctor;
    User? user;
    bool? accepted;
    bool? rejected;

    PrescriptionPermission({
        this.id,
        this.doctor,
        this.user,
        this.accepted,
        this.rejected,
    });


  factory PrescriptionPermission.fromMap(Map<String, dynamic> map) {
    return PrescriptionPermission(
      id: map['id'] != null ? map['id'] as String : null,
      doctor: map['doctor'] != null ? User.fromMap(map['doctor'] as Map<String,dynamic>) : null,
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String,dynamic>) : null,
      accepted: map['accepted'] != null ? map['accepted'] as bool : null,
      rejected: map['rejected'] != null ? map['rejected'] as bool : null,
    );
  }

}
