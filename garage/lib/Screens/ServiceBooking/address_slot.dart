import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressSlot extends StatefulWidget {
  const AddressSlot({super.key});

  @override
  State createState() => _AddressSlotState();
}

class _AddressSlotState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Booking Details",
          style: GoogleFonts.poppins(
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
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
                      "Cart Summary",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Mode : ",
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        Text(
                          "Pick-up",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 200,
                          child: Text("Narhe,Pune,Maharashtra 411041,India"),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
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
