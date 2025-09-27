import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-6.2088, 106.8456), // Jakarta
    zoom: 14.0,
  );

  late GoogleMapController _mapController;
  LatLng? _pickedLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        _pickedLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_pickedLocation!, 16.0),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint("Error getting location: $e");
    }
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
      } else {
        return "No address found for this location.";
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
      return "Could not get address";
    }
  }

  //simpen alamat
  Future<void> _saveAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_address', address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              _mapController = controller;
              _getCurrentLocation();
            },
            onCameraMove: (position) {
              if (!mounted) return;
              setState(() {
                _pickedLocation = position.target;
              });
            },
          ),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            const Icon(Icons.location_pin, color: Colors.red, size: 50),
          Positioned(
            bottom: 30,
            child: ElevatedButton(
              onPressed: _pickedLocation == null
                  ? null
                  : () async {
                      final address =
                          await _getAddressFromLatLng(_pickedLocation!);

                      // ✅ Simpan ke SharedPreferences
                      await _saveAddress(address);

                      if (mounted) {
                        Navigator.of(context).pop(address);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(39, 0, 197, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Confirm This Address',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
