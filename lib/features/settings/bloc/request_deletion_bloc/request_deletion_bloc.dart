import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/request_deletion_bloc/request_deletion_event.dart';
import 'package:user_mobile_app/features/settings/bloc/request_deletion_bloc/request_deletion_state.dart';
import 'package:user_mobile_app/features/settings/data/model/requests.dart';
import 'package:user_mobile_app/features/settings/data/repo/deletion_repo.dart';

class RequestDeletionBloc
    extends Bloc<RequestDeletionEvent, RequestDeletionState> {
  RequestDeletionBloc() : super(RequestDeletionInitial()) {
    on<RequestDeletion>((event, emit) => requestDeletion(event, emit));
    on<FetchRequestDeletion>(
        (event, emit) => fetchRequestDeletion(event, emit));
  }

  final repo = DeletionRepo();
  void requestDeletion(
      RequestDeletion event, Emitter<RequestDeletionState> emit) async {
    emit(RequestingDeletion());
    try {
      Response response = await repo.requestForDeletion(event.data);
      if (response.statusCode == 201) {
        emit(RequestDeletionSuccess(
            message: 'Request for deletion has been sent'));
      } else {
        emit(RequestDeletionFailure(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RequestDeletionFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RequestDeletionFailure(
                  message: e.response?.data["message"][0]));
            } else {
              emit(
                  RequestDeletionFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RequestDeletionFailure(
                  message: e.response?.data["message"][0]));
            } else {
              emit(
                  RequestDeletionFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RequestDeletionFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RequestDeletionFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void fetchRequestDeletion(
      FetchRequestDeletion event, Emitter<RequestDeletionState> emit) async {
    emit(RequestDeletionLoading());
    try {
      Response response = await repo.fetchRequestDeletion();
      if (response.statusCode == 200) {
        emit(
          RequestDeletionLoaded(
            requestDeletion: (response.data as List<dynamic>)
                .map((e) => Requests.fromMap(e as Map<String, dynamic>))
                .toList(),
          ),
        );
      } else {
        emit(RequestDeletionError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RequestDeletionError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RequestDeletionError(
                  message: e.response?.data["message"][0]));
            } else {
              emit(
                  RequestDeletionError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RequestDeletionError(
                  message: e.response?.data["message"][0]));
            } else {
              emit(
                  RequestDeletionError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RequestDeletionError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RequestDeletionError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}
