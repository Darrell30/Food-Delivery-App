import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({super.key});

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // cek apakah service lokasi aktif
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    // cek permission
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // dapatkan lokasi sekarang
    final locationData = await _location.getLocation();
    setState(() {
      _currentLocation = locationData;
    });

    // pindahkan kamera ke lokasi sekarang
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Up"),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                zoom: 15,
              ),
              myLocationEnabled: true,          // icon titik biru
              myLocationButtonEnabled: true,    // tombol ke lokasi saya
              zoomControlsEnabled: false,       // hapus tombol zoom
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
    );
  }
}
