import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/src/common_widgets/sidebar.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'package:utmfit/screens/admin/Announcement/announcements_page.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({Key? key}) : super(key: key);

  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int totalUsers = 0;
  int totalBooking = 0;
  int totalFacilities = 0;
  int _selectedIndex = 0;
  bool _isLoading = true;
  List<Map<String, dynamic>> facilities = [];

  @override
  void initState() {
    super.initState();
    fetchTotals();
  }

  Future<void> fetchTotals() async {
    try {
      // Fetch total number of users
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
      // Fetch total number of bookings
      QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance.collection('bookingform').get();

      // Fetch facilities data
      QuerySnapshot facilitiesSnapshot = await FirebaseFirestore.instance.collection('facilities').get();

      Map<String, int> facilitiesBookingCount = {};

      // Calculate total bookings for each facility
      for (var booking in bookingSnapshot.docs) {
        String game = booking['game'];
        if (facilitiesBookingCount.containsKey(game)) {
          facilitiesBookingCount[game] = facilitiesBookingCount[game]! + 1;
        } else {
          facilitiesBookingCount[game] = 1;
        }
      }

      List<Map<String, dynamic>> facilitiesData = facilitiesSnapshot.docs.map((doc) {
        return {
          "facilitiesName": doc['facilitiesName'],
          "totalBookings": facilitiesBookingCount[doc['game']] ?? 0,
        };
      }).toList();

      setState(() {
        totalUsers = usersSnapshot.size;
        totalBooking = bookingSnapshot.size;
        totalFacilities = facilitiesSnapshot.size;
        facilities = facilitiesData;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching totals: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrAdmin2,
      appBar: AppBar(
        title: Text('Admin UTM FIT'),
      ),
      drawer: sidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
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
                      SizedBox(height: 20),
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
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: _buildStatisticCard(
                                icon: Icons.people,
                                total: totalUsers,
                                label: 'Total Users',
                                labelColor: Colors.blue,
                              ),
                            ),
                            Expanded(
                              child: _buildStatisticCard(
                                icon: Icons.calendar_today,
                                total: totalBooking,
                                label: 'Total Booking',
                                labelColor: Colors.green,
                              ),
                            ),
                            Expanded(
                              child: _buildStatisticCard(
                                icon: Icons.sports_soccer,
                                total: totalFacilities,
                                label: 'Total Facilities',
                                labelColor: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Facilities',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: clrAdminPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              _buildFacilitiesTable(),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatisticCard({
    required IconData icon,
    required int total,
    required String label,
    required Color labelColor,
  }) {
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
              Table(
  border: TableBorder.all(color: Colors.black),
  children: [
    TableRow(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 163, 157, 157), // Background color for the header row
      ),
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
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total Booking', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    ),
          ...facilities.asMap().entries.map((entry) {
            int index = entry.key + 1;
            Map<String, dynamic> facilities = entry.value;
            return TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$index'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(facilities['facilitiesName']),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${facilities['totalBookings']}'),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
            ],
          ),
        ],
      ),
    );
  }
}

