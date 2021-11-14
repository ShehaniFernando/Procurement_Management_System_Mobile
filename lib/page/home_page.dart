import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:procurement_management_system_frontend/widget/navigation_drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery. of(context). size. height;

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backwardsCompatibility: false,
        backgroundColor: Colors.blue.shade700,
        title: Text('Home Page'),
      ),
      body: Container(
        child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                  'Welcome the procuremt placement',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cardo',
                    fontSize: 25,
                    color: Color(0xff0C2551),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                ],
              )
            )
      ),
    );
  }

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(56),
              primary: Colors.white,
              onPrimary: Colors.black,
              textStyle: TextStyle(fontSize: 20)),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Text(title)
            ],
          ),
          onPressed: onClicked);
}
