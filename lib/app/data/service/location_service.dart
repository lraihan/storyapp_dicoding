import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
class LocationService extends GetxService {
  Future<bool> isLocationAvailable() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }
  Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationServiceDialog();
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedSnackbar();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await _showPermissionDeniedForeverDialog();
      return false;
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }
  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          Get.snackbar(
            'timeout'.tr,
            'locationTimeout'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          throw Exception('Location timeout');
        },
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failedToGetLocation'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }
  Future<void> _showLocationServiceDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text('locationServicesDisabled'.tr),
        content: Text('locationServicesMessage'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openLocationSettings();
            },
            child: Text('openSettings'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
  Future<void> _showPermissionDeniedForeverDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text('locationPermissionRequired'.tr),
        content: Text('locationPermissionMessage'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await perm.openAppSettings();
            },
            child: Text('openSettings'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
  void _showPermissionDeniedSnackbar() {
    Get.snackbar(
      'locationPermissionDenied'.tr,
      'locationPermissionRequired'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
      // Failed to get address from coordinates, return null
    }
    return null;
  }
  Future<List<Location>?> getCoordinatesFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      return null;
    }
  }
}
