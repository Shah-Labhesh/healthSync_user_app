class Requests {
  String? id;
  String? reason;
  String? type;
  bool? isAccepted;
  bool? isRejected;
  String? createdAt;

  Requests({
    this.id,
    this.reason,
    this.type,
    this.isAccepted,
    this.isRejected,
    this.createdAt,
  });

  factory Requests.fromMap(Map<String, dynamic> map) {
    return Requests(
      id: map['id'] != null ? map['id'] as String : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      isAccepted: map['accepted'] != null ? map['accepted'] as bool : null,
      isRejected: map['rejected'] != null ? map['rejected'] as bool : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }
}
