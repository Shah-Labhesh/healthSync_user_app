import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationUtils {
  Future<LatLng?> getCurrentLocation() async {
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      LocationPermission permission1 = await Geolocator.requestPermission();
      if (permission1 == LocationPermission.whileInUse ||
          permission1 == LocationPermission.always) {
        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        return LatLng(position.latitude, position.longitude);
      }
      return null;
    }
    return null;
  }
}
