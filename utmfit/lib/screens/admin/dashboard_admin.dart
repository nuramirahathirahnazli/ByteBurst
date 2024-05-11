import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:utmfit/screens/user/profile/profile_user.dart';
import 'package:utmfit/src/constants/colors.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({Key? key}) : super(key: key);

  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
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
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      totalUsers = usersSnapshot.size;
    });

    // Fetch total number of bookings
    QuerySnapshot bookingsSnapshot =
        await FirebaseFirestore.instance.collection('bookings').get();
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
        automaticallyImplyLeading: false,
        title: Text('Admin UTM FIT'),
      ),
      body: Stack(
        children: <Widget>[
          // Curved background container
          Positioned(
            child: Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: clrAdminPrimary,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20), // Add some space between appbar and welcome text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Welcome Admin!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 40), // Add some space between welcome text and cards
                Padding(
                  padding: const EdgeInsets.all(1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildStatisticCard(
                        icon: Icons.people,
                        total: totalUsers,
                        label: 'Total Users',
                        labelColor: Colors.blue,
                      ),
                      _buildStatisticCard(
                        icon: Icons.calendar_today,
                        total: totalBookings,
                        label: 'Total Bookings',
                        labelColor: Colors.green,
                      ),
                      _buildStatisticCard(
                        icon: Icons.sports_soccer,
                        total: totalFacilities,
                        label: 'Total Facilities',
                        labelColor: Colors.orange,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add some space between cards and the new card
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Facilities',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: clrAdminPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildFacilitiesTable(),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Handle adding facilities
                          },
                          child: Text('Add Facilities'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    );
  }

  Widget _buildStatisticCard({required IconData icon, required int total, required String label, required Color labelColor}) {
    return Container(
      width: 130,
      height: 140,
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

 Widget _buildFacilitiesTable() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Number', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Name Facilities', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('1'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Squash'),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('2'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Badminton'),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('3'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Ping Pong'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void main() {
  runApp(MaterialApp(
    home: DashboardAdmin(),
  ));
}
}