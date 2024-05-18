import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewHistoryDetails extends StatelessWidget {
  final String bookingId;

  const ViewHistoryDetails({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("booking").doc(bookingId).get(),
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${booking['courtType']} Court',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Divider(),
                SizedBox(height: 8.0),
                _buildDetailItem('Matric Number', booking['matricNumber']),
                _buildDetailItem('Day', booking['day']),
                _buildDetailItem('Date', booking['date']),
                _buildDetailItem('Duration', '2 hours'), // Assuming duration is fixed
                _buildDetailItem('Number of Players', booking['numOfPlayer']),
                _buildDetailItem('Court Number', booking['courtNumber']),
                Divider(),
                SizedBox(height: 8.0),
                Text(
                  'Total Payment: RM XX', // Replace XX with the actual amount
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label + ': ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
