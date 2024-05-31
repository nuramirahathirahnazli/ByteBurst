import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmfit/screens/admin/Booking/view_list_booking.dart';
import 'package:utmfit/screens/admin/dashboard_admin.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/screens/admin/announcements_page.dart';


class sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const sidebar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => loginScreen()),  // Navigate to the login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: clrAdminPrimary,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            selected: selectedIndex == 0,
            onTap: () {
              onItemTapped(0);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardAdmin()));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('User'),
            selected: selectedIndex == 1,
            onTap: () {
              onItemTapped(1);
              // Add your desired navigation here
            },
          ),
          ListTile(
            leading: Icon(Icons.task),
            title: Text('Booking'),
            selected: selectedIndex == 2,
            onTap: () {
              onItemTapped(2);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewListBooking()));
            },
          ),
          ListTile(
            leading: Icon(Icons.sports_tennis_outlined),
            title: Text('Facilities'),
            selected: selectedIndex == 3,
            onTap: () {
              onItemTapped(3);
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookingFormPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement),
            title: Text('Announcement'),
            selected: selectedIndex == 4,
            onTap: () {
              onItemTapped(4);
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AnnouncementsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            selected: selectedIndex == 5,
            onTap: () {
              onItemTapped(5);
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileUser()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            selected: false,
            onTap: () {
              _signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
