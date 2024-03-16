// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class SearchEvent {}

class SearchDoctors extends SearchEvent {
  final String? text;
  final String? speciality;
  final String? feeType;
  final String? feeFrom;
  final double ratings;
  final String? feeTo;
  final bool? popular;

  SearchDoctors({
    this.text,
    this.speciality,
    this.feeType,
    this.feeFrom,
    required this.ratings,
    this.feeTo,
    this.popular,
  });
}

class GetSpecialities extends SearchEvent {}

class ToogleFavorite extends SearchEvent {
  final String id;

  ToogleFavorite({required this.id});
}
