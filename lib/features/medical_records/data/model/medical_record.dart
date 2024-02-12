import 'package:user_mobile_app/features/account/data/model/user.dart';

class MedicalRecord {
  String? id;
  String? recordType;
  String? record;
  String? recordCreatedDate;
  bool? selfAdded;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  User? user;
  User? doctor;

  MedicalRecord({
    this.id,
    this.recordType,
    this.record,
    this.recordCreatedDate,
    this.selfAdded,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.doctor,
  });

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'] != null ? map['id'] as String : null,
      recordType:
          map['recordType'] != null ? map['recordType'] as String : null,
      record: map['record'] != null ? map['record'] as String : null,
      recordCreatedDate: map['recordCreatedDate'] != null
          ? map['recordCreatedDate'] as String
          : null,
      selfAdded: map['selfAdded'] != null ? map['selfAdded'] as bool : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      doctor: map['doctor'] != null
          ? User.fromMap(map['doctor'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ShareMedicalRecord {
  String? id;
  User? user;
  User? doctor;
  MedicalRecord? medicalRecords;
  ShareMedicalRecord({
    this.id,
    this.user,
    this.doctor,
    this.medicalRecords,
  });

  factory ShareMedicalRecord.fromMap(Map<String, dynamic> map) {
    return ShareMedicalRecord(
      id: map['id'] != null ? map['id'] as String : null,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      doctor: map['doctor'] != null
          ? User.fromMap(map['doctor'] as Map<String, dynamic>)
          : null,
      medicalRecords: map['medicalRecords'] != null
          ? MedicalRecord.fromMap(map['medicalRecords'] as Map<String, dynamic>)
          : null,
    );
  }
}
