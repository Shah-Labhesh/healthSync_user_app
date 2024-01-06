import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePick {
  static Future<File?> pickImage({required ImageSource source}) async {
    final picker = ImagePicker();
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        return null;
      }
    }
    if (source == ImageSource.gallery) {
      final status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        return null;
      }
    }

    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}
