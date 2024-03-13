import 'package:user_mobile_app/features/settings/data/model/requests.dart';

abstract class RequestDeletionState {}

class RequestDeletionInitial extends RequestDeletionState {}

class RequestingDeletion extends RequestDeletionState {}

class RequestDeletionLoading extends RequestDeletionState {}

class RequestDeletionSuccess extends RequestDeletionState {
  final String message;
  RequestDeletionSuccess({required this.message});
}

class RequestDeletionFailure extends RequestDeletionState {
  final String message;
  RequestDeletionFailure({required this.message});
}

class TokenExpired extends RequestDeletionState {}

class RequestDeletionLoaded extends RequestDeletionState {
  final List<Requests> requestDeletion;
  RequestDeletionLoaded({required this.requestDeletion});
}

class RequestDeletionError extends RequestDeletionState {
  final String message;
  RequestDeletionError({required this.message});
}
