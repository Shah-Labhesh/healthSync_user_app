

import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/slots/data/model/slot.dart';

class Appointment {
    String? id;
    User? doctor;
    User? user;
    String? appointmentType;
    Slots? slot;
    String? notes;
    String? payment;
    String? paymentStatus;
    String? reminderTime;
    String? appointmentStatus;
    bool? isExpired;
    int? platformCost;
    int? totalFee;
    String? createdAt;
    String? updatedAt;
    String? deletedAt;

  Appointment({
    this.id,
    this.doctor,
    this.user,
    this.appointmentType,
    this.slot,
    this.notes,
    this.payment,
    this.paymentStatus,
    this.reminderTime,
    this.appointmentStatus,
    this.isExpired,
    this.platformCost,
    this.totalFee,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });


  

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] != null ? map['id'] as String : null,
      doctor: map['doctor'] != null ? User.fromMap(map['doctor'] as Map<String,dynamic>) : null,
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String,dynamic>) : null,
      appointmentType: map['appointmentType'] != null ? map['appointmentType'] as String : null,
      slot: map['slot'] != null ? Slots.fromMap(map['slot'] as Map<String,dynamic>) : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      payment: map['payment'] != null ? map['payment'] as String : null,
      paymentStatus: map['paymentStatus'] != null ? map['paymentStatus'] as String : null,
      reminderTime: map['reminderTime'] != null ? map['reminderTime'] as String : null,
      appointmentStatus: map['appointmentStatus'] != null ? map['appointmentStatus'] as String : null,
      isExpired: map['isExpired'] != null ? map['isExpired'] as bool : null,
      platformCost: map['platformCost'] != null ? map['platformCost'] as int : null,
      totalFee: map['totalFee'] != null ? map['totalFee'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
    );
  }

  

 
}



