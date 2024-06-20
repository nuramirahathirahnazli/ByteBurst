import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart';
import 'package:utmfit/src/constants/colors.dart';

class ViewHistoryDetails extends StatelessWidget {
  final String bookingID;

  const ViewHistoryDetails({Key? key, required this.bookingID}) : super(key: key);

  Future<String> _getMatricNumber(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("Users").doc(userId).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return userData['matricNumber'] ?? 'Not available';
    }
    return 'Not available';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrBase,
      appBar: AppBar(
        backgroundColor: clrUserPrimary,
        title: Text('Booking Details'),
        //automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("bookingform").doc(bookingID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('Booking not found.'));
          }

          var booking = snapshot.data!.data() as Map<String, dynamic>;
          String userId = booking['userId'];

          return FutureBuilder<String>(
            future: _getMatricNumber(userId),
            builder: (context, matricSnapshot) {
              if (matricSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (matricSnapshot.hasError) {
                return Center(child: Text('Error: ${matricSnapshot.error}'));
              }

              String matricNumber = matricSnapshot.data ?? 'Not available';

              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9, // Adjust the width to 90% of the screen width
                  child: Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Increase padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
                        children: [
                          Text(
                            '${booking['game']} Court',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Divider(),
                          _buildDetailItem('Matric Number', matricNumber),
                          _buildDetailItem('Date', booking['date']),
                          _buildDetailItem('Duration', '1 hour'),
                          _buildDetailItem('Time', booking['time']),
                          _buildDetailItem('Number of Players', booking['players']),
                          _buildDetailItem('Court Number', booking['court']),
                          Divider(),
                          _buildDetailItem('Total Payment', 'RM 5.00'), // Replace XX with the actual amount
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 3, onItemTapped: (_) {}),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    String formattedValue = '';

    if (label == 'Date') {
      formattedValue = value; // Use the date string directly
    } else if (label == 'Time') {
      formattedValue = value; // Use the time string directly
    } else {
      formattedValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increase vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8), // Add some space between label and value
          Expanded(
            child: Text(
              formattedValue,
              textAlign: TextAlign.right, // Align value to the right
            ),
          ),
        ],
      ),
    );
  }
}
