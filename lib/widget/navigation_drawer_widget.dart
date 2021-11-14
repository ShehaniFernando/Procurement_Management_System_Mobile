import 'package:flutter/material.dart';
import 'package:procurement_management_system_frontend/page/order_list_page.dart';
import 'package:procurement_management_system_frontend/page/order_page.dart';
import 'package:procurement_management_system_frontend/page/profile_page.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Material(
        color: Colors.blue.shade800,
        child: ListView(
          children: <Widget>[
            buildHeader(
                urlImage: 'https://www.thepeakid.com/wp-content/uploads/2016/03/default-profile-picture.jpg',
                name: 'John Doe',
                email: 'JohnDoe@gmail.com',
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ))),

            Container(
              padding: padding,
              child: Column(
                children: [
                  Divider(color: Colors.white70),
                  const SizedBox(height: 6),

                  buildMenuItem(
                      text: 'My Profile',
                      icon: Icons.account_circle,
                      onClicked: () => selectedItem(context, 0)),   
                  const SizedBox(height: 1),               

                  // const SizedBox(height: 6),
                  // Divider(color: Colors.white70),
                  // const SizedBox(height: 6),

                  buildMenuItem(
                    text: 'Place Order',
                    icon: Icons.create,
                    onClicked: () => selectedItem(context, 1)),
                  const SizedBox(height: 1),
                  buildMenuItem(
                    text: 'Orders List',
                    icon: Icons.list,
                    onClicked: () => selectedItem(context, 2)),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
        break;
      case 1:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OrderPage(),
      ));
      break;
      case 2:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OrderListPage(),
      ));
      break;
    }
  }
}
