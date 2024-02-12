import 'package:user_mobile_app/features/account/data/model/user.dart';

class Ratings {
    String? id;
    double? ratings;
    String? comment;
    String? ratingType;
    String? createdAt;
    String? updatedAt;
    User? doctor;
    User? user;
    dynamic appointment;

    Ratings({
        this.id,
        this.ratings,
        this.comment,
        this.ratingType,
        this.createdAt,
        this.updatedAt,
        this.doctor,
        this.user,
        this.appointment,
    });


  factory Ratings.fromMap(Map<String, dynamic> map) {
    return Ratings(
      id: map['id'] != null ? map['id'] as String : null,
      ratings: map['ratings'] != null ? map['ratings'] as double : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      ratingType: map['ratingType'] != null ? map['ratingType'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      doctor: map['doctor'] != null ? User.fromMap(map['doctor'] as Map<String,dynamic>) : null,
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String,dynamic>) : null,
      appointment: map['appointment'] as dynamic,
    );
  }

}
