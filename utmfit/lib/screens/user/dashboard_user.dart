import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/profile/profile_user.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/src/constants/colors.dart';

class dashboardUser extends StatefulWidget {
  const dashboardUser({super.key});

  @override
  State<dashboardUser> createState() => _dashboardUserState();
}

class _dashboardUserState extends State<dashboardUser> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrBase, // Set the entire background screen color
      appBar: AppBar(
        title: Text('UTM FIT'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const loginScreen()),
              );
            },
            child: Text(
              'Sign In',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 187, 0),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
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
          if (index == 4) {
            // Assuming index 4 corresponds to the "person" icon
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileUser()),
            );
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Choice of facilities section
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Choice a Facility:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    // Add logic to navigate to the Squash facility page
                  },
                  icon: Image.asset('assets/images/squash.png'),
                  label: Text('Squash'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 231, 172)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add logic to navigate to the Ping Pong facility page
                  },
                  icon: Image.asset('assets/images/pingpong.png'),
                  label: Text('Ping Pong'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 231, 172)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add logic to navigate to the Badminton facility page
                  },
                  icon: Image.asset('assets/images/badminton.png'),
                  label: Text('Badminton'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 231, 172)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // List of announcements
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Announcements:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: const Text('Announcement 1'),
                  subtitle: const Text('Details of Announcement 1'),
                ),
                ListTile(
                  title: const Text('Announcement 2'),
                  subtitle: const Text('Details of Announcement 2'),
                ),
                // Add more announcements as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
