
import 'package:user_mobile_app/features/account/data/model/user.dart';

class Prescription {
  String? id;
  User? doctor;
  User? user;
  String? prescription;
  String? createdAt;
  String? deletedAt;
  String? prescriptionText;
  String? recordType;
  Prescription({
    this.id,
    this.doctor,
    this.user,
    this.prescription,
    this.createdAt,
    this.deletedAt,
    this.prescriptionText,
    this.recordType,
  });

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id'] != null ? map['id'] as String : null,
      doctor: map['doctor'] != null
          ? User.fromMap(map['doctor'] as Map<String, dynamic>)
          : null,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      prescription:
          map['prescription'] != null ? map['prescription'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      prescriptionText: map['prescriptionText'] != null
          ? map['prescriptionText'] as String
          : null,
      recordType:
          map['recordType'] != null ? map['recordType'] as String : null,
    );
  }
}
