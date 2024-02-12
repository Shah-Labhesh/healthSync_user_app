import 'package:user_mobile_app/features/slots/data/model/slot.dart';

class SlotsState {}

class SlotsInitial extends SlotsState {}

class SlotsLoading extends SlotsState {}

class SlotsLoaded extends SlotsState {
  final List<Slots> slots;

  SlotsLoaded({required this.slots});
}

class SlotsError extends SlotsState {
  final String message;

  SlotsError({required this.message});
}


class AddingSlots extends SlotsState {}

class AddSlotsLoaded extends SlotsState {
  final Slots slot;

  AddSlotsLoaded({required this.slot});
}

class AddSlotsError extends SlotsState {
  final String message;

  AddSlotsError({required this.message});
}

class DeleteSlotsLoading extends SlotsState {}

class DeleteSlotsSuccess extends SlotsState {
  final String id;

  DeleteSlotsSuccess({required this.id});
}

class DeleteSlotsError extends SlotsState {
  final String message;

  DeleteSlotsError({required this.message});
}

class UpdateSlotsLoading extends SlotsState {}

class UpdateSlotsSuccess extends SlotsState {
  final Slots slot;

  UpdateSlotsSuccess({required this.slot});
}

class UpdateSlotsError extends SlotsState {
  final String message;

  UpdateSlotsError({required this.message});
}

class TokenExpired extends SlotsState {}
