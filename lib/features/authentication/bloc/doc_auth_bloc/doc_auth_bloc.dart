import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';
import 'package:user_mobile_app/features/authentication/data/repo/auth_repo.dart';

import 'doc_auth_event.dart';
import 'doc_auth_state.dart';

class DocRegisterBloc extends Bloc<DocAuthEvent, DocAuthState> {
  DocRegisterBloc() : super(DocRegisterInitial()) {
    on<RegisterDoctorEvent>((event, emit) => register(emit, event));
  }

  register(Emitter<DocAuthState> emit, RegisterDoctorEvent event) async {
    emit(DocRegisterLoading());
    Response response;
    try {
      response = await AuthRepo().doctorRegister(data: event.credentials);
      print(response);
      if (response.statusCode == 201) {
        emit(DocRegisterSuccess(id: response.data['id']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(DocRegisterFailure(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(DocRegisterFailure(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType !=
                e.response?.data["message"]) {
              emit(DocRegisterFailure(message: e.response?.data["message"][0]));
            } else {
              emit(DocRegisterFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DocRegisterFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(DocRegisterFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}

class DocAddressBloc extends Bloc<DocAddressEvent, DocAddressState> {
  DocAddressBloc() : super(DocAddressInitial()) {
    on<AddAddressEvent>((event, emit) => uploadAddress(emit, event));
  }

  uploadAddress(Emitter<DocAddressState> emit, AddAddressEvent event) async {
    emit(DocAddressLoading());
    Response response;
    try {
      response = await AuthRepo()
          .uploadAddress(id: event.doctorId, data: event.address);
      print(response);
      if (response.statusCode == 201) {
        emit(DocAddressSuccess());
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(DocAddressFailure(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(DocAddressFailure(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType !=
                e.response?.data["message"]) {
              emit(DocAddressFailure(message: e.response?.data["message"][0]));
            } else {
              emit(DocAddressFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DocAddressFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(DocAddressFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}

class DocDetailsBloc extends Bloc<DocDetailsEvent, DocDetailsState> {
  DocDetailsBloc() : super(DocDetailsInitial()) {
    on<AddDocDetailsEvent>((event, emit) => uploadAddress(emit, event));
  }

  uploadAddress(Emitter<DocDetailsState> emit, AddDocDetailsEvent event) async {
    emit(DocDetailsLoading());
    Response response;
    try {
      response = await AuthRepo()
          .uploadDetails(id: event.doctorId, data: event.details);
      print(response);
      if (response.statusCode == 201) {
        emit(DocDetailsSuccess());
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(DocDetailsFailure(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(DocDetailsFailure(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType !=
                e.response?.data["message"]) {
              emit(DocDetailsFailure(message: e.response?.data["message"][0]));
            } else {
              emit(DocDetailsFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DocDetailsFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(DocDetailsFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}

class MoreDocDetailsBloc
    extends Bloc<MoreDocDetailsEvent, MoreDocDetailsState> {
  MoreDocDetailsBloc() : super(MoreDocDetailsInitial()) {
    on<AddMoreDocDetailsEvent>((event, emit) => addMoreDetails(emit, event));
    on<AddDocQualificationEvent>(
        (event, emit) => addQualification(emit, event));
    on<EditDocQualificationEvent>(
        (event, emit) => editQualification(emit, event));
    on<DeleteDocQualificationEvent>(
        (event, emit) => deleteQualification(emit, event));
    on<GetDocQualificationEvent>(
        (event, emit) => getQualification(emit, event));
  }

  addMoreDetails(
      Emitter<MoreDocDetailsState> emit, AddMoreDocDetailsEvent event) async {
    emit(MoreDocDetailsLoading());
    Response response;
    try {
      response =
          await AuthRepo().addKhaltiId(id: event.doctorId, data: event.details);
      if (response.statusCode == 201) {
        emit(MoreDocDetailsSuccess());
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          print(e.response!.data);
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(MoreDocDetailsFailure(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(MoreDocDetailsFailure(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType !=
                e.response?.data["message"]) {
              emit(MoreDocDetailsFailure(
                  message: e.response?.data["message"][0]));
            } else {
              emit(MoreDocDetailsFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(MoreDocDetailsFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(MoreDocDetailsFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  addQualification(
      Emitter<MoreDocDetailsState> emit, AddDocQualificationEvent event) async {
    emit(MoreDocDetailsLoading());
    Response response;
    try {
      print('try');

      response = await AuthRepo()
          .addQualification(id: event.doctorId, data: event.qualification);
      if (response.statusCode == 201) {
        print(response.data["id"]);
        emit(AddDocQualificationSuccess(qualificationId: response.data["id"]));
      }
    } catch (e) {
      print(e.toString());

      if (e is DioException) {
        if (e.response != null) {
          print(e.response!.data);
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(AddDocQualificationFailure(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(AddDocQualificationFailure(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType !=
                e.response?.data["message"]) {
              emit(AddDocQualificationFailure(
                  message: e.response?.data["message"][0]));
            } else {
              emit(AddDocQualificationFailure(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(AddDocQualificationFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(AddDocQualificationFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  editQualification(Emitter<MoreDocDetailsState> emit,
      EditDocQualificationEvent event) async {
    emit(MoreDocDetailsLoading());
    Response response;
    try {
      response = await AuthRepo().updateQualification(
          doctorId: event.doctorId,
          data: event.qualification,
          qualificationId: event.qualificationId);
      if (response.statusCode == 200) {
        emit(EditDocQualificationSuccess());
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          print(e.response!.data);
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(EditDocQualificationFailure(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(EditDocQualificationFailure(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType !=
                e.response?.data["message"]) {
              emit(EditDocQualificationFailure(
                  message: e.response?.data["message"][0]));
            } else {
              emit(EditDocQualificationFailure(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(EditDocQualificationFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(EditDocQualificationFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  deleteQualification(Emitter<MoreDocDetailsState> emit,
      DeleteDocQualificationEvent event) async {
    emit(MoreDocDetailsLoading());
    Response response;
    try {
      response = await AuthRepo().deleteQualification(
          doctorId: event.doctorId, qualificationId: event.qualificationId);
      if (response.statusCode == 200) {
        emit(DeleteDocQualificationSuccess());
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          print(e.response!.data);
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(DeleteDocQualificationFailure(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(DeleteDocQualificationFailure(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType !=
                e.response?.data["message"]) {
              emit(DeleteDocQualificationFailure(
                  message: e.response?.data["message"][0]));
            } else {
              emit(DeleteDocQualificationFailure(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DeleteDocQualificationFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(DeleteDocQualificationFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  getQualification(
      Emitter<MoreDocDetailsState> emit, GetDocQualificationEvent event) async {
    emit(MoreDocDetailsLoading());
    Response response;
    try {
      response = await AuthRepo().getQualification(doctorId: event.doctorId);
      if (response.statusCode == 200) {
        emit(
          GetDocQualificationSuccess(
            qualifications: (response.data as List)
                .map((e) => DocQualification.fromMap(e))
                .toList(),
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          print(e.response!.data);
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(GetDocQualificationFailure(
                message: "Connection timed out. Please try again later"));
          } else if (statusCode! >= 500 || statusCode >= 401) {
            emit(GetDocQualificationFailure(
                message: 'Something went wrong. Please try again later'));
          } else {
            if (e.response?.data["message"].runtimeType !=
                e.response?.data["message"]) {
              emit(GetDocQualificationFailure(
                  message: e.response?.data["message"][0]));
            } else {
              emit(GetDocQualificationFailure(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(GetDocQualificationFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        print(e.toString());
        emit(GetDocQualificationFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}
