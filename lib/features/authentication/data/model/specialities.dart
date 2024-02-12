

class Specialities {
  String? id;
  String? name;
  String? image;

  Specialities({
    this.id,
    this.name,
    this.image,
  });

 
  factory Specialities.fromMap(Map<String, dynamic> map) {
    return Specialities(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  
}


