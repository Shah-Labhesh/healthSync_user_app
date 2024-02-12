import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class PDFPreviewScreen extends StatefulWidget {
  final String pdfPath; // Path to the selected PDF file
  final bool isFromNetwork;

  PDFPreviewScreen({required this.pdfPath, this.isFromNetwork = false});

  @override
  _PDFPreviewScreenState createState() => _PDFPreviewScreenState();
}

class _PDFPreviewScreenState extends State<PDFPreviewScreen> {
  late int totalPages = 0;
  late int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(73.0),
        child: AppBarCustomWithSceenTitle(
          title: 'PDF Preview',
          isBackButton: false,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.isFromNetwork? 
            PDF(
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
              onPageChanged: (page, total) {
                if (page != null || total != null) return;
                setState(() {
                  currentPage = page!;
                  totalPages = total!;
                });
              },
              
            ).fromUrl(BASE_URL + widget.pdfPath)
            : PDF(
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
              onPageChanged: (page, total) {
                if (page != null || total != null) return;
                setState(() {
                  currentPage = page!;
                  totalPages = total!;
                });
              },
              // onPageChanged: (int page, int total) {
              //   print('page change: $page/$total');
              // },
            ).fromPath(widget.pdfPath),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: Text(
                    'Pdf: ${widget.pdfPath.split('/').last}',
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),

                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
