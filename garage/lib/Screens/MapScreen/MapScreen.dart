import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mapscreen extends StatefulWidget {
  const Mapscreen({super.key});
  @override
  State createState() => _MapscreenState();
}

class _MapscreenState extends State {
  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(18.5204, 73.8567);
  Set<Marker> _markers = {};
  String apiKey = "AIzaSyAG_R1I5h3e9x57L45TQhJ4Z68iVKf_n9I";

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Location permission denied");
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _initialPosition,
          zoom: 14,
        ),
      ),
    );
    _fetchNearbyGarages();
  }

  Future<void> _fetchNearbyGarages() async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_initialPosition.latitude},${_initialPosition.longitude}&radius=5000&type=car_repair&key=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data["results"];
      Set<Marker> newMarkers = {};
      if (results.isNotEmpty) {
        for (var place in results) {
          final name = place["name"];
          final lat = place["geometry"]["location"]["lat"];
          final lng = place["geometry"]["location"]["lng"];
          newMarkers.add(Marker(
            markerId: MarkerId(name),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name),
          ));
        }
        setState(() {
          _markers = newMarkers;
        });
        _cameraupdateToGarages();
      } else {
        print("No nearby garages Founr");
      }
    } else {
      print("Error fetching nearby garages");
    }
  }

  void _cameraupdateToGarages() {
    if (_markers.isNotEmpty) {
      LatLngBounds bounds = _getBoundsFromMarkers();
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  LatLngBounds _getBoundsFromMarkers() {
    double minLat = _initialPosition.latitude;
    double minLng = _initialPosition.longitude;
    double maxLat = _initialPosition.latitude;
    double maxLng = _initialPosition.longitude;

    _markers.forEach((marker) {
      LatLng position = marker.position;
      if (position.latitude < minLat) minLat = position.latitude;
      if (position.latitude > maxLat) maxLat = position.latitude;
      if (position.longitude < minLng) minLng = position.longitude;
      if (position.longitude > maxLng) maxLng = position.longitude;
    });

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition:
                CameraPosition(target: _initialPosition, zoom: 14),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Search Maps",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: _getUserLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.build), label: "Service Booking"),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Map"),
        BottomNavigationBarItem(
            icon: Icon(Icons.inventory), label: "Inventory"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile")
      ]),
    );
  }
}
