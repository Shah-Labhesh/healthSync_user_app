

class FaQs {
    String? id;
    String? question;
    String? answer;
    String? createdAt;
    String? updatedAt;
    String? deletedAt;

    FaQs({
        this.id,
        this.question,
        this.answer,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });



  factory FaQs.fromMap(Map<String, dynamic> map) {
    return FaQs(
      id: map['id'] != null ? map['id'] as String : null,
      question: map['question'] != null ? map['question'] as String : null,
      answer: map['answer'] != null ? map['answer'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
    );
  }

}
