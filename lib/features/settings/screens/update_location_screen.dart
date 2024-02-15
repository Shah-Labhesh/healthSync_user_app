// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_mobile_app/.env.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';
import 'package:user_mobile_app/widgets/field_with_suggestions.dart';

class UpdateLocationScreen extends StatefulWidget {
  const UpdateLocationScreen({super.key});

  @override
  State<UpdateLocationScreen> createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends State<UpdateLocationScreen> {
  final Set<Marker> _markers = {};
  final TextEditingController searchController = TextEditingController();
  List<String> placeList = [];
  LatLng? newLatlng;
  LatLng? selectedLatlng;

  fetchPlaceByText(String text) async {
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String url =
        '$baseUrl?input=$text&key=${AppEnvironment.mapApiKey}&radius=500';
    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        placeList.clear();
        final list = response.data['predictions'];
        for (var i = 0; i < list.length; i++) {
          placeList.add(list[i]['description']);
        }
        return placeList;
      }
    } catch (e) {
      return [];
    }
  }

  animateMap(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(lat, lng),
        zoom: 14.4746,
      ),
    ));
  }

  fetchCoordinates(String text) async {
    try {
      List<Location> locations = await locationFromAddress(text);
      animateMap(locations[0].latitude, locations[0].longitude);
      newLatlng = LatLng(locations[0].latitude, locations[0].longitude);
      _markers.clear();
    } on Exception catch (e) {
      print(e.toString());
      Utils.showSnackBar(context, 'Location not found', isSuccess: false);
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.4831, 87.28337),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  dispose() {
    super.dispose();
    searchController.dispose();
  }

  getCurrentLocation() async {
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      LocationPermission permission1 = await Geolocator.requestPermission();
      if (permission1 == LocationPermission.whileInUse ||
          permission1 == LocationPermission.always) {
        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        animateMap(position.latitude, position.longitude);
        newLatlng = LatLng(position.latitude, position.longitude);
        _markers.clear();
      } else {
        Utils.showSnackBar(context, 'Please allow location permission',
            isSuccess: false);
      }
    } else {
      Utils.showSnackBar(context, 'Please allow location permission',
          isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, selectedLatlng);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(HeightManager.h73),
          child: AppBarCustomWithSceenTitle(title: 'Update Location'),
        ),
        body: Stack(
          children: [
            GoogleMap(
              markers: _markers,
              onTap: (argument) {
                setState(() {
                  _markers.clear();
                  _markers.add(
                    Marker(
                      markerId: MarkerId(argument.toString()),
                      position: argument,
                      infoWindow: const InfoWindow(
                        title: 'Your Location',
                      ),
                    ),
                  );
                  selectedLatlng = argument;
                });
              },
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(
                  top: PaddingManager.paddingMedium2,
                  left: PaddingManager.paddingMedium2,
                  right: PaddingManager.paddingMedium2,
                ),
                child: SuggestionField(
                  title: 'Search Location',
                  onSuggestionSelected: (text) {
                    setState(() {
                      searchController.text = text.toString();
                    });
                    fetchCoordinates(text.toString());
                  },
                  suggestionsCallback: (change) async {
                    return await fetchPlaceByText(change);
                  },
                  itemBuilder: (context, itemData) {
                    return ListTile(
                      title: Text(itemData.toString()),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: PaddingManager.paddingMedium2,
                  horizontal: PaddingManager.paddingMedium2,
                ),
                child: CustomButtom(
                  title: 'Update',
                  onPressed: () async {
                    if (selectedLatlng == null) {
                      Utils.showSnackBar(context, 'Please select a location',
                          isSuccess: false);
                      return;
                    }
                    if (Utils.checkInternetConnection(context) == false) return;
                    if (selectedLatlng != null) {
                      Navigator.pop(context, {
                        'latitude': selectedLatlng!.latitude,
                        'longitude': selectedLatlng!.longitude,
                      });
                    } else {
                      Utils.showSnackBar(context, 'Please select a location',
                          isSuccess: false);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
