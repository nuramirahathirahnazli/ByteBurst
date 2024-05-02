import 'package:flutter/material.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart';
import 'package:utmfit/src/constants/colors.dart';

class MyHistoryBooking extends StatelessWidget {
  const MyHistoryBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 3; // Assuming bookings is the 4th item (index 3)

    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrUserPrimary, // Assuming clrUserPrimary is defined
        title: const Text('My Booking History'),
      ),
      body: Center(
        child: Text(
          'No booking history found.',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey, // Adjust color as needed
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) => {
          // This callback is already defined in your custom navigation bar
        },
      ),
    );
  }
}

