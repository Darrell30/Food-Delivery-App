import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Re-enabled this import

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Default to a central location if location is not available
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
    // Do NOT call _getCurrentLocation here. It will be called in onMapCreated.
  }

  // Get user's current location and move the camera
  Future<void> _getCurrentLocation() async {
    // Make sure the widget is still mounted before showing a SnackBar
    if (!mounted) return;

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.'))
        );
        setState(() => _isLoading = false);
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _pickedLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      // This is now safe to call because we know the controller is ready.
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_pickedLocation!, 16.0),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error getting location: $e");
    }
  }

  // Function to convert coordinates to a readable address
  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Construct a more readable address
        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
      }
      return "No address found for this location.";
    } catch (e) {
      return "Could not get address";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
        actions: [
          // This button still works as expected
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
            // This is the key change: trigger location fetching here
            onMapCreated: (controller) {
              _mapController = controller;
              _getCurrentLocation(); // Fetch location AFTER map is created
            },
            onCameraMove: (position) {
              setState(() {
                _pickedLocation = position.target;
              });
            },
          ),
          // Loading indicator
          if (_isLoading)
            const CircularProgressIndicator()
          else
            // The marker pin
            const Icon(Icons.location_pin, color: Colors.red, size: 50),
          // Confirm button at the bottom (re-enabled)
          Positioned(
            bottom: 30,
            child: ElevatedButton(
              onPressed: _pickedLocation == null ? null : () async {
                final address = await _getAddressFromLatLng(_pickedLocation!);
                // Return the address string to the profile page
                if (mounted) {
                  Navigator.of(context).pop(address);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Confirm This Address', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}