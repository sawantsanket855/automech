import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Userhomepage extends StatefulWidget {
  const Userhomepage({super.key});
  @override
  State createState() => _Userhomepage();
}

class _Userhomepage extends State {
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body:const Center(
        child: Text("Homepage"),
      )
    );
  }
}
