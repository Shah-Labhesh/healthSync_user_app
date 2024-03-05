import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/appointment/data/model/ratings.dart';
import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';
import 'package:user_mobile_app/features/chats/data/model/chat_room.dart';
import 'package:user_mobile_app/features/doc_profile/bloc/doc_profile_bloc/doc_profile_event.dart';
import 'package:user_mobile_app/features/doc_profile/bloc/doc_profile_bloc/doc_profile_state.dart';
import 'package:user_mobile_app/features/doc_profile/data/repo/doc_profile_repo.dart';

class DocProfileBloc extends Bloc<DocProfileEvent, DocProfileState> {
  DocProfileBloc() : super(DocProfileInitial()) {
    on<GetDocProfile>((event, emit) => getDocProfile(event, emit));
    on<GetDocQualification>((event, emit) => getDocQualification(event, emit));
    on<GetDocRatings>((event, emit) => getDocRatings(event, emit));
    on<ToggleFavourite>((event, emit) => toggleFavourite(event, emit));
    on<CreateChatRoom>((event, emit) => createChatRoom(event, emit));
  }

  final _repo = DocProfileRepo();

  void getDocProfile(GetDocProfile event, Emitter<DocProfileState> emit) async {
    emit(DocProfileLoading());
    try {
      Response response = await _repo.getDocProfile(event.doctorId);
      if (response.statusCode == 200) {
        emit(DocProfileLoaded(doctor: User.fromMap(response.data)));
      } else {
        emit(DocProfileError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(DocProfileError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(DocProfileError(message: e.response?.data["message"][0]));
            } else {
              emit(DocProfileError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(DocProfileError(message: e.response?.data["message"][0]));
            } else {
              emit(DocProfileError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DocProfileError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(DocProfileError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void getDocQualification(
      GetDocQualification event, Emitter<DocProfileState> emit) async {
    emit(DocQualificationLoading());
    try {
      Response response =
          await _repo.getDocQualification(event.doctorId);
      if (response.statusCode == 200) {
        emit(DocQualificationLoaded(
            qualification: (response.data as List)
                .map((e) => DocQualification.fromMap(e))
                .toList()));
      } else {
        emit(DocQualificationError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(DocQualificationError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(DocQualificationError(
                  message: e.response?.data["message"][0]));
            } else {
              emit(DocQualificationError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(DocQualificationError(
                  message: e.response?.data["message"][0]));
            } else {
              emit(DocQualificationError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DocQualificationError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(DocQualificationError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void getDocRatings(GetDocRatings event, Emitter<DocProfileState> emit) async {
    emit(DocRatingsLoading());
    try {
      Response response = await _repo.getDocRatings(event.doctorId);
      if (response.statusCode == 200) {
        emit(DocRatingsLoaded(
            rating: (response.data as List<dynamic>)
                .map((e) => Ratings.fromMap(e as Map<String, dynamic>))
                .toList()));
      } else {
        emit(DocRatingsError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(DocRatingsError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(DocRatingsError(message: e.response?.data["message"][0]));
            } else {
              emit(DocRatingsError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(DocRatingsError(message: e.response?.data["message"][0]));
            } else {
              emit(DocRatingsError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DocRatingsError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(DocRatingsError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void toggleFavourite(
      ToggleFavourite event, Emitter<DocProfileState> emit) async {
    emit(FavouriteToggleLoading());
    try {
      Response response =
          await _repo.toggleFavourite(event.doctorId);
      if (response.statusCode == 200) {
        emit(FavouriteToggled(id: event.doctorId));
      } else {
        emit(FavouriteToggleError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(FavouriteToggleError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(FavouriteToggleError(
                  message: e.response?.data["message"][0]));
            } else {
              emit(FavouriteToggleError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(FavouriteToggleError(
                  message: e.response?.data["message"][0]));
            } else {
              emit(FavouriteToggleError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(FavouriteToggleError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(FavouriteToggleError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void createChatRoom(CreateChatRoom event, Emitter<DocProfileState> emit) async {
    emit(CreatingChatRoom());
    try {
      Response response = await _repo.createChatRoom(event.doctorId);
      if (response.statusCode == 200) {
        emit(ChatRoomCreated(chatRoom: ChatRoom.fromMap(response.data)));
      } else {
        emit(ChatRoomError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(ChatRoomError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ChatRoomError(message: e.response?.data["message"][0]));
            } else {
              emit(ChatRoomError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ChatRoomError(message: e.response?.data["message"][0]));
            } else {
              emit(ChatRoomError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(ChatRoomError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(ChatRoomError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}
