import 'package:geolocator/geolocator.dart';

class LocationManager {
  // Method to request location permission
  Future<bool> requestLocationPermission() async {
    LocationPermission permission;

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false; // Location services are not enabled
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if not granted
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return false; // Permission denied, return false
      }
    } else if (permission == LocationPermission.deniedForever) {
      return false; // Permissions are permanently denied
    }

    return true; // If permission is granted, return true
  }

  // Method to get the current location
  Future<Map<String, double>?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }
}
