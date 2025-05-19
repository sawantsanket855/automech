import 'package:flutter/material.dart';
import 'package:garage/model_class.dart';
import 'package:garage/provider_class.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  @override
  Widget build(BuildContext context) {
    final garageProvider = Provider.of<GarageProvider>(context);
    final garages = garageProvider.garages;

    return Scaffold(
      appBar: AppBar(
        title: Text("Garages"),
      ),
      body: ListView.builder(
        itemCount: garages.length,
        itemBuilder: (context, index) {
          final garage = garages[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              onTap: () {},
              title: Text(garage.name),
              subtitle: Text(
                  'Lat: ${garage.location.latitude}, Lng: ${garage.location.longitude}'),
              leading: garage.images.isNotEmpty
                  ? Image.file(
                      garage.images[0],
                      width: 60,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.garage),
            ),
          );
        },
      ),
    );
  }
}
