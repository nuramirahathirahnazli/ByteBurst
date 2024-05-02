import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/profile/profile_user.dart';
import 'package:utmfit/src/constants/colors.dart';

class BookingFormPage extends StatelessWidget {
  const BookingFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Form'),
        backgroundColor: clrUserPrimary, // Background color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Conditions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. A minimum of 4 people and a maximum of 6 people per booking.\n'
                      '2. Only UTM students and staff are allowed to make reservations and use the facilities at the sports complex.\n'
                      '3. For event, please contact 07-5535776 (Mr. Sharul).\n',
              
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
  onPressed: () {
    // Navigate to the next page of the booking form
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingFormPage2()),
    );
  },
  child: Text('Next'),
),

          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color(0xFFECAA00),
        color: Color(0xFFECAA00),
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.sports_tennis_outlined, size: 26, color: Colors.white),
          Icon(Icons.add, size: 26, color: Colors.white),
          Icon(Icons.history, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          if (index == 1) {
            // Navigate to the booking form page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookingFormPage()),
            );
          } else if (index == 4) {
            // Navigate to the profile page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileUser()),
            );
          }
        },
      ),
    );
  }
}

class BookingFormPage2 extends StatelessWidget {
  const BookingFormPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrUserPrimary,
        title: Text('Booking Form - Page 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Conditions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. A minimum of 4 people and a maximum of 6 people per booking.\n'
                      '2. Only UTM students and staff are allowed to make reservations and use the facilities at the sports complex.\n'
                      '3. For event, please contact 07-5535776 (Mr. Sharul).\n',
              
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
  onPressed: () {
    // Navigate to the next page of the booking form
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingFormPage2()),
    );
  },
  child: Text('Next'),
),

          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color(0xFFECAA00),
        color: Color(0xFFECAA00),
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.sports_tennis_outlined, size: 26, color: Colors.white),
          Icon(Icons.add, size: 26, color: Colors.white),
          Icon(Icons.history, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          if (index == 1) {
            // Navigate to the booking form page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookingFormPage()),
            );
          } else if (index == 4) {
            // Navigate to the profile page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileUser()),
            );
          }
        },
      ),
    );
  }
}