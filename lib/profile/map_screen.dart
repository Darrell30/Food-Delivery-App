import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const String googleApiKey = "YOUR_API_KEY_HERE";

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _pickedLocation;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<dynamic> _suggestions = [];
  String? _sessionToken;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _sessionToken = _uuid.v4();
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        _getAutocompleteSuggestions(_searchController.text);
      } else {
        if (mounted) setState(() => _suggestions = []);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // --- Search Logic ---

  Future<void> _getAutocompleteSuggestions(String input) async {
    if (_sessionToken == null) _sessionToken = _uuid.v4();
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && mounted) {
          setState(() => _suggestions = data['predictions']);
        }
      }
    } catch (e) {
      debugPrint("Error fetching suggestions: $e");
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && mounted) {
          final location = data['result']['geometry']['location'];
          final lat = location['lat'];
          final lng = location['lng'];

          _mapController.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16.0),
          );

          setState(() {
            _suggestions = [];
            _searchController.clear();
            _searchFocusNode.unfocus();
          });
          _sessionToken = null;
        }
      }
    } catch (e) {
      debugPrint("Error fetching place details: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')),
          );
          setState(() => _isLoading = false);
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _pickedLocation = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(_pickedLocation!, 16.0),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint("Error getting location: $e");
    }
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];
        final addressParts = <String>[];

        final plusCodeRegex = RegExp(r'^[A-Z0-9]{4}\+[A-Z0-9]{2,3}$');
        if (place.street != null && !plusCodeRegex.hasMatch(place.street!)) {
          addressParts.add(place.street!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          addressParts.add(place.postalCode!);
        }

        return addressParts.join(', ');
      } else {
        return "No address found for this location.";
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
      return "Could not get address";
    }
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
            initialCameraPosition: const CameraPosition(
              target: LatLng(-6.2088, 106.8456),
              zoom: 14.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _getCurrentLocation();
            },
            onCameraMove: (position) {
              if (_searchFocusNode.hasFocus) return;
              if (mounted) {
                setState(() => _pickedLocation = position.target);
              }
            },
          ),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            if (_suggestions.isEmpty)
              const Icon(Icons.location_pin, color: Colors.red, size: 50),
          Positioned(
            bottom: 30,
            child: ElevatedButton(
              onPressed: _pickedLocation == null
                  ? null
                  : () async {
                      final address = await _getAddressFromLatLng(_pickedLocation!);
                      if (mounted) {
                        Navigator.of(context).pop(address);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 119, 255),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Confirm Location',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search for a location...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _suggestions = [];
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            title: Text(suggestion['description']),
                            onTap: () => _getPlaceDetails(suggestion['place_id']),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
