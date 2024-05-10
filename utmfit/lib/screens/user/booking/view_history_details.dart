import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart';
import 'package:utmfit/src/constants/colors.dart';

class ViewHistoryDetails extends StatelessWidget {
  final String bookingID;

  const ViewHistoryDetails({Key? key, required this.bookingID}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: clrBase,
    appBar: AppBar(
      backgroundColor: clrUserPrimary,
      title: Text('Booking Details'),
    ),
    body: FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("booking").doc(bookingID).get(),
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

  return Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // Set the width to 80% of the screen width
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Reduce padding
          child: Center( // Center the content horizontally
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Align items to the center horizontally
              children: [
                Text(
                  '${booking['courtType']} Court',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Show ellipsis if the text overflows
                  maxLines: 1, // Limit to a single line
                ),
                Divider(),
                _buildDetailItem('Matric Number', booking['matricNumber']),
                //_buildDetailItem('Day', booking['day']),
                _buildDetailItem('Date', booking['dateBook']),
                _buildDetailItem('Duration', '2 hours'), // Assuming duration is fixed
                _buildDetailItem('Time', booking['timeBook']),
                _buildDetailItem('Number of Players', booking['numOfPlayer']),
                _buildDetailItem('Court Number', booking['preferredCourt']),
                Divider(),
                _buildDetailItem('Total Payment', 'RM XX'), // Replace XX with the actual amount
                SizedBox(height: 4.0), // Reduce space
              ],
            ),
          ),
        ),
      ),
    ),
  );
},

    ),
    bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 3, onItemTapped: (_) {}),
  );
}





  Widget _buildDetailItem(String label, dynamic value) {
  String formattedValue = '';
  if (label == 'Date') {
    DateTime dateTime = (value as Timestamp).toDate();
    formattedValue = DateFormat.yMd().format(dateTime); // Format date as 'MM/dd/yyyy'
  } else if (label == 'Time') {
    DateTime dateTime = (value as Timestamp).toDate();
    formattedValue = DateFormat.Hm().format(dateTime); // Format time as 'HH:mm'
  } else {
    formattedValue = value.toString();
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
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
