
class User {
    String? id;
    String? name;
    String? email;
    String? speciality;
    String? experience;
    String? authType;
    String? createdAt;
    String? updatedAt;
    String? deletedAt;
    String? accountStatus;
    int? fee;
    String? avatar;
    String? address;
    double? latitude;
    double? longitude;
    String? khaltiId;
    bool? approved;
    bool? favorite;
    double? avgRatings;
    bool? textNotification;
    int? ratingCount;
    bool? popular;
    bool? verified;

    User({
        this.id,
        this.name,
        this.email,
        this.speciality,
        this.experience,
        this.authType,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.accountStatus,
        this.fee,
        this.avatar,
        this.address,
        this.latitude,
        this.longitude,
        this.khaltiId,
        this.approved,
        this.favorite,
        this.popular,
        this.verified,
        this.textNotification,
        this.avgRatings,
        this.ratingCount,
    });



  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      speciality: map['speciality'] != null ? map['speciality'] as String : null,
      experience: map['experience'] != null ? map['experience'] as String : null,
      authType: map['authType'] != null ? map['authType'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      accountStatus: map['accountStatus'] != null ? map['accountStatus'] as String : null,
      fee: map['fee'] != null ? map['fee'] as int : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      khaltiId: map['khaltiId'] != null ? map['khaltiId'] as String : null,
      approved: map['approved'] != null ? map['approved'] as bool : null,
      favorite: map['favorite'] != null ? map['favorite'] as bool : null,
      popular: map['popular'] != null ? map['popular'] as bool : null,
      verified: map['verified'] != null ? map['verified'] as bool : null,
      avgRatings: map['avgRatings'] != null ? map['avgRatings'] as double : null,
      ratingCount: map['ratingCount'] != null ? map['ratingCount'] as int : null,
      textNotification: map['textNotification'] != null ? map['textNotification'] as bool : null,
    );
  }

  
}
