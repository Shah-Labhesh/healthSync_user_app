import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/prescription.dart';

class PdfInvoiceApi {
  static Future<File> generate(Prescription prescription) async {
    final pdf = Document();

    final image = (await rootBundle.load(APP_LOGO)).buffer.asUint8List();
    pdf.addPage(
      MultiPage(
        header: (context) {
          return buildHeader(prescription, image);
        },
        orientation: PageOrientation.portrait,
        build: (context) => [
          Divider(
            thickness: 1,
            color: PdfColors.grey,
          ),
          buildTitle(prescription),
          Divider(thickness: 1, color: PdfColors.blueGrey200),
          buildContent(prescription),
        ],
        footer: (context) => buildFooter(),
      ),
    );

    try {
      return PdfApi.saveDocument(name: '${prescription.id}.pdf', pdf: pdf);
    } on Exception catch (e) {
      return Future.error('Error generating pdf $e');
    }
  }

  static buildFooter() {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 1 * PdfPageFormat.cm),
        child: Column(children: [
          Divider(
            thickness: 3,
            color: PdfColors.blue600,
          ),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Text(
            'Thank you for choosing HealthSync. We hope to see you again soon.',
            style: const TextStyle(color: PdfColors.red700),
          ),
          Container(
            margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
            padding: const pw.EdgeInsets.only(top: 0.7 * PdfPageFormat.cm),
            color: PdfColors.blue900,
          )
        ]));
  }
}

buildTitle(Prescription prescription) {
  final user = prescription.user;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pw.SizedBox(height: 0.2 * PdfPageFormat.cm),
      pw.Text(
        'Prescription Details',
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.SizedBox(height: 0.2 * PdfPageFormat.cm),
      pw.Text(
        'Patient: ${user!.name}',
        style: const pw.TextStyle(
          fontSize: 18,
        ),
      ),
      pw.SizedBox(height: 0.1 * PdfPageFormat.cm),
      pw.Text(
        'email: ${user.email}',
        style: const pw.TextStyle(
          fontSize: 18,
        ),
      ),
      pw.SizedBox(height: 0.1 * PdfPageFormat.cm),
      pw.Text(
        'Prescription Date: ${prescription.createdAt!.splitDate()}',
        style: const pw.TextStyle(
          fontSize: 18,
        ),
      ),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
    ],
  );
}

pw.Widget buildContent(Prescription prescription) {
  return pw.Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    margin: const EdgeInsets.all(8.0),
    child: Text(
      prescription.prescriptionText!,
      style: TextStyle(
        font: Font.helvetica(),
        fontSize: 22,
        color: PdfColors.grey800,
      ),
    ),
  );
}

pw.Widget buildHeader(Prescription prescription, Uint8List image) {
  return pw.Container(
    decoration: const pw.BoxDecoration(
      color: PdfColors.white,
    ),
    child: pw.Column(
      children: [
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 1 * PdfPageFormat.cm),
          padding: const pw.EdgeInsets.only(top: 1 * PdfPageFormat.cm),
          color: PdfColors.blue900,
        ),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Image(MemoryImage(image), height: 3 * PdfPageFormat.cm),
            pw.SizedBox(width: 0.6 * PdfPageFormat.cm),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  'HealthSync',
                  style: const pw.TextStyle(
                    color: PdfColors.blue,
                    fontSize: 18,
                  ),
                ),
                pw.SizedBox(width: 0.2 * PdfPageFormat.cm),
                pw.RichText(
                  text: pw.TextSpan(
                    text: 'Dr. ${prescription.doctor!.name} ',
                    style: pw.TextStyle(
                      color: PdfColors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      pw.TextSpan(
                        text: '- ${prescription.doctor!.speciality}',
                        style: pw.TextStyle(
                          color: PdfColors.blue,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 0.2 * PdfPageFormat.cm),
                pw.Text(
                  prescription.doctor!.email ?? '',
                  style: const pw.TextStyle(
                    color: PdfColors.blue,
                    fontSize: 15,
                  ),
                ),
                pw.SizedBox(width: 0.1 * PdfPageFormat.cm),
                pw.Text(
                  prescription.doctor!.address ?? '',
                  style: const pw.TextStyle(
                    color: PdfColors.blue,
                    fontSize: 15,
                  ),
                ),
                pw.SizedBox(height: 0.4 * PdfPageFormat.cm),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      // Permission denied. Handle this case, e.g., show a message to the user.
      var status = await Permission.storage.request();

      if (status.isGranted) {
        // Permission has already been granted.
        // You can save and open files.
        final bytes = await pdf.save();
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$name');
        await file.writeAsBytes(bytes);
        return file;
      } else {
        // You can use the `openAppSettings` method of the `PermissionHandler` plugin
        // to take the user to the app settings if they denied the permission
        openAppSettings();
        return File('');
      }
    }
  }

  Future<String> getApplicationDocumentsDirectoryPath() async {
    // Get the application documents directory using path_provider
    final directory = await getApplicationDocumentsDirectory();

    // Access the path property to get the directory path as a string
    final directoryPath = directory.path;

    return directoryPath;
  }
}
