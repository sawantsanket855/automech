import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoginData extends ChangeNotifier{
  String loginType='user';
  String verificationId='';
  String completeNumber='+9665709490';
  String name='';
  String email='';
  String dOB='';
  String gender='';

  void setNumber(String newNumber){
    completeNumber=newNumber;
    notifyListeners();
  }
  void setVerificationId(String newID){
    verificationId=newID;
    notifyListeners();
  }
  void setData({String? newName,String? newEmail,String? newDOB,String? newGender}){
    name=newName??name;
    email=newEmail??email;
    dOB=newDOB??dOB;
    gender=newGender??gender;
    notifyListeners();
  }


}


class CarInfo extends ChangeNotifier{
  String carCompany='';
  String carFuelType='';
  String carModel='';

  void setCarCompany(String newCarCompany){
    carCompany=newCarCompany;
    ChangeNotifier();
  }

  void setCarModel(String newCarModel){
    carModel=newCarModel;
    ChangeNotifier();
  }
   void setCarFuel(String newCarFuel){
    carFuelType=newCarFuel;
    ChangeNotifier();
  }
}


class Loader extends ChangeNotifier{
  bool getOtpLoader=false;
  void changeGetOtpLoader(value){
    getOtpLoader=value;
    ChangeNotifier();
  }
  bool submitOtpLoader=false;
  void changeSubmitOtpLoader(value){
    getOtpLoader=value;
    ChangeNotifier();
  }
}

class GarageProvider extends ChangeNotifier {
  final List<Marker> _garageMarkers = [];

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
}