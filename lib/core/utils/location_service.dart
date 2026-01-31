import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

enum LocationStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

class LocationData {
  final String city;
  final String address;
  final String pincode;
  final double latitude;
  final double longitude;

  LocationData({
    required this.city,
    required this.address,
    required this.pincode,
    required this.latitude,
    required this.longitude,
  });
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  LocationData? _cachedLocation;
  LocationData? get cachedLocation => _cachedLocation;

  Future<LocationStatus> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationStatus.serviceDisabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationStatus.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationStatus.deniedForever;
    }

    return LocationStatus.granted;
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      final status = await checkAndRequestPermission();
      if (status != LocationStatus.granted) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _cachedLocation = LocationData(
          city: place.locality ?? place.subAdministrativeArea ?? 'Unknown',
          address: _buildAddress(place),
          pincode: place.postalCode ?? '',
          latitude: position.latitude,
          longitude: position.longitude,
        );
        return _cachedLocation;
      }
    } catch (e) {
      return _cachedLocation;
    }
    return null;
  }

  String _buildAddress(Placemark place) {
    final parts = <String>[];
    if (place.subLocality?.isNotEmpty == true) parts.add(place.subLocality!);
    if (place.thoroughfare?.isNotEmpty == true) parts.add(place.thoroughfare!);
    if (parts.isEmpty && place.name?.isNotEmpty == true) parts.add(place.name!);
    return parts.isNotEmpty ? parts.join(', ') : 'Current Location';
  }
}
