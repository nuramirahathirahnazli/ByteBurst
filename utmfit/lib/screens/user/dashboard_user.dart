import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';


class dashboardUser extends StatefulWidget{
  const dashboardUser({super.key});

  @override
  State<dashboardUser> createState() => _dashboardUserState();
}

class _dashboardUserState extends State<dashboardUser> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color(0xFFECAA00),
        color: Color(0xFFECAA00),
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.sports_tennis_outlined, size: 26, color: Colors.white),
          Icon(Icons.add, size: 26, color: Colors.white),
          Icon(Icons.history, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: Center(
        child: Text(
          _page.toString(),
          style: const TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}