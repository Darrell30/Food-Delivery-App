import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'restaurant_menu_page.dart';

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({super.key});

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  GoogleMapController? _mapController;
  Position? _currentLocation;
  bool _isLoading = true;
  Set<Marker> _markers = {};
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  // GANTI DENGAN API KEY GOOGLE MAPS ANDA YANG VALID
  static const String apiKey = "GANTI_DENGAN_API_KEY_ANDA";

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _getCurrentLocation();
  }

  Future<void> _fetchNearbyRestaurants() async {
    if (_currentLocation == null) return;
    
    final url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation!.latitude},${_currentLocation!.longitude}&radius=1500&type=restaurant&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (!mounted) return;
      final data = json.decode(response.body);

      if (data["status"] == "OK") {
        final List results = data["results"];
        final Set<Marker> newMarkers = results.map((place) {
          final loc = place["geometry"]["location"];
          return Marker(
            markerId: MarkerId(place["place_id"]),
            position: LatLng(loc["lat"], loc["lng"]),
            icon: _markerIcon,
            infoWindow: InfoWindow(
              title: place["name"],
              snippet: place["vicinity"],
              // --- INI PERUBAHAN UTAMANYA ---
              onTap: () {
                // Logika baru: Arahkan ke halaman menu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantMenuPage(
                      placeName: place["name"] ?? 'Unknown Restaurant',
                    ),
                  ),
                );
              },
            ),
          );
        }).toSet();

        setState(() {
          _markers = newMarkers;
        });
      }
    } catch (e) {
      debugPrint("Error fetching places: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Up"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(-6.1751, 106.8650), zoom: 15),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  // --- Fungsi Helper (tidak perlu diubah) ---
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location permission denied")));
        return;
      }
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (!mounted) return;
      setState(() {
        _currentLocation = position;
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 15));
      });
      await _fetchNearbyRestaurants();
    } catch (e) {
      debugPrint("Error getting location: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCustomMarker() async {
    final icon = await _getBitmapDescriptorFromIconData(Icons.food_bank, const Color.fromRGBO(39, 0, 197, 1), 120.0);
    if (mounted) setState(() => _markerIcon = icon);
  }

  Future<BitmapDescriptor> _getBitmapDescriptorFromIconData(IconData iconData, Color color, double size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(fontSize: size, color: color, fontFamily: iconData.fontFamily, package: iconData.fontPackage),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
    final image = await pictureRecorder.endRecording().toImage(textPainter.width.toInt(), textPainter.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }
}