// screens/pickup_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'OrderScreen.dart'; 
import '../orders/order_models.dart'; 
import '../orders/orders_page.dart'; 
// Import untuk kustomisasi marker dari widget
import 'package:flutter/services.dart'; 
import 'dart:ui' as ui; // Digunakan untuk Canvas/PictureRecorder

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({super.key});

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  GoogleMapController? _mapController;
  Position? _currentLocation;
  bool _isLoading = true;

  static const String apiKey = "AIzaSyCVNllzvx7sVo7O6DHJxElh_vhAPDwcifQ"; 

  Set<Marker> _markers = {};
  
  // --- Deklarasi Custom Icon ---
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-6.1751, 106.8650), // Jakarta
    zoom: 15,
  );

  // --- Fungsi untuk mengkonversi IconData menjadi BitmapDescriptor ---
  Future<BitmapDescriptor> _getBitmapDescriptorFromIconData(IconData iconData, Color color, double size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final TextSpan textSpan = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage, 
      ),
    );

    textPainter.text = textSpan;
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final image = await pictureRecorder.endRecording().toImage(
      textPainter.width.toInt(),
      textPainter.height.toInt(),
    );
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  @override
  void initState() {
    super.initState();
    _loadFoodBankMarker(); // Panggil fungsi baru untuk memuat ikon
    _getCurrentLocation();
  }
  
  // --- Fungsi Baru: Memuat Marker Food Bank ---
  Future<void> _loadFoodBankMarker() async {
    final icon = await _getBitmapDescriptorFromIconData(
      Icons.food_bank, 
      Color.fromRGBO(39, 0, 197, 1), 
      100.0 // Ukuran ikon
    );
    setState(() {
      _markerIcon = icon;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          setState(() => _isLoading = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = position;
        _isLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15,
        ),
      );

      _fetchNearbyRestaurants();
    } catch (e) {
      debugPrint("Error getting location: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchNearbyRestaurants() async {
    if (_currentLocation == null) return;
    
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${_currentLocation!.latitude},${_currentLocation!.longitude}"
        "&radius=1500"
        "&type=restaurant" 
        "&key=$apiKey";
        
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data["status"] == "OK") {
        final List results = data["results"];
        final Set<Marker> newMarkers = results.map((place) {
          final loc = place["geometry"]["location"];
          return Marker(
            markerId: MarkerId(place["place_id"]),
            position: LatLng(loc["lat"], loc["lng"]),
            icon: _markerIcon, // Menggunakan ikon Food Bank
            infoWindow: InfoWindow(
              title: place["name"],
              snippet: place["vicinity"],
              onTap: () async {
                // ... (Logika navigasi ke OrderScreen)
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderScreen(
                      placeName: place["name"],
                      onOrderCreated: (newOrder) {
                        final ordersPageState = context.findAncestorStateOfType<OrdersPageState>();
                        if (ordersPageState != null) {
                           ordersPageState.addNewOrder(newOrder); 
                        } else {
                          debugPrint("Error: Could not find OrdersPageState.");
                        }
                      },
                      initialOrder: null, 
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
      } else {
        debugPrint("Places API Error: ${data["status"]}");
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
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
          ),

          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}