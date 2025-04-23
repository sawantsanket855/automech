import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:garage/Screens/LoginScreen/otp_screen.dart';
import 'package:garage/firebasedataupload.dart';
import 'package:garage/model_class.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyItem {
  String itemName;
  String path;
  MyItem(this.itemName, this.path);
}

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State createState() => _LoginState();
}

class _LoginState extends State {
  String phoneNumber = '';
  String completeNumber = '';
  int activeIndex = 0;
  List<MyItem> items = [
    MyItem("Efficient Vehicle Services at Your Fingertips",
        "assets/Login/login1.png"),
    MyItem("Your Car, Our Care: Seamless Pickup and Drop Service",
        "assets/Login/login2.png"),
    MyItem("Simplify, Organize, and Manage Your Car Like a Pro",
        "assets/Login/login3.png"),
  ];
  @override
  Widget build(BuildContext contsext) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {},
              child: Container(
                margin: const EdgeInsets.only(
                  top: 15,
                ),
                child: Text(
                  "Skip >>>",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              CarouselSlider.builder(
                itemCount: items.length,
                options: CarouselOptions(
                  height: 400,
                  viewportFraction: 1,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final imgList = items[index];
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 60,
                        ),
                        child: buildImage(imgList.path, index),
                      ),
                      buildText(imgList.itemName, index),
                    ],
                  );
                },
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 300, left: 170),
            child: buildIndicator(),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 350, left: 140),
            child: Text(
              "Login Via",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400, left: 0),
            child: IntlPhoneField(
              decoration: const InputDecoration(
                labelText: "Phone number",
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: "IN",
              onChanged: (phone) {
                phoneNumber = phone.number;
                completeNumber = phone.completeNumber;
                // print(phone.completeNumber);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 480),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                if(!context.read<Loader>().getOtpLoader){
                  if (phoneNumber.length == 10) {
                  context.read<LoginData>().setNumber(completeNumber);
                  context.read<Loader>().changeGetOtpLoader(true);
                  sendOTP(context);
                  
                  
                  //  Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) {
                  //       return const Otpscreen();
                  //     }));
                }
                }
                
              },
              child: context.read<Loader>().getOtpLoader ? SizedBox(
                height: 30,
                width: 30,
                child: Image.asset('assets/loading.gif')) :Text(
                "GET OTP",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 550),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(thickness: 1, color: Colors.grey),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("OR"),
                ),
                Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 600, left: 20),
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/Login/WhatsApp.png",
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "WhatsApp",
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin:const EdgeInsets.only(top: 600, right: 20),
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/Login/Telegram.png",
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "Telegram",
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildImage(String imgList, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Image.asset(
          imgList,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: items.length,
      effect: const JumpingDotEffect(
        dotColor: Colors.black,
        dotHeight: 15,
        dotWidth: 15,
        activeDotColor: Colors.red,
      ),
    );
  }

  buildText(String itemName, int index) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Text(
        textAlign: TextAlign.center,
        itemName,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
