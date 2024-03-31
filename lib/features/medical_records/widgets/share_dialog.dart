import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    super.key,
    required this.doctors,
  });

  final List<User> doctors;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: ShapeBorder.lerp(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          0.5),
      title: Center(
        child: Text('Select Doctor',
            style: TextStyle(
              color: gray800,
              fontWeight: FontWeightManager.semiBold,
              fontSize: FontSizeManager.f18,
              fontFamily: GoogleFonts.lato().fontFamily,
            )),
      ),
      children: [
        for (User doctor in doctors)
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: doctor.avatar != null
                  ? Utils.ImageWidget(
                      BASE_URL + doctor.avatar!,
                      height: HeightManager.h40,
                      width: WidthManager.w40,
                    )
                  : Image.asset(
                      AppImages.defaultAvatar,
                      width: WidthManager.w40,
                      height: HeightManager.h40,
                      fit: BoxFit.cover,
                    ),
            ),
            title: Text(
              doctor.name!,
              style: TextStyle(
                color: gray800,
                fontWeight: FontWeightManager.semiBold,
                fontSize: FontSizeManager.f18,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
            ),
            subtitle: Text(
              doctor.speciality ?? '-',
              style: TextStyle(
                color: gray400,
                fontWeight: FontWeightManager.medium,
                fontSize: FontSizeManager.f14,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            onTap: () {
              Navigator.pop(context, doctor);
            },
          ),
      ],
    );
  }
}
