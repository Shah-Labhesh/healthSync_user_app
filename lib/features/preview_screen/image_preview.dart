import 'package:flutter/material.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen(
      {super.key, this.title = 'Image Preview', required this.imageUrl});

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: title,
          isBackButton: true,
        ),
      ),
      body: Center(
        child: Utils.ImageWidget(
          BASE_URL + imageUrl,
        )
      ),
    );
  }
}
