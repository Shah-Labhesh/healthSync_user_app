import 'package:user_mobile_app/features/account/data/model/user.dart';

class Payment {
    String? id;
    int? amount;
    String? createdAt;
    String? khaltiMobile;
    String? khaltiToken;
    String? paymentType;
    User? user;
    User? doctor;

    Payment({
       this.id,
       this.amount,
       this.createdAt,
       this.khaltiMobile,
       this.khaltiToken,
       this.paymentType,
       this.user,
       this.doctor,
    });


  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] != null ? map['id'] as String : null,
      amount: map['amount'] != null ? map['amount'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      khaltiMobile: map['khaltiMobile'] != null ? map['khaltiMobile'] as String : null,
      khaltiToken: map['khaltiToken'] != null ? map['khaltiToken'] as String : null,
      paymentType: map['paymentType'] != null ? map['paymentType'] as String : null,
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String,dynamic>) : null,
      doctor: map['doctor'] != null ? User.fromMap(map['doctor'] as Map<String,dynamic>) : null,
    );
  }
  
}
