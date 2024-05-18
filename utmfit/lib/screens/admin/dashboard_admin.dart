import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/screens/user/profile/profile_user.dart';
import 'package:utmfit/src/constants/colors.dart';

class dashboardAdmin extends StatefulWidget {
  const dashboardAdmin({Key? key}) : super(key: key);

  @override
  _dashboardAdminState createState() => _dashboardAdminState();
}


class _dashboardAdminState extends State<dashboardAdmin> {
  late int totalUsers = 0;
  late int totalBookings = 0;
  late int totalFacilities = 0;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    fetchTotals();
  }

  void fetchTotals() async {
    // Fetch total number of users
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();
    setState(() {
      totalUsers = usersSnapshot.size;
    });

    // Fetch total number of bookings
    QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .get();
    setState(() {
      totalBookings = bookingsSnapshot.size;
    });

    // Fetch total number of facilities
    QuerySnapshot facilitiesSnapshot = await FirebaseFirestore.instance
        .collection('facilities')
        .get();
    setState(() {
      totalFacilities = facilitiesSnapshot.size;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: clrAdmin2,
    appBar: AppBar(
      automaticallyImplyLeading: false, // Add this line to remove the back button
  title: Text('Admin UTM FIT'),
    ),
    bottomNavigationBar: CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: clrAdminPrimary,
      color: clrAdminPrimary,
      animationDuration: const Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(Icons.home, size: 26, color: Colors.white),
        Icon(Icons.people, size: 26, color: Colors.white),
        Icon(Icons.checklist, size: 26, color: Colors.white),
        Icon(Icons.sports_score, size: 26, color: Colors.white),
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
    body: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Total Users Section
            _buildStatisticCard(
              icon: Icons.people,
              total: totalUsers,
              label: 'Total Users',
              labelColor: Colors.blue, // Set background color for label
            ),

            // Total Bookings Section
            _buildStatisticCard(
              icon: Icons.calendar_today,
              total: totalBookings,
              label: 'Total Bookings',
              labelColor: Colors.green, // Set background color for label
            ),

            // Total Facilities Section
            _buildStatisticCard(
              icon: Icons.sports_soccer,
              total: totalFacilities,
              label: 'Total Facilities',
              labelColor: Colors.orange, // Set background color for label
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildStatisticCard({required IconData icon, required int total, required String label, required Color labelColor}) {
    return Container(
      width: 130,
      height: 150,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: clrAdminPrimary,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$total',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: labelColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}