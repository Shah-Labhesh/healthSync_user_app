import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';
import 'package:user_mobile_app/features/settings/bloc/qualification_bloc/qualification_event.dart';
import 'package:user_mobile_app/features/settings/bloc/qualification_bloc/qualification_state.dart';
import 'package:user_mobile_app/features/settings/data/repo/qualification_repo.dart';

class QualificationBloc extends Bloc<QualificationEvent, QualificationState> {
  QualificationBloc() : super(QualificationInitial()) {
    on<GetQualifications>((event, emit) => getQualification(emit));
    on<AddQualification>((event, emit) => addQualification(event, emit));
    on<DeleteQualification>((event, emit) => deleteQualification(event, emit));
    on<UpdateQualification>((event, emit) => updateQualification(event, emit));
  }

  void getQualification(Emitter<QualificationState> emit) async {
    emit(QualificationLoading());
    try {
      final response = await QualificationRepo().getQualification();
      if (response.statusCode == 200) {
        emit(QualificationSuccess(qualifications: (response.data as List<dynamic>).map((e) => DocQualification.fromMap(e)).toList()));
      } else {
        emit(QualificationFailure(message: response.data['message']));
      }
    } catch (e) {
      print(e);
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(QualificationFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(QualificationFailure(message: e.response?.data["message"][0]));
            } else {
              emit(QualificationFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(QualificationFailure(message: e.response?.data["message"][0]));
            } else {
              emit(QualificationFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(QualificationFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(QualificationFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void addQualification(AddQualification event, Emitter<QualificationState> emit) async {
    emit(QualificationAdding());
    try {
      final response = await QualificationRepo().addQualification(event.body);
      if (response.statusCode == 201) {
        emit(QualificationAdded(qualification: DocQualification.fromMap(response.data)));
      } else {
        emit(QualificationAddingFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(QualificationAddingFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(QualificationAddingFailure(message: e.response?.data["message"][0]));
            } else {
              emit(QualificationAddingFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(QualificationAddingFailure(message: e.response?.data["message"][0]));
            } else {
              emit(QualificationAddingFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(QualificationAddingFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(QualificationAddingFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void deleteQualification(DeleteQualification event, Emitter<QualificationState> emit) async {
    emit(QualificationDeleting());
    try {
      final response = await QualificationRepo().deleteQualification(id: event.id);
      if (response.statusCode == 200) {
        emit(QualificationDeleted(id: event.id));
      } else {
        emit(QualificationDeletingFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(QualificationDeletingFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(QualificationDeletingFailure(message: e.response?.data["message"][0]));
            } else {
              emit(QualificationDeletingFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(QualificationDeletingFailure(message: e.response?.data["message"][0]));
            } else {
              emit(QualificationDeletingFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(QualificationDeletingFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(QualificationDeletingFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void updateQualification(UpdateQualification event, Emitter<QualificationState> emit) async {
    emit(QualificationUpdating());
    try {
      final response = await QualificationRepo().updateQualification(id: event.id, body: event.body);
      if (response.statusCode == 200) {
        emit(QualificationUpdated(qualification: DocQualification.fromMap(response.data)));
      } else {
        emit(QualificationUpdatingFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(QualificationUpdatingFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(QualificationUpdatingFailure(message: e.response?.data["message"][0]));
            } else {
              emit(QualificationUpdatingFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(QualificationUpdatingFailure(message: e.response?.data["message"][0]));
            } else {
              emit(QualificationUpdatingFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(QualificationUpdatingFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(QualificationUpdatingFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}