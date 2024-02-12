import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/slots/bloc/slots_bloc.dart';
import 'package:user_mobile_app/features/slots/bloc/slots_event.dart';
import 'package:user_mobile_app/features/slots/data/model/slot.dart';
import 'package:user_mobile_app/features/slots/widgets/custom_icon_button.dart';
import 'package:user_mobile_app/features/slots/widgets/delete_dialog.dart';

class SlotsTile extends StatelessWidget {
  SlotsTile({
    super.key,
    required this.slots,
    this.onEditTap,
    this.onDeleteTap,
  });

  final Slots slots;

  final Map<int, String> months = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "June",
    7: "July",
    8: "Aug",
    9: "Sept",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };

  final Function()? onEditTap;
  final Function()? onDeleteTap;

  String convertDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateTime now = DateTime.now();
    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return "Today, ${dateTime.day} ${months[dateTime.month]}";
    }
    if (dateTime.day == now.day + 1 &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return "Tomorrow, ${dateTime.day} ${months[dateTime.month]}";
    }
    if (dateTime.day >= now.day + 2 &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return "${dateTime.day} ${months[dateTime.month]}, ${dateTime.year}";
    }

    return "${dateTime.day} ${months[dateTime.month]}, ${dateTime.year}";
  }

  String convertTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    // in 12 hour format
    String hour = dateTime.hour > 12
        ? (dateTime.hour - 12).toString()
        : dateTime.hour.toString();
    String minute = dateTime.minute < 10
        ? "0${dateTime.minute}"
        : dateTime.minute.toString();
    String amPm = dateTime.hour > 12 ? "pm" : "am";
    return "$hour:$minute $amPm";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: WidthManager.w20,
        vertical: PaddingManager.paddingMedium,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WidthManager.w10),
        border: Border.all(
          color: gray300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                convertDate(slots.slotDateTime ?? ""),
                style: TextStyle(
                  fontSize: FontSizeManager.f18,
                  fontWeight: FontWeightManager.semiBold,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: gray800,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                convertTime(slots.slotDateTime ?? ""),
                style: TextStyle(
                  fontSize: FontSizeManager.f14,
                  fontWeight: FontWeightManager.regular,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: gray400,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (slots.isBooked ?? false)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(WidthManager.w10),
                color: blue700,
              ),
              child: Text(
                "Booked",
                style: TextStyle(
                  fontSize: FontSizeManager.f14,
                  fontWeight: FontWeightManager.regular,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: gray50,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else ...[
            CustomIconButton(
              color: gray400,
              size: 22,
              icon: Icons.edit,
              onTap: onEditTap,
            ),
            const SizedBox(
              width: 10,
            ),
            CustomIconButton(
              color: red600,
              size: 22,
              icon: Icons.delete,
              onTap: () {
                final SlotsBloc slotsBloc = BlocProvider.of<SlotsBloc>(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return DeleteDialog(
                      slotId: slots.slotId!,
                      onDeleteTap: () {
                        slotsBloc.add(DeleteSlot(slotId: slots.slotId ?? ''));
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ]
        ],
      ),
    );
  }
}
