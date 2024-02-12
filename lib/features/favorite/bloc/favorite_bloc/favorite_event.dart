abstract class FavoriteEvent {}

class FetchFavoriteEvent extends FavoriteEvent {}

class ToggleFavouriteEvent extends FavoriteEvent {
  final String doctorId;

  ToggleFavouriteEvent({required this.doctorId});
}

