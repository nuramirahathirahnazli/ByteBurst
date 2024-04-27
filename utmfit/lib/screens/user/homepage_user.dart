import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/profile/profile_user.dart';
import 'package:utmfit/src/constants/colors.dart';

class HomepageUser extends StatelessWidget {
  const HomepageUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTMFit'), // Make the title const
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Choice of facilities section
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Choose a Facility:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Add logic to navigate to the Squash facility page
                  },
                  child: const Text('Squash'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to navigate to the Ping Pong facility page
                  },
                  child: const Text('Ping Pong'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to navigate to the Badminton facility page
                  },
                  child: const Text('Badminton'),
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
