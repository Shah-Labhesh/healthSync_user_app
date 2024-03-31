// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class ChatRoomTileWidget extends StatelessWidget {
  const ChatRoomTileWidget({
    Key? key,
    required this.image,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.isImage = false,
    this.onTap,
  }) : super(key: key);

  final bool isImage;
  final String? image;
  final String name;
  final String lastMessage;
  final String time;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            if (image != null) 
           Utils.ImageWidget(
              BASE_URL + image!,
              height: HeightManager.h65,
              width: WidthManager.w65,
             )
            else
            Container(
              height: HeightManager.h65,
              width: WidthManager.w65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppImages.defaultAvatar),
                ),
              ),
            ),
            const SizedBox(
              width: PaddingManager.paddingMedium,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: FontSizeManager.f20,
                      fontWeight: FontWeightManager.semiBold,
                      color: gray900,
                      letterSpacing: 0.5,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isImage)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const ImageIcon(
                          AssetImage(galleryIcon),
                          color: Color(0xff6B779A),
                          size: 18,
                        ),
                        const SizedBox(
                          width: PaddingManager.paddingSmall,
                        ),
                        Text(
                          'Image sent',
                          style: TextStyle(
                            fontSize: FontSizeManager.f16,
                            fontWeight: FontWeightManager.regular,
                            color: const Color(0xff6B779A),
                            letterSpacing: 0.5,
                            fontStyle: FontStyle.italic,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  else
                    Text(
                      lastMessage,
                      style: TextStyle(
                        fontSize: FontSizeManager.f16,
                        fontWeight: FontWeightManager.regular,
                        color: const Color(0xff6B779A),
                        letterSpacing: 0.5,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              time,
              style: TextStyle(
                fontSize: FontSizeManager.f14,
                fontWeight: FontWeightManager.light,
                color: const Color(0xff6B779A),
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
