import 'dart:convert';

import 'package:user_mobile_app/features/account/data/model/user.dart';

class BookAppointmentModel {
  String? slotId;
  String? doctorId;
  String? appointmentType;
  String? reminderTime;
  String? notes;
  String? slotDateTime;
  User? doctor;
  int? appointmentFee;
  int? platformCost;
  int? totalFee;
  BookAppointmentModel({
    this.slotId,
    this.doctorId,
    this.appointmentType,
    this.reminderTime,
    this.slotDateTime,
    this.doctor,
    this.notes,
    this.appointmentFee,
    this.platformCost,
    this.totalFee,
  });

  

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'slotId': slotId,
      'doctorId': doctorId,
      'appointmentType': appointmentType,
      'reminderTime': reminderTime,
      'notes': notes,
      'appointmentFee': appointmentFee,
      'platformCost': platformCost,
      'totalFee': totalFee,
    };
  }

  factory BookAppointmentModel.fromMap(Map<String, dynamic> map) {
    return BookAppointmentModel(
      slotId: map['slotId'] != null ? map['slotId'] as String : null,
      doctorId: map['doctorId'] != null ? map['doctorId'] as String : null,
      appointmentType: map['appointmentType'] != null ? map['appointmentType'] as String : null,
      reminderTime: map['reminderTime'] != null ? map['reminderTime'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      appointmentFee: map['appointmentFee'] != null ? map['appointmentFee'] as int : null,
      platformCost: map['platformCost'] != null ? map['platformCost'] as int : null,
      totalFee: map['totalFee'] != null ? map['totalFee'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookAppointmentModel.fromJson(String source) => BookAppointmentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
