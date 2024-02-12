
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/slots/bloc/slots_event.dart';
import 'package:user_mobile_app/features/slots/bloc/slots_state.dart';
import 'package:user_mobile_app/features/slots/data/model/slot.dart';
import 'package:user_mobile_app/features/slots/data/repo/slot_repo.dart';

class SlotsBloc extends Bloc<SlotsEvent,SlotsState>{
  SlotsBloc() : super(SlotsInitial()){
    on<GetMySlots>((event, emit) => getSlots(emit,event));
     

    on<AddSlots>((event, emit) => addSlot(event, emit));
    on<UpdateSlot>((event, emit) => updateSlot(event, emit));
    on<DeleteSlot>((event, emit) => deleteSlot(event, emit));
  
  }
 SlotRepo slotRepo = SlotRepo();

  void getSlots(Emitter<SlotsState> emit, GetMySlots event) async {
    emit(SlotsLoading());
    try {
      final response = await slotRepo.getMySlots(sort: event.sort);
      if (response.statusCode == 200) {
        
        emit(SlotsLoaded(slots: SlotList.fromMap(response.data).slots));
      } 
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(SlotsError(
                message: "Connection timed out. Please try again later"));
          }else if (statusCode == 401) {
            emit(TokenExpired());
          }
           else if (statusCode! >= 500 || statusCode >= 402) {
            emit(SlotsError(
                message: 'Something went wrong. Please try again later'));
          } else {
           
           
            if (e.response?.data["message"].runtimeType != e.response?.data["message"]) {
              emit(SlotsError(message: e.response?.data["message"][0]));
            } else {
              emit(SlotsError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(SlotsError(
              message: 'Connection timed out. Please try again later'));
        }
      }else{
        emit(SlotsError(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  void addSlot(AddSlots event, Emitter<SlotsState> emit) async {
    emit(AddingSlots());
    try {
      final response = await slotRepo.addSlot(data: event.data);
      if (response.statusCode == 201) {
        emit(AddSlotsLoaded(slot: Slots.fromMap(response.data)));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
          emit(AddSlotsError(message: 'Connection timed out. Please try again later'));
          }else if (statusCode == 401) {
            emit(TokenExpired());
          }
           else if (statusCode! >= 500 || statusCode >= 402) {
            emit(AddSlotsError(message: e.response?.data["message"]));
          } else {
           
           
            if (e.response?.data["message"].runtimeType != String) {
              emit(AddSlotsError(message: e.response?.data["message"][0]));
            } else {
              emit(AddSlotsError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(AddSlotsError(message: 'Connection timed out. Please try again later'));
        }
      }else{
       emit(AddSlotsError(message: 'Connection timed out. Please try again later'));
      }
    }
  }

  void deleteSlot(DeleteSlot event, Emitter<SlotsState> emit) async {
    emit(DeleteSlotsLoading());
    try {
      final response = await slotRepo.deleteSlot(slotId: event.slotId);
      if (response.statusCode == 200) {
        emit(DeleteSlotsSuccess(id: event.slotId));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
          emit(DeleteSlotsError(message: 'Connection timed out. Please try again later'));
          }else if (statusCode == 401) {
            emit(TokenExpired());
          }
           else if (statusCode! >= 500 || statusCode >= 402) {
            emit(DeleteSlotsError(message: e.response?.data["message"]));
          } else {
           
           
            if (e.response?.data["message"].runtimeType != String) {
              emit(DeleteSlotsError(message: e.response?.data["message"][0]));
            } else {
              emit(DeleteSlotsError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DeleteSlotsError(message: 'Connection timed out. Please try again later'));
        }
      }else{
       emit(DeleteSlotsError(message: 'Connection timed out. Please try again later'));
      }
    }
  }

  void updateSlot(UpdateSlot event, Emitter<SlotsState> emit) async {
    emit(UpdateSlotsLoading());
    try {
      final response = await slotRepo.updateSlot(slotId: event.slotId,data: event.data);
      if (response.statusCode == 200) {
        emit(UpdateSlotsSuccess(slot: Slots.fromMap(response.data)));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
          emit(UpdateSlotsError(message: 'Connection timed out. Please try again later'));
          }else if (statusCode == 401) {
            emit(TokenExpired());
          }
           else if (statusCode! >= 500 || statusCode >= 402) {
            emit(UpdateSlotsError(message: e.response?.data["message"]));
          } else {
           
           
            if (e.response?.data["message"].runtimeType != String) {
              emit(UpdateSlotsError(message: e.response?.data["message"][0]));
            } else {
              emit(UpdateSlotsError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(UpdateSlotsError(message: 'Connection timed out. Please try again later'));
        }
      }else{
       emit(UpdateSlotsError(message: 'Connection timed out. Please try again later'));
      }
    }
  }
}