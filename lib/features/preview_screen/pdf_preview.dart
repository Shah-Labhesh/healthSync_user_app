// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class PDFPreviewScreen extends StatefulWidget {
  final String pdfPath;
  final bool isFromNetwork;

  const PDFPreviewScreen(
      {super.key, required this.pdfPath, this.isFromNetwork = false});

  @override
  _PDFPreviewScreenState createState() => _PDFPreviewScreenState();
}

class _PDFPreviewScreenState extends State<PDFPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'PDF Preview',
          isBackButton: true,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.isFromNetwork
                ? PDF(
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    onError: (error) {},
                    onPageError: (page, error) {},
                    onPageChanged: (page, total) {},
                  ).fromUrl(BASE_URL + widget.pdfPath)
                : PDF(
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    onError: (error) {},
                    onPageError: (page, error) {},
                    onPageChanged: (page, total) {},
                  ).fromPath(widget.pdfPath),
          ),
        ],
      ),
    );
  }
}
