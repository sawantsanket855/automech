import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:garage/provider_class.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  var data1;

  bool _isLoading = true;

    @override
  void initState() {
    super.initState();
    getGarages();
  }


  Future<void> getGarages()async{
    try{
      var data=await FirebaseFirestore.instance.collection('Garages').get();
      data1=data.docs;
      print(data1);
    }catch(e){
      log("error while retrieving data");
    }finally{
     setState(() {
        _isLoading = false;
      });
      log("no loading");
    }
    
    log("data display");
    
  }

  @override

  Widget build(BuildContext context) {


    return _isLoading? const Text("Loading"): 
    Scaffold(
      appBar: AppBar(
        // title: Text("Garages"),
        title:const Text('Garages'),

      ),
      body: ListView.builder(
        itemCount: data1.length,
        itemBuilder: (context, index) {
          return Card(
            margin:const EdgeInsets.all(10),
            child: ListTile(
              onTap: () {},
              title: Text(data1[index]["name"]),
              subtitle: Text(data1[index]["address"]),
              leading: data1[index].data().containsKey('images')
                  ? Image.network(data1[index]["images"][0])
                  :const Icon(Icons.garage),
            ),
          );
        },
      ),
    );
  }
}
