import 'package:flutter/material.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart';
import 'package:utmfit/src/constants/colors.dart';

final List<Tab> tabs = [
  Tab(text: 'Active'),
  Tab(text: 'Past'),
  Tab(text: 'Cancelled'),
];

class MyHistoryBooking extends StatelessWidget {
  const MyHistoryBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 3; // Assuming bookings is the 4th item (index 3)

    return DefaultTabController(
      length: tabs.length, // Set the number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: clrUserPrimary, // Assuming clrUserPrimary is defined
          title: const Text('My Bookings'),
        ),
        body: Column(
          children: [
            TabBar(
              tabs: tabs,
              // Add customization for tab styles (optional)
            ),
            Expanded(
  child: TabBarView(
    children: [
      // Active bookings
      ListView(
        children: [
          _buildBookingItem(
            day: 'Monday',
            date: '25 April 2024',
            courtName: 'Squash Court 1',
            status: 'Confirmed',
            icon: Icons.sports_tennis,
            tabIndex: 0, // Pass the tabIndex for the Active tab
          ),
          _buildBookingItem(
            day: 'Wednesday',
            date: '27 April 2024',
            courtName: 'Squash Court 2',
            status: 'Confirmed',
            icon: Icons.sports_tennis,
            tabIndex: 0, // Pass the tabIndex for the Active tab
          ),
        ],
      ),
      // Past bookings
      ListView(
        children: [
          _buildBookingItem(
            day: 'Friday',
            date: '20 April 2024',
            courtName: 'Squash Court 1',
            status: 'Completed',
            icon: Icons.sports_tennis,
            tabIndex: 1, // Pass the tabIndex for the Past tab
          ),
          _buildBookingItem(
            day: 'Sunday',
            date: '22 April 2024',
            courtName: 'Squash Court 3',
            status: 'Completed',
            icon: Icons.sports_tennis,
            tabIndex: 1, // Pass the tabIndex for the Past tab
          ),
        ],
      ),
      // Cancelled bookings
      ListView(
        children: [
          _buildBookingItem(
            day: 'Tuesday',
            date: '23 April 2024',
            courtName: 'Squash Court 2',
            status: 'Cancelled',
            icon: Icons.sports_tennis,
            tabIndex: 2, // Pass the tabIndex for the Cancelled tab
          ),
          _buildBookingItem(
            day: 'Thursday',
            date: '26 April 2024',
            courtName: 'Squash Court 1',
            status: 'Cancelled',
            icon: Icons.sports_tennis,
            tabIndex: 2, // Pass the tabIndex for the Cancelled tab
          ),
        ],
      ),
    ],
  ),
),

          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: selectedIndex,
          onItemTapped: (index) => { },
        ),
      ),
    );
  }

  Widget _buildBookingItem({
  required String day,
  required String date,
  required String courtName,
  required String status,
  required IconData icon,
  required int tabIndex,
}) {
  Color statusColor = clrStatusConfirmed; // Default color for confirmed status
  if (status == 'Completed') {
    statusColor = clrStatusCompleted;
  } else if (status == 'Cancelled') {
    statusColor = clrStatusCancelled;
  }

  Color viewButtonColor = clrViewDetails; // Default color for view button
  Color cancelButtonColor = clrCancel; // Default color for cancel button

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
              Text('$day, $date'),
            ],
          ),
          SizedBox(height: 8.0),
          SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  courtName,
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 8.0), // Add space between the courtName text and buttons
              tabIndex == 0 // Check if the current tab is "Active"
                  ? Expanded(
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
                              // Handle cancel booking
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
                    )
                  : Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle view details
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: viewButtonColor, // Set button color based on status
                          minimumSize: Size(double.infinity, 28.0), // Set minimum height for the button
                          padding: EdgeInsets.symmetric(vertical: 15.0), // Add padding to the button
                        ),
                        child: Text('View Details', style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
            ],
          ),
          SizedBox(height: 8.0),
          Text('Status: $status', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)), // Set text color based on status
        ],
      ),
    ),
  );
}
}