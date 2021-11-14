import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        backwardsCompatibility: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    'Profile Page',
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
            ],
          ),
        ),
      ),
    );
  }
}
