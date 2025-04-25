import "dart:developer";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:garage/Screens/HomePage/garagehomepage.dart";
import "package:garage/Screens/HomePage/userhomepage.dart";
import "package:garage/Screens/LoginScreen/otp_screen.dart";
import "package:garage/Screens/Profile/myprofilefirsttime.dart";
import "package:garage/Screens/Profile/profilescreen.dart";
import "package:provider/provider.dart";
import "./model_class.dart";
import 'package:firebase_storage/firebase_storage.dart';

void uploadUserData(BuildContext context) async {
  Map<String, dynamic> data = {
    "name": context.read<LoginData>().name,
    "email": context.read<LoginData>().email,
    "dOB": context.read<LoginData>().dOB,
    "gender": context.read<LoginData>().gender,
    "vehicleInfo": {
      "company": context.read<CarInfo>().carCompany,
      "model": context.read<CarInfo>().carModel,
      "fuel": context.read<CarInfo>().carFuelType,
    }
  };
  FirebaseFirestore.instance
      .collection("Users")
      .doc(context.read<LoginData>().completeNumber)
      .set(data);
}

void sendOTP(BuildContext context) async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: context.read<LoginData>().completeNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      log("error:");
      // print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️${e.message}'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    },
    codeSent: (String verificationId, int? forceResendingToken) {
      context.read<LoginData>().setVerificationId(verificationId);
      log(context.read<LoginData>().verificationId);
      log("otp sent");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const Otpscreen();
      }));
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
  context.read<Loader>().changeGetOtpLoader(false);
}

void sumbitOTP(BuildContext context, otp) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: context.read<LoginData>().verificationId, smsCode: otp);
  log(credential.verificationId.toString());
  try {
    log("otp is $otp");
    await FirebaseAuth.instance.signInWithCredential(credential);

    log("signin successfully");

    final docRef =
        FirebaseFirestore.instance.collection('Users').doc('+919665709491');
    try {
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        log('Document exists!');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const Userhomepage();
        }));
      } else {
        log('Document does not exist.');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const MyprofileFirstTime();
        }));
      }
    } catch (e) {
      log("error for doc");
    }
  } catch (e) {
    log(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  context.read<Loader>().changeSubmitOtpLoader(false);
}

void registerGarage(
    BuildContext context, Map<String, dynamic> data, List images) async {
      String completeNumber=context.read<LoginData>().completeNumber;
      List imageUrl=[];
  try {
    final docRef =
        FirebaseFirestore.instance.collection('Garages').doc(completeNumber);
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      log('Document exists!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Mobile number already used. Try with another number")),
      );
    } else {
      log('Document does not exist.');
      for(int i=0;i<images.length;i++){
        UploadTask uploadtask=FirebaseStorage.instance.ref().child('GarageImages').child(completeNumber).child(completeNumber+i.toString()).putFile(images[i]);
        TaskSnapshot taskSnapshot= await uploadtask;
        String downloadUrl= await taskSnapshot.ref.getDownloadURL();
        imageUrl.add(downloadUrl);
      }
      data['images']=imageUrl;



      await FirebaseFirestore.instance
          .collection("Garages")
          .doc(completeNumber)
          .set(data); //context.read<LoginData>().completeNumber
      log('garage registerd on firebase');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Garage added Successfully!")),
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Garagehomepage()));
    }
  } catch (e) {
    log("error for doc");
  }
}
