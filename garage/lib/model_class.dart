
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';




class InventoryItem {
  String name;
  String description;
  String category;
  double price;
  String imagePath;
  File? image;

  InventoryItem(
      {required this.name,
      required this.description,
      required this.category,
      required this.price,
      required this.imagePath,
      required this.image,
      });
}



class Garage {
  final String name;
  final LatLng location;
  final List<File> images;
  final List<String> inventoryItems;
  Garage(
      {required this.name,
      required this.location,
      required this.images,
      required this.inventoryItems});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "location": {
        "lat": location.latitude,
        "lng": location.longitude,
      },
      "inventoryItems": inventoryItems,
    };
  }

  factory Garage.fromMap(Map<String, dynamic> map) {
    return Garage(
        name: map["name"],
        location: LatLng(map["location"]["lat"], map["location"]["lng"]),
        images: [],
        inventoryItems: List<String>.from(map["inventoryItems"] ?? []));
  }
}



class FetchedGarages{
   final String name;
  final String location;
  final List images;
  final List inventoryItems;

  FetchedGarages(
      {required this.name,
      required this.location,
      required this.images,
      required this.inventoryItems});
}