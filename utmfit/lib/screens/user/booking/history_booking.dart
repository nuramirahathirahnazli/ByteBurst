import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart';
import 'package:utmfit/src/constants/colors.dart';

class MyHistoryBooking extends StatefulWidget {
  const MyHistoryBooking({Key? key}) : super(key: key);

  @override
  State<MyHistoryBooking> createState() => _MyHistoryBookingState();
}

class _MyHistoryBookingState extends State<MyHistoryBooking> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final List<Tab> tabs = [
    Tab(text: 'Active'),
    Tab(text: 'Past'),
    Tab(text: 'Cancelled'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: clrUserPrimary,
          title: const Text('My Bookings'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("booking").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bookingData = snapshot.data!.docs;

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
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
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
            date: (booking['dateBook'] as Timestamp).toDate(),
            courtName: booking['courtType'] + ' Court',
            status: status,
            icon: Icons.sports_tennis,
            bookingId: booking['bookingID'], // Pass bookingID to _buildBookingItem
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBookingItem({
    required DateTime date,
    required String courtName,
    required String status,
    required IconData icon,
    required String bookingId, // Add bookingId to identify the specific booking
  }) {
    Color statusColor = clrStatusConfirmed;
    if (status == 'Completed') {
      statusColor = clrStatusCompleted;
    } else if (status == 'Cancelled') {
      statusColor = clrStatusCancelled;
    }

    Color viewButtonColor = clrViewDetails;
    Color cancelButtonColor = clrCancel;

    String formattedDate = DateFormat.yMMMMd().format(date);
    String dayOfWeek = DateFormat.E().format(date);

    return Card(
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
                    courtName,
                    style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
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
                            // Handle view details
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
                        // Handle view details
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
    FirebaseFirestore.instance.collection("booking").doc(bookingId).update({
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
