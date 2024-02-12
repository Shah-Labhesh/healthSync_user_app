import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
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
        preferredSize: const Size.fromHeight(73.0),
        child: AppBarCustomWithSceenTitle(
          title: title,
          isBackButton: true,
        ),
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: BASE_URL + imageUrl,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
