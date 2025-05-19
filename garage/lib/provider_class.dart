
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:garage/firebasedataupload.dart';
import 'package:garage/model_class.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';



class LoginData extends ChangeNotifier {
  String loginType = 'user';
  String verificationId = '';
  String completeNumber = '+9665709490';
  String name = '';
  String email = '';
  String dOB = '';
  String gender = '';

  void setLoginType(String newType) {
    loginType = newType;
    notifyListeners();
  }

  void setNumber(String newNumber) {
    completeNumber = newNumber;
    notifyListeners();
  }

  void setVerificationId(String newID) {
    verificationId = newID;
    notifyListeners();
  }

  void setData(
      {String? newName, String? newEmail, String? newDOB, String? newGender}) {
    name = newName ?? name;
    email = newEmail ?? email;
    dOB = newDOB ?? dOB;
    gender = newGender ?? gender;
    notifyListeners();
  }
}



class CarInfo extends ChangeNotifier {
  String carCompany = '';
  String carFuelType = '';
  String carModel = '';

  void setCarCompany(String newCarCompany) {
    carCompany = newCarCompany;
    ChangeNotifier();
  }

  void setCarModel(String newCarModel) {
    carModel = newCarModel;
    ChangeNotifier();
  }

  void setCarFuel(String newCarFuel) {
    carFuelType = newCarFuel;
    ChangeNotifier();
  }
}

class Loader extends ChangeNotifier {
  bool isGetOtpLoaderOn=false;
  Widget getOtpLoader = Text(
    "GET OTP",
    style: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  );
  void changeGetOtpLoader(String value) {
    if (value == 'on') {
      getOtpLoader = SizedBox(
          height: 30, width: 30, child: Image.asset('assets/loading.gif'));
        isGetOtpLoaderOn=true;
        log('loader on');
        ChangeNotifier();
    } else {
      getOtpLoader = Text(
        "GET OTP",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      );
      isGetOtpLoaderOn=false;
    }
    ChangeNotifier();
  }

  bool submitOtpLoader = false;
  void changeSubmitOtpLoader(value) {
    isGetOtpLoaderOn = value;
    ChangeNotifier();
  }
}

class GarageProvider extends ChangeNotifier {
   List<Marker> _garageMarkers = [];


  List<Marker> get garageMarkers => _garageMarkers;

  void addGarageMarkers(String name, LatLng location) {
    final marker = Marker(
      markerId: MarkerId(name),
      position: location,
      infoWindow: InfoWindow(title: name),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    _garageMarkers.add(marker);
    notifyListeners();
  }

  final List<Garage> _garages = [];

  List<Garage> get garages => _garages;

  void addGarage(String name, LatLng location, List<File> images) {
    _garages.add(Garage(
        name: name, location: location, images: images, inventoryItems: []));
    notifyListeners();
  }




  int globalItemCount=0;
  final Map<String, List<InventoryItem>> _globalInventory = {
    "Battery": [],
    "AC": [],
    "Brake": [],
    "Clutch": [],
    "Tyre": [],
  };

  Map<String, List<InventoryItem>> get inventory => _globalInventory;

  List<InventoryItem> getItemByCategory(String category) {
    return _globalInventory[category] ?? [];
  }

  void addGlobalItem(InventoryItem item){
    if (_globalInventory.containsKey(item.category)){
      _globalInventory[item.category]!.add(item);
    }
    else {
      _globalInventory[item.category] = [item];
    }
    globalItemCount++;
    notifyListeners();

    uploadItem(item);
  }
}