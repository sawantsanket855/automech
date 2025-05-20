import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:garage/Providers/garage_provider.dart';
import 'package:garage/provider_class.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:provider/provider.dart';

class Mapscreen extends StatefulWidget {
  const Mapscreen({super.key});
  @override
  State createState() => _MapscreenState();
}

class _MapscreenState extends State {
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Marker? _searchedMarker;
  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(18.5204, 73.8567);
  Set<Marker> _markers = {};
  String apiKey = "AIzaSyAhHAw59TVD60IlUcOUqtEXBmAz1yWyk6M";
  StreamSubscription<Position>? _positionStream;
  FlutterTts flutterTts = FlutterTts();
  List<dynamic> _routeSteps = [];
  int _currentStepIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _estimatedTime = '';

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      LatLng current = LatLng(position.latitude, position.longitude);

      setState(() {
        _initialPosition = current;
      });
      _mapController.animateCamera(
        CameraUpdate.newLatLng(current),
      );

      _checkForNextStep(current);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _positionStream?.cancel();
    super.dispose();
  }

  void _checkForNextStep(LatLng current) {
    if (_currentStepIndex < _routeSteps.length) {
      final step = _routeSteps[_currentStepIndex];
      final LatLng stepLocation = LatLng(
        step["end_location"]["lat"],
        step["end_location"]["lng"],
      );

      double distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        stepLocation.latitude,
        stepLocation.longitude,
      );

      if (distance < 30) {
        // threshold in meters
        _speak(step["html_instructions"].replaceAll(RegExp(r'<[^>]*>'), ''));
        _currentStepIndex++;
      }
    }
  }

  Future<void> _speak(String instruction) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(instruction);
  }

  Future<void> _drawRouteToMarker(LatLng destination) async {
    try {
      // Get current user location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng origin = LatLng(position.latitude, position.longitude);

      // Build the directions API URL
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey&mode=driving&alternatives=false&units=metric&steps=true';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final encodedPoints =
              data["routes"][0]["overview_polyline"]["points"];
          List steps = data["routes"][0]["legs"][0]["steps"];
          String durationText =
              data["routes"][0]["legs"][0]["duration"]["text"];

          // ✅ Print instructions for debugging
          for (var step in steps) {
            String htmlInstruction = step["html_instructions"];
            String distance = step["distance"]["text"];
            String duration = step["duration"]["text"];
            print(
                "Step: $htmlInstruction | Distance: $distance | Duration: $duration");
          }

          // ✅ Save steps to state
          setState(() {
            _routeSteps = steps;
            _currentStepIndex = 0;
            _estimatedTime = durationText;
          });

          List<PointLatLng> result =
              PolylinePoints().decodePolyline(encodedPoints);

          if (result.isNotEmpty) {
            List<LatLng> polylineCoordinates = result
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();

            setState(() {
              _polylineCoordinates = polylineCoordinates;
              _polylines = {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: _polylineCoordinates,
                  color: Colors.red,
                  width: 5,
                ),
              };
            });

            // Animate camera to show both origin and destination
            LatLngBounds bounds = LatLngBounds(
              southwest: LatLng(
                origin.latitude < destination.latitude
                    ? origin.latitude
                    : destination.latitude,
                origin.longitude < destination.longitude
                    ? origin.longitude
                    : destination.longitude,
              ),
              northeast: LatLng(
                origin.latitude > destination.latitude
                    ? origin.latitude
                    : destination.latitude,
                origin.longitude > destination.longitude
                    ? origin.longitude
                    : destination.longitude,
              ),
            );

            _mapController.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 80),
            );
          }
        } else {
          print("No routes found");
        }
      } else {
        print("Directions API error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error drawing route: $e");
    }
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
          final placeId = place["place_id"];
          newMarkers.add(Marker(
            markerId: MarkerId(name),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: name,
              onTap: () {
                _fetchGarageDetails(placeId, lat, lng);
              },
            ),
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

  Future<void> _fetchGarageDetails(
      String placeId, double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,formatted_address,formatted_phone_number,opening_hours&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data["result"];

      String name = result["name"] ?? "No name";
      String address = result["formatted_address"] ?? "No address";
      String phone = result["formatted_phone_number"] ?? "No phone";
      List? hours = result["opening_hours"]?["weekday_text"];

      _showGarageDetails(name, address, phone, hours, LatLng(lat, lng));
    } else {
      print("Failed to fetch place details");
    }
  }

  void _showGarageDetails(String name, String address, String phone,
      List? openHours, LatLng destination) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(address, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Phone: $phone", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            if (openHours != null) ...[
              Text("Opening Hours:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...openHours.map((line) => Text(line)).toList(),
            ],
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _drawRouteToMarker(destination);
              },
              icon: Icon(Icons.directions),
              label: Text("Get Directions"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchLocation(String query) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(query)}&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        final latLng = LatLng(location['lat'], location['lng']);

        if (_searchedMarker != null) {
          _markers.remove(_searchedMarker);
        }

        _searchedMarker = Marker(
          markerId: MarkerId("search_marker"),
          position: latLng,
          infoWindow: InfoWindow(title: query),
        );

        setState(() {
          _markers.add(_searchedMarker!);
        });

        _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
      } else {
        print("No results found");
      }
    } else {
      print("Failed to fetch location");
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
    final garageMarker =
        Provider.of<GarageProvider>(context).garageMarkers.toSet();

    Set<Marker> combinedMarkers = {..._markers, ...garageMarker};
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 15,
            right: 15,
            child: _estimatedTime.isNotEmpty
                ? Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5)
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time, color: Colors.black87),
                        SizedBox(width: 8),
                        Text(
                          "Estimated Time: $_estimatedTime",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ),
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition:
                CameraPosition(target: _initialPosition, zoom: 14),
            markers: combinedMarkers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                _searchLocation(value);
              },
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
    );
  }
}
