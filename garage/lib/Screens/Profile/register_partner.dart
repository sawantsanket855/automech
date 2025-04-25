import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garage/Screens/HomePage/garageHomePage.dart';
import 'package:garage/firebasedataupload.dart';
import 'package:garage/model_class.dart';
import 'package:garage/Screens/MapScreen/MapScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterPartner extends StatefulWidget {
  const RegisterPartner({super.key});
  @override
  State createState() => _RegisterPartnerState();
}

class _RegisterPartnerState extends State {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController =TextEditingController();
  final _contactNumber1Controller=TextEditingController();
  final _contactNumber2Controller=TextEditingController();


  List<File> _images = [];
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> _updateMapLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        setState(() {
          _selectedLocation = LatLng(loc.latitude, loc.longitude);
        });
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedLocation!, 15),
        );
      }
    } catch (e) {
      print("Geocoding failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Register as Partner"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding:const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration:const InputDecoration(
                        labelText: "Garage Name",
                      ),
                      validator: (val) => val!.isEmpty ? "Enter name" : null,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration:const InputDecoration(labelText: "Address"),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _updateMapLocation(value);
                        }
                      },
                      validator: (val) => val!.isEmpty ? "Enter address" : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration:const InputDecoration(
                        labelText: "EmailId",
                      ),
                      validator: (val) => val!.isEmpty ? "Enter email" : null,
                    ),
                    TextFormField(
                      controller: _contactNumber1Controller,
                      decoration:const InputDecoration(
                        labelText: "Contact Number 1",
                      ),
                      validator: (val) => val!.isEmpty ? "Enter contact1" : null,
                    ),
                    TextFormField(
                      controller: _contactNumber2Controller,
                      decoration:const InputDecoration(
                        labelText: "Contact number 2",
                      ),
                      validator: (val) => val!.isEmpty ? "Enter contact2" : null,
                    ),
                   const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      label:const Text("Upload Images"),
                      icon:const Icon(Icons.image),
                    ),
                    Wrap(
                      spacing: 8,
                      children: _images
                          .map((img) => Image.file(img, height: 80))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition:const CameraPosition(
                          target: LatLng(20.5937, 78.9629),
                          zoom: 5,
                        ),
                        markers: _selectedLocation != null
                            ? {
                                Marker(
                                  markerId:const  MarkerId("garageLocation"),
                                  position: _selectedLocation!,
                                ),
                              }
                            : {},
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _selectedLocation != null) {
                          Provider.of<GarageProvider>(context, listen: false)
                              .addGarageMarkers(
                            _nameController.text.trim(),
                            _selectedLocation!,
                          );
                          
                          Map<String,dynamic> garageData={'name':_nameController.text,'email':_emailController.text,'contact1':_contactNumber1Controller.text,'contact2':_contactNumber2Controller.text,'address':_addressController.text};
                          registerGarage(context,garageData,_images);
                    
                        }
                      },
                      child:const Text("Save Garage"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
