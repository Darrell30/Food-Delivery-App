import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'OrderScreen.dart';
import '../user_data.dart';

class MapData {
  final Position position;
  final Set<Marker> markers;
  MapData(this.position, this.markers);
}

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({super.key});

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  late Future<MapData> _mapDataFuture;
  static const String apiKey = "AIzaSyCVNllzvx7sVo7O6DHJxElh_vhAPDwcifQ";

  @override
  void initState() {
    super.initState();
    _mapDataFuture = _prepareMapData();
  }

  Future<MapData> _prepareMapData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    final customMarkerIcon = await _getBitmapDescriptorFromIconData(
      Icons.food_bank,
      const Color.fromRGBO(39, 0, 197, 1),
      120.0, // Icon size
    );

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final userLocation = LatLng(position.latitude, position.longitude);

    final markers = await _fetchNearbyRestaurants(userLocation, customMarkerIcon);

    return MapData(position, markers);
  }

  Future<Set<Marker>> _fetchNearbyRestaurants(
      LatLng location, BitmapDescriptor icon) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location.latitude},${location.longitude}&radius=1500&type=restaurant&key=$apiKey";
    final Set<Marker> newMarkers = {};

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          final List results = data["results"];
          for (var place in results) {
            final loc = place["geometry"]["location"];
            newMarkers.add(
              Marker(
                markerId: MarkerId(place["place_id"]),
                position: LatLng(loc["lat"], loc["lng"]),
                icon: icon,
                infoWindow: InfoWindow(
                  title: place["name"],
                  snippet: place["vicinity"],
                  onTap: () {
                    final userData = Provider.of<UserData>(context, listen: false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderScreen(
                          placeName: place["name"],
                          onOrderCreated: (newOrder) {
                            userData.addNewOrder(newOrder);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching places: $e");
    }
    return newMarkers;
  }

  Future<BitmapDescriptor> _getBitmapDescriptorFromIconData(
      IconData iconData, Color color, double size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
    final image = await pictureRecorder.endRecording().toImage(
          textPainter.width.toInt(),
          textPainter.height.toInt(),
        );
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Restaurants"),
      ),

      body: FutureBuilder<MapData>(
        future: _mapDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final mapData = snapshot.data!;
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(mapData.position.latitude, mapData.position.longitude),
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: mapData.markers,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}