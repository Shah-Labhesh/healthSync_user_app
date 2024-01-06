// ignore_for_file: public_member_api_docs, sort_constructors_first



import 'dart:convert';
import 'dart:io';

class Qualification{
  String? id;
  String title;
  String institute;
  String? passOutYear;
  File? image;

  Qualification({
    this.id,
    required this.title,
    required this.institute,
    required this.passOutYear,
    required this.image,
  });

 
}


class DocQualification {
  String? id;
  String? title;
  String? institute;
  String? passOutYear;
  String? image;

  DocQualification({
    this.id,
    required this.title,
    required this.institute,
    required this.passOutYear,
    required this.image,
  });

  


  factory DocQualification.fromMap(Map<String, dynamic> map) {
    return DocQualification(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['qualification'] != null ? map['qualification'] as String : null,
      institute: map['institute'] != null ? map['institute'] as String : null,
      passOutYear: map['passOutYear'] != null ? map['passOutYear'] as String : null,
      image: map['certificate'] != null ? map['certificate'] as String : null,
    );
  }

 
}
