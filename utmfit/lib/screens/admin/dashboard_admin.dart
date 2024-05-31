import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/src/common_widgets/sidebar.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'announcement_form_page.dart'; 

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({Key? key}) : super(key: key);

  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int totalUsers = 0;
  int totalBooking = 0;
  int _selectedIndex = 0;
  bool _isLoading = true;

  final CollectionReference announcementsCollection = FirebaseFirestore.instance.collection('announcements');

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

      setState(() {
        totalUsers = usersSnapshot.size;
        totalBooking = bookingSnapshot.size;
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

  void _navigateToFormPage({String? announcementId, String? title, String? description}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnnouncementFormPage(
          announcementId: announcementId,
          initialTitle: title,
          initialDescription: description,
        ),
      ),
    );
  }

  void _deleteAnnouncement(String announcementId) async {
    await announcementsCollection.doc(announcementId).delete();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Announcement deleted successfully'),
    ));
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
                            _buildStatisticCard(
                              icon: Icons.people,
                              total: totalUsers,
                              label: 'Total Users',
                              labelColor: Colors.blue,
                            ),
                            _buildStatisticCard(
                              icon: Icons.calendar_today,
                              total: totalBooking,
                              label: 'Total Booking',
                              labelColor: Colors.green,
                            ),
                            _buildStatisticCard(
                              icon: Icons.sports_soccer,
                              total: 3,
                              label: 'Total Facilities',
                              labelColor: Colors.orange,
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
                                      'Announcements',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: clrAdminPrimary,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () => _navigateToFormPage(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              _buildAnnouncementsList(),
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

  Widget _buildAnnouncementsList() {
  return StreamBuilder(
    stream: announcementsCollection.snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
      if (streamSnapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (streamSnapshot.hasError) {
        return Center(child: Text('Error: ${streamSnapshot.error}'));
      }

      if (streamSnapshot.hasData) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: streamSnapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
            return ListTile(
              title: Text(documentSnapshot['title']),
              subtitle: Text(documentSnapshot['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _navigateToFormPage(
                      announcementId: documentSnapshot.id,
                      title: documentSnapshot['title'],
                      description: documentSnapshot['description'],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteAnnouncement(documentSnapshot.id),
                  ),
                ],
              ),
            );
          },
        );
      }

      return Center(child: Text('No announcements found.'));
    },
  );
}
}
