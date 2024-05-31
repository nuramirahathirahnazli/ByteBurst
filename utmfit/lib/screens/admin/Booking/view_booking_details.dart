import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  BookingDetailsScreen({required this.bookingDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking ID: ${bookingDetails['bookingId']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Court: ${bookingDetails['court']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Date: ${bookingDetails['date']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Game: ${bookingDetails['game']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Players: ${bookingDetails['players']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Status: ${bookingDetails['status']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Time: ${bookingDetails['time']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('User ID: ${bookingDetails['userId']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
