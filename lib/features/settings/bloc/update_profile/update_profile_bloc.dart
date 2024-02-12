import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/authentication/data/model/specialities.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_event.dart';
import 'package:user_mobile_app/features/settings/bloc/update_profile/update_profile_state.dart';
import 'package:user_mobile_app/features/settings/data/repo/settings_repo.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc() : super(UpdateProfileInitial()) {
    on<UpdateProfile>((event, emit) => updateProfile(emit, event));
    on<ChangePassword>((event, emit) => changePassword(emit, event));
    on<ChangeNotificationStatus>((event, emit) => changeNotificationStatus(emit, event));
    on<UpdateFeeEvent>((event, emit) => updateFee(emit, event));
    on<UpdateAddressEvent>((event, emit) => updateAddress(emit, event));
    on<FetchSpecialitiesEvent>((event, emit) => fetchSpecialities(emit));
    on<UpdateSpecialitiesEvent>((event, emit) => updateSpecialities(emit, event));
  }

  void updateProfile(
      Emitter<UpdateProfileState> emit, UpdateProfile event) async {
    emit(UpdateProfileLoading());
    try {
      Response response = await SettingRepo().updateCurrentUser(event.data);
      if (response.statusCode == 200) {
        if (response.data['emailUpdate'] == true){
          emit(EmailVerificationState());
        }else{
          emit(UpdateProfileSuccess());
        }
      } else {
        emit(UpdateProfileFailed(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(UpdateProfileFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            emit(UpdateProfileFailed(message: e.response?.data["message"]));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UpdateProfileFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(UpdateProfileFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(UpdateProfileFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(UpdateProfileFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void changePassword(
      Emitter<UpdateProfileState> emit, ChangePassword event) async {
    emit(ChangePasswordLoading());
    try {
      Response response = await SettingRepo().updateCurrentUser(event.data);
      if (response.statusCode == 200) {
        emit(ChangePasswordSuccess());
      } else {
        emit(ChangePasswordFailed(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(ChangePasswordFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            emit(ChangePasswordFailed(message: e.response?.data["message"][0]));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ChangePasswordFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(ChangePasswordFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(ChangePasswordFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(ChangePasswordFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void changeNotificationStatus(
      Emitter<UpdateProfileState> emit, ChangeNotificationStatus event) async {
    emit(ChangeNotificationStatusLoading());
    try {
      Response response = await SettingRepo().updateCurrentUser(event.data);
      if (response.statusCode == 200) {
        emit(ChangeNotificationStatusSuccess());
      } else {
        emit(ChangeNotificationStatusFailed(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(ChangeNotificationStatusFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ChangeNotificationStatusFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(ChangeNotificationStatusFailed(
                  message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ChangeNotificationStatusFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(ChangeNotificationStatusFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(ChangeNotificationStatusFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(ChangeNotificationStatusFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void updateFee(
      Emitter<UpdateProfileState> emit, UpdateFeeEvent event) async {
    emit(UpdateFeeLoading());
    try {
      Response response = await SettingRepo().updateCurrentUser(event.data);
      if (response.statusCode == 200) {
        emit(UpdateFeeSuccess(fee: event.data['fee']));
      } else {
        emit(UpdateFeeFailed(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(UpdateFeeFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UpdateFeeFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(UpdateFeeFailed(
                  message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UpdateFeeFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(UpdateFeeFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(UpdateFeeFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(UpdateFeeFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void updateAddress(
      Emitter<UpdateProfileState> emit, UpdateAddressEvent event) async {
    emit(UpdatingAddress());
    try {
      Response response = await SettingRepo().updateCurrentUser(event.data);
      print(response);
      if (response.statusCode == 200) {
        emit(UpdateAddressSuccess());
      } else {
        emit(UpdateAddressFailed(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(UpdateAddressFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UpdateAddressFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(UpdateAddressFailed(
                  message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UpdateAddressFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(UpdateAddressFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(UpdateAddressFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(UpdateAddressFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void fetchSpecialities(Emitter<UpdateProfileState> emit) async {
    emit(FetchingSpecialities());
    try {
      Response response = await SettingRepo().getSpeciality();
      if (response.statusCode == 200) {
        emit(FetchSpecialitiesSuccess(specialities: (response.data as List<dynamic>).map((e) => Specialities.fromMap(e as Map<String, dynamic>)).toList()));
      } else {
        emit(FetchSpecialitiesFailed(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(FetchSpecialitiesFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(FetchSpecialitiesFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(FetchSpecialitiesFailed(
                  message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(FetchSpecialitiesFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(FetchSpecialitiesFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(FetchSpecialitiesFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(FetchSpecialitiesFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void updateSpecialities(
      Emitter<UpdateProfileState> emit, UpdateSpecialitiesEvent event) async {
    emit(UpdatingSpecialities());
    try {
      Response response = await SettingRepo().updateCurrentUser(event.data);
      if (response.statusCode == 200) {
        emit(UpdateSpecialitiesSuccess());
      } else {
        emit(UpdateSpecialitiesFailed(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(UpdateSpecialitiesFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UpdateSpecialitiesFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(UpdateSpecialitiesFailed(
                  message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UpdateSpecialitiesFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(UpdateSpecialitiesFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(UpdateSpecialitiesFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(UpdateSpecialitiesFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}