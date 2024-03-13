abstract class RequestDeletionEvent {}

class RequestDeletion extends RequestDeletionEvent {
  final Map<String, dynamic> data;
  RequestDeletion({required this.data});
}

class FetchRequestDeletion extends RequestDeletionEvent {}
