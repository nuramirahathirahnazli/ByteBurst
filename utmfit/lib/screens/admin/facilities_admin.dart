// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'package:utmfit/src/common_widgets/sidebar.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/src/common_widgets/admin_bottom_navigation.dart'; // Import the new widget

class FacilitiesAdmin extends StatefulWidget {
  const FacilitiesAdmin({Key? key}) : super(key: key);

  @override
  _FacilitiesAdminState createState() => _FacilitiesAdminState();
}

class _FacilitiesAdminState extends State<FacilitiesAdmin> {
  int _selectedIndex = 3;

  final List<Map<String, String?>> facilities = [
    {
      'number': '1',
      'name': 'Squash',
      'location': 'Building A, Floor 2',
    },
    {
      'number': '2',
      'name': 'Badminton',
      'location': 'Sports Complex, Hall B',
    },
    {
      'number': '3',
      'name': 'Ping Pong',
      'location': 'Community Center, Room C',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the selected screen
    navigateToScreen(context, index);
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => loginScreen()), // Navigate to LoginScreen widget directly
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrAdminBase, // Set the entire background screen color
      appBar: AppBar(
        backgroundColor: clrAdminPrimary,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Spacer(),
            Text('Hi, Admin', style: TextStyle(color: Colors.white)),
            Spacer(),
            TextButton(
              onPressed: _signOut,
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      drawer: sidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'List of Facilities',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Total All: ${facilities.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('No.')),
                  DataColumn(label: Text('Name ')),
                  DataColumn(label: Text('Location')),
                ],
                dataRowHeight: 60,
                rows: facilities.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, String?> facility = entry.value;
                  print("Facility: ${facility['name']}, Location: ${facility['location']}"); // Debugging print statement
                  return DataRow(cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(facility['name'] ?? 'N/A')),
                    DataCell(Text(facility['location'] ?? 'N/A')),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
