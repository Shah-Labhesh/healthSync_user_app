abstract class SearchEvent {}

class SearchDoctors extends SearchEvent {
  final String? text;
  final String? speciality;
  final String? feeType;
  final String? feeFrom;
  final String? feeTo;
  final bool? popular;

  SearchDoctors({
    this.text,
    this.speciality,
    this.feeType,
    this.feeFrom,
    this.feeTo,
    this.popular,
  });
}

class GetSpecialities extends SearchEvent {}

class ToogleFavorite extends SearchEvent {
  final String id;

  ToogleFavorite({required this.id});
}
