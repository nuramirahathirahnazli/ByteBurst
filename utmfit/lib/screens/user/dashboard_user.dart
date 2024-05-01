import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/profile/profile_user.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class dashboardUser extends StatefulWidget {
  const dashboardUser({super.key});

  @override
  State<dashboardUser> createState() => _dashboardUserState();
}

final CollectionReference announcementsCollection =
    FirebaseFirestore.instance.collection('announcements');

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
          Container(
            padding: EdgeInsets.only(top: 10.0), // Add padding only at the top
            child: Card(
              margin: EdgeInsets.all(8.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Choose a Facility:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add logic to navigate to the Squash facility page
                      },
                      icon: Image.asset(
                        'assets/images/squash.png',
                        width: 40,
                        height: 30,
                      ),
                      label: Text(
                        'Squash',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 231, 172),
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0), // Add spacing between the buttons
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add logic to navigate to the Ping Pong facility page
                      },
                      icon: Image.asset(
                        'assets/images/pingpong.png',
                        width: 30,
                        height: 30,
                      ),
                      label: Text(
                        'Ping Pong',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 231, 172),
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0), // Add spacing between the buttons
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add logic to navigate to the Badminton facility page
                      },
                      icon: Image.asset(
                        'assets/images/badminton.png',
                        width: 30,
                        height: 30,
                      ),
                      label: Text(
                        'Badminton',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 231, 172),
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // List of announcements
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Card(
              margin: EdgeInsets.all(8.0),
              elevation: 4.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: announcementsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Announcements:',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var announcement = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(
                              announcement['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            subtitle: Text(
                              announcement['description'],
                              style: TextStyle(color: Colors.black54),
                            ),
                            leading: Icon(
                              Icons.notifications,
                              color: Color(0xFF9F4F5D),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFF9F4F5D),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
