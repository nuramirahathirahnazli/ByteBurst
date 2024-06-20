import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:utmfit/model/UserIdProvider.dart';
import 'package:utmfit/screens/user/booking/view_history_details.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart';
import 'package:utmfit/src/constants/colors.dart';

class MyHistoryBooking extends StatefulWidget {
  const MyHistoryBooking({Key? key}) : super(key: key);

  @override
  State<MyHistoryBooking> createState() => _MyHistoryBookingState();
}

class _MyHistoryBookingState extends State<MyHistoryBooking> {
  final List<Tab> tabs = [
    Tab(text: 'Active'),
    Tab(text: 'Past'),
    Tab(text: 'Cancelled'),
  ];

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final email = currentUser.email;
      if (email != null) {
        Provider.of<UserIdProvider>(context, listen: false).setUserEmail(email);
      } else {
        print('Current user email is null');
      }
    } else {
      print('No current user found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userIdProvider = Provider.of<UserIdProvider>(context);
    final userEmail = userIdProvider.userEmail;
    
    if (userEmail == null) {
      print('User email is null');
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          backgroundColor: clrUserPrimary,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    print('User email: $userEmail');

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: clrBase,
        appBar: AppBar(
          backgroundColor: clrUserPrimary,
          title: const Text('My Bookings'),
          automaticallyImplyLeading: false,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("bookingform")
              .where("userId", isEqualTo: userEmail) // Use the userEmail here
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bookingData = snapshot.data!.docs;
              if (bookingData.isEmpty) {
                print('No data available');
                return Center(
                  child: Text('No booking history available'),
                );
              } else {
                return Column(
                  children: [
                    TabBar(
                      tabs: tabs,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildBookingList(bookingData, 'Confirmed'),
                          _buildBookingList(bookingData, 'Completed'),
                          _buildBookingList(bookingData, 'Cancelled'),
                        ],
                      ),
                    ),
                  ],
                );
              }
            } else if (snapshot.hasError) {
              print('Error fetching data: ${snapshot.error}');
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 3, onItemTapped: (_) {}),
      ),
    );
  }

  Widget _buildBookingList(List<DocumentSnapshot> bookingData, String status) {
    return ListView.builder(
      itemCount: bookingData.length,
      itemBuilder: (context, index) {
        var booking = bookingData[index].data() as Map<String, dynamic>;

        if (booking['status'] == status) {
          return _buildBookingItem(
            date: booking['date'],
            game: booking['game'] + ' Court',
            status: status,
            icon: Icons.sports_tennis,
            bookingId: booking['bookingId'], // Pass bookingID to _buildBookingItem
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBookingItem({
    required String date,
    required String game,
    required String status,
    required IconData icon,
    required String bookingId,
  }) {
    Color statusColor = clrStatusConfirmed;
    if (status == 'Completed') {
      statusColor = clrStatusCompleted;
    } else if (status == 'Cancelled') {
      statusColor = clrStatusCancelled;
    }

    Color viewButtonColor = clrViewDetails;
    Color cancelButtonColor = clrCancel;

    DateTime dateTime = DateTime.parse(date); // Convert the date string to a DateTime object
    String formattedDate = DateFormat.yMMMMd().format(dateTime);
    String dayOfWeek = DateFormat.E().format(dateTime);

    return Card(
      //color: clrUser3,//background color
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 8.0),
                Text('$dayOfWeek, $formattedDate'),
              ],
            ),
            SizedBox(height: 8.0),
            Divider(), // Add a small divider line here
            SizedBox(height: 4.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    game,
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8.0), // Add space between the courtName text and buttons
                if (status == 'Confirmed') ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewHistoryDetails(bookingID: bookingId), // Pass bookingId to ViewHistoryDetails screen
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: viewButtonColor, // Set button color based on status
                            minimumSize: Size(double.infinity, 28.0), // Set minimum height for the button
                            padding: EdgeInsets.symmetric(vertical: 15.0), // Add padding to the button
                          ),
                          child: Text('View Details', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                        ),
                        SizedBox(height: 20), // Add space between the buttons
                        ElevatedButton(
                          onPressed: () {
                            _cancelBooking(context, bookingId); // Call function to cancel booking
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cancelButtonColor, // Set button color based on status
                            minimumSize: Size(double.infinity, 28.0), // Set minimum height for the button
                            padding: EdgeInsets.symmetric(vertical: 15.0), // Add padding to the button
                          ),
                          child: Text('Cancel Booking', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
                if (status != 'Confirmed') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewHistoryDetails(bookingID: bookingId), // Pass bookingId to ViewHistoryDetails screen
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: viewButtonColor, // Set button color based on status
                        minimumSize: Size(double.infinity, 28.0), // Set minimum height for the button
                        padding: EdgeInsets.symmetric(vertical: 15.0), // Add padding to the button
                      ),
                      child: Text('View Details', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 8.0),
            Text('Status: $status', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _cancelBooking(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancellation'),
          content: Text('Do you really want to cancel this booking?\nThis process cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _confirmCancellation(bookingId); // Call function to cancel booking
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _confirmCancellation(String bookingId) {
    FirebaseFirestore.instance.collection("bookingform").doc(bookingId).update({
      'status': 'Cancelled', // Update status to "Cancelled"
    }).then((value) {
      // Handle success
      print('Booking cancelled successfully');
    }).catchError((error) {
      // Handle error
      print('Failed to cancel booking: $error');
    });
  }
}
