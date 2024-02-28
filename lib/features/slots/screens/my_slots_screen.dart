// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/slots/bloc/slots_bloc.dart';
import 'package:user_mobile_app/features/slots/bloc/slots_event.dart';
import 'package:user_mobile_app/features/slots/bloc/slots_state.dart';
import 'package:user_mobile_app/features/slots/data/model/slot.dart';
import 'package:user_mobile_app/features/slots/widgets/no_slots_widget.dart';
import 'package:user_mobile_app/features/slots/widgets/slots_tile_widget.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class MySlotsScreen extends StatefulWidget {
  const MySlotsScreen({super.key});

  @override
  State<MySlotsScreen> createState() => _MySlotsScreenState();
}

class _MySlotsScreenState extends State<MySlotsScreen> {
  String convertPickedDateTimeToISO8601(DateTime date, TimeOfDay time) {
    DateTime pickedDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    String iso8601String = pickedDateTime.toIso8601String();
    return iso8601String;
  }

  final SlotsBloc slotsBloc = SlotsBloc();

  List<Slots> slots = [];
  List<String> sortParams = ['ALL', 'BOOKED', 'UNBOOKED'];
  String selectedSortParam = 'ALL';

  void fetchData() {
    context.read<SlotsBloc>().add(GetMySlots(sort: selectedSortParam));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'My Slots',
          isBackButton: true,
          action: PopupMenuButton(
              itemBuilder: (context) {
                return sortParams
                    .map((e) => PopupMenuItem(
                          value: e,
                          child: Text(e.removeUnderScore()),
                          onTap: () {
                            setState(() {
                              selectedSortParam = e;
                            });
                            fetchData();
                          },
                        ))
                    .toList();
              },
              icon: const ImageIcon(
                AssetImage(filterIcon),
                color: gray800,
                size: 26,
              )),
        ),
      ),
      body: BlocConsumer<SlotsBloc, SlotsState>(
        listener: (context, state) {
          if (state is AddSlotsLoaded) {
            Utils.showSnackBar(context, "Slot Added Successfully",
                isSuccess: true);
            slots.add(state.slot);
          }
          if (state is AddSlotsError) {
            Utils.showSnackBar(context, state.message, isSuccess: false);
          }
          if (state is TokenExpired) {
            Utils.handleTokenExpired(context);
          }

          if (state is DeleteSlotsSuccess) {
            Utils.showSnackBar(context, "Slot Deleted Successfully",
                isSuccess: true);
            slots.removeWhere((element) => element.slotId == state.id);
          }

          if (state is DeleteSlotsError) {
            Utils.showSnackBar(context, state.message, isSuccess: false);
          }

          if (state is UpdateSlotsSuccess) {
            Utils.showSnackBar(context, "Slot Updated Successfully",
                isSuccess: true);
            slots.removeWhere((element) => element.slotId == state.slot.slotId);
            slots.add(state.slot);
          }

          if (state is UpdateSlotsError) {
            Utils.showSnackBar(context, state.message, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is SlotsInitial) {
            fetchData();
          }
          if (state is SlotsLoading) {
            return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
              color: blue900,
              size: 60,
            ));
          }
          if (state is SlotsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: red600),
              ),
            );
          }
          if (state is SlotsLoaded) {
            if (state.slots.isEmpty) {
              return const NoSlotsWidget();
            }
            slots = state.slots;
          }

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                fetchData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: WidthManager.w20,
                  vertical: PaddingManager.paddingMedium,
                ),
                child: Column(
                  children: [
                    for (Slots slot in slots)
                      SlotsTile(
                        slots: slot,
                        onEditTap: () {
                          DateTime newDate;
                          DateTime date = DateTime.parse(slot.slotDateTime!);
                          TimeOfDay time =
                              TimeOfDay(hour: date.hour, minute: date.minute);
                          showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 30),
                              )).then((value) {
                            if (value == null) {
                              Utils.showSnackBar(
                                  context, "Please select date and time",
                                  isSuccess: false);
                              return;
                            } else {
                              newDate = value;
                            }
                            showTimePicker(context: context, initialTime: time)
                                .then((t) {
                              if (t == null) {
                                Utils.showSnackBar(
                                    context, "Please select date and time",
                                    isSuccess: false);
                                return;
                              }

                              if (slot.slotId == null) {
                                Utils.showSnackBar(context, "Slot Id is null",
                                    isSuccess: false);
                                return;
                              }
                              if (Utils.checkInternetConnection(context)) {
                                context.read<SlotsBloc>().add(
                                      UpdateSlot(
                                        slotId: slot.slotId!,
                                        data: {
                                          "slotDateTime":
                                              convertPickedDateTimeToISO8601(
                                                  newDate, t)
                                        },
                                      ),
                                    );
                              }
                            });
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 30),
              ));
          TimeOfDay? time = await showTimePicker(
              context: context, initialTime: TimeOfDay.now());
          if (date == null || time == null) {
            Utils.showSnackBar(context, "Please select date and time",
                isSuccess: false);
            return;
          }
          context.read<SlotsBloc>().add(AddSlots(data: {
                "slotDateTime": convertPickedDateTimeToISO8601(date, time)
              }));
        },
        backgroundColor: blue900,
        child: const Icon(
          Icons.add,
          color: white,
          size: 22,
        ),
      ),
    );
  }
}
