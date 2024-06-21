import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore library
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'package:utmfit/src/common_widgets/sidebar.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/src/common_widgets/admin_bottom_navigation.dart'; // Import the new widget

// Model class for Facility
class Facility {
  final String number;
  final String name;
  final String location;
  int totalBookings;

  Facility({
    required this.number,
    required this.name,
    required this.location,
    this.totalBookings = 0, // Default to 0 bookings
  });
}

class FacilitiesAdmin extends StatefulWidget {
  const FacilitiesAdmin({Key? key}) : super(key: key);

  @override
  _FacilitiesAdminState createState() => _FacilitiesAdminState();
}

class _FacilitiesAdminState extends State<FacilitiesAdmin> {
  int _selectedIndex = 3;
  List<Facility> facilities = []; // List to hold fetched facilities

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
  void initState() {
    super.initState();
    fetchFacilities(); // Fetch facilities data when the widget initializes
  }

  void fetchFacilities() async {
    try {
      // Fetch facilities data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('facilities').get();
      
      // Map the query snapshot to List<Facility>
      List<Facility> fetchedFacilities = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Facility(
          number: data['facilitiesID'] ?? '',
          name: data['facilitiesName'] ?? '',
          location: data['location'] ?? '',
          totalBookings: 0, // Initialize totalBookings to 0
        );
      }).toList();

      // Fetch bookings count for each facility
      for (Facility facility in fetchedFacilities) {
        int totalBookings = await getTotalBookingsForFacility(facility.name); // Fetch total bookings for facility's game
        facility.totalBookings = totalBookings;
      }

      setState(() {
        facilities = fetchedFacilities;
      });
    } catch (e) {
      print('Error fetching facilities: $e');
    }
  }

  // Function to get total bookings for a specific facility's game from Firestore
  Future<int> getTotalBookingsForFacility(String game) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('bookingform')
          .where('game', isEqualTo: game)
          .get();

      return querySnapshot.size; // Return the number of documents (total bookings)
    } catch (e) {
      print('Error fetching bookingform: $e');
      return 0; // Return 0 in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrAdminBase, // Set the entire background screen color
      appBar: AppBar(
        backgroundColor: clrAdminPrimary,
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
                  DataColumn(label: Text('Total Bookings')), // New column for total bookings
                ],
                dataRowHeight: 60,
                rows: facilities.asMap().entries.map((entry) {
                  int index = entry.key;
                  Facility facility = entry.value;
                  print("Facility: ${facility.name}, Location: ${facility.location}, Total Bookings: ${facility.totalBookings}"); // Debugging print statement
                  return DataRow(cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(facility.name)),
                    DataCell(Text(facility.location)),
                    DataCell(Text('${facility.totalBookings}')),
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
