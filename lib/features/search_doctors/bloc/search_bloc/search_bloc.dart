import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/authentication/data/model/specialities.dart';
import 'package:user_mobile_app/features/search_doctors/bloc/search_bloc/search_event.dart';
import 'package:user_mobile_app/features/search_doctors/bloc/search_bloc/search_state.dart';
import 'package:user_mobile_app/features/search_doctors/data/repo/search_repo.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchDoctors>((event, emit) => _search(event, emit));
    on<GetSpecialities>((event, emit) => _getSpecialities(event, emit));
    on<ToogleFavorite>((event, emit) => _toogleFavorite(event, emit));
  }

  void _search(SearchDoctors event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final response = await SearchRepo().searchDoctors(
        text: event.text,
        speciality: event.speciality,
        feeType: event.feeType,
        feeFrom: event.feeFrom,
        feeTo: event.feeTo,
        popular: event.popular,
      );
      if (response.statusCode == 200) {
        emit(SearchSuccess(doctors: (response.data as List<dynamic>).map((e) => User.fromMap(e)).toList()));
      } else {
        emit(SearchFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(SearchFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(SearchFailure(message: e.response?.data["message"][0]));
            } else {
              emit(SearchFailure(message: e.response?.data["message"]));
            }
          } else {
             if (e.response?.data["message"].runtimeType != String) {
              emit(SearchFailure(message: e.response?.data["message"][0]));
            } else {
              emit(SearchFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(SearchFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(SearchFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _getSpecialities(
      GetSpecialities event, Emitter<SearchState> emit) async {
    emit(SpecialityLoading());
    try {
      final response = await SearchRepo().getSpeciality();
      if (response.statusCode == 200) {
        emit(SpecialitySuccess(specialities: (response.data as List<dynamic>).map((e) => Specialities.fromMap(e)).toList()));
      } else {
        emit(SpecialityFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(SpecialityFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(SpecialityFailure(message: e.response?.data["message"][0]));
            } else {
              emit(SpecialityFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(SpecialityFailure(message: e.response?.data["message"][0]));
            } else {
              emit(SpecialityFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(SpecialityFailure(
              message: 'Something went wrong. Please try again later'));
        }
      }else {
        emit(SpecialityFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _toogleFavorite(ToogleFavorite event, Emitter<SearchState> emit) async {
    emit(ToogleFavoriteLoading());
    try {
      final response = await SearchRepo().toggleFavorite(event.id);
      if (response.statusCode == 200) {
        emit(ToogleFavoriteSuccess(id: event.id));
      } else {
        emit(ToogleFavoriteFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(ToogleFavoriteFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ToogleFavoriteFailure(message: e.response?.data["message"][0]));
            } else {
              emit(ToogleFavoriteFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ToogleFavoriteFailure(message: e.response?.data["message"][0]));
            } else {
              emit(ToogleFavoriteFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(ToogleFavoriteFailure(
              message: 'Something went wrong. Please try again later'));
        }
      }else{
        emit(ToogleFavoriteFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}
