import 'package:flutter/material.dart';
import 'package:garage/Screens/ServiceBooking/address_slot.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State createState() => _MyCartState();
}

enum Service { pickup, walkin }

class _MyCartState extends State {
  Service? _service = Service.pickup;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(92, 199, 199, 199),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/Service_Booking/Basic_Servicing.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "Basic Servicing",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Full Servicing",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Rs. 17,519",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 15),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.disabled_by_default_outlined),
                        iconSize: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 235, left: 15, right: 15),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(92, 199, 199, 199),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 15),
                      child: Text(
                        "Mode of Service",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio<Service>(
                          value: Service.pickup,
                          groupValue: _service,
                          onChanged: (Service? value) {
                            setState(() {
                              _service = value;
                            });
                          },
                        ),
                        Text("Pick-up"),
                        SizedBox(width: 20),
                        Radio<Service>(
                          value: Service.walkin,
                          groupValue: _service,
                          onChanged: (Service? value) {
                            setState(() {
                              _service = value;
                            });
                          },
                        ),
                        Text("Walk-in"),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 375),
              child: Card(
                color: const Color.fromARGB(255, 235, 235, 235),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bill",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      totalBill("Item Total", "Rs. 17,519"),
                      totalBill("Warranty Fee", "Rs. 99"),
                      Divider(),
                      totalBill("Grand Total", "Rs. 17,618"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        width: double.infinity,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddressSlot()));
          },
          child: Text(
            "Select Address And Slot",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget totalBill(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
