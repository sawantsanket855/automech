import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:garage/Screens/CarCompany/carCompany.dart';
import 'package:garage/Screens/CarCompany/fuelType.dart';
import 'package:garage/Screens/CarCompany/manualEntry.dart';
import 'package:garage/Screens/HomePage/garagehomepage.dart';
import 'package:garage/Screens/HomePage/userhomepage.dart';
import 'package:garage/Screens/Inventory/acPage.dart';
import 'package:garage/Screens/Inventory/add_item.dart';
import 'package:garage/Screens/Inventory/batteryPage.dart';
import 'package:garage/Screens/Inventory/brakePage.dart';
import 'package:garage/Screens/Inventory/clutchPage.dart';
import 'package:garage/Screens/Inventory/glassPage.dart';
import 'package:garage/Screens/Inventory/inventory.dart';
import 'package:garage/Screens/Inventory/lightPage.dart';
import 'package:garage/Screens/Inventory/suspensionPage.dart';
import 'package:garage/Screens/Inventory/tyrePage.dart';
import 'package:garage/Screens/LoginScreen/login.dart';
import 'package:garage/Screens/LoginScreen/otp_screen.dart';
import 'package:garage/Screens/MapScreen/MapScreen.dart';
import 'package:garage/Screens/Profile/myprofile.dart';
import 'package:garage/Screens/Profile/myprofilefirsttime.dart';
import 'package:garage/Screens/Profile/profilescreen.dart';
import 'package:garage/Screens/Profile/register_partner.dart';
import 'package:garage/Screens/SplashScreen/SplashScreen.dart';
import 'package:garage/Screens/CarCompany/modelSelection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage/model_class.dart';
import 'package:garage/navBar.dart';
import 'package:garage/provider_class.dart';
import 'package:garage/shared_preferences_function.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options:const FirebaseOptions(apiKey: "AIzaSyBJp_EviA7gE9MCsv2yuaptfgxcSKIsqKE", appId: "1:800570586689:android:4ff34861306367c4f9f8c0", messagingSenderId: "800570586689", projectId: "automech-ca3b2"));
 bool isPreviousLogin= await isAccountLogined();
  runApp(MainApp(isPreviousLogin));
}

class MainApp extends StatelessWidget {
  final bool isPreviousLogin;
  MainApp(this.isPreviousLogin,{super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:(context)=>LoginData(),
          ),
          ChangeNotifierProvider(
          create:(context)=>CarInfo(),
          ),
          ChangeNotifierProvider(
          create:(context)=>Loader(),
          ),
          ChangeNotifierProvider(
          create:(context)=>GarageProvider(),
          ),
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home:isPreviousLogin ?const Navbar() :const Login() ,





      // home: SplashScreen(),
      // home:HomeScreen(),
      // home:Navbar(),
      // home:AddItem(),
    )
      );
  }
}
