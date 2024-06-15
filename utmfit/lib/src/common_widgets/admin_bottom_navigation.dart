import 'package:flutter/material.dart';
import 'package:utmfit/screens/admin/Announcement/announcements_page.dart';
import 'package:utmfit/screens/admin/Booking/view_list_booking.dart';
import 'package:utmfit/screens/admin/dashboard_admin.dart';
import 'package:utmfit/screens/admin/facilities_admin.dart';
import 'package:utmfit/screens/admin/userlist_admin.dart';
import 'package:utmfit/src/constants/colors.dart';


class AdminBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AdminBottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: selectedIndex == 0 ? clrAdmin5 : clrAdminPrimary,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.people,
            color: selectedIndex == 1 ? clrAdmin5 : clrAdminPrimary,
          ),
          label: 'User',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            color: selectedIndex == 2 ? clrAdmin5 : clrAdminPrimary,
          ),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.sports_tennis,
            color: selectedIndex == 3 ? clrAdmin5 : clrAdminPrimary,
          ),
          label: 'Facilities',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.announcement,
            color: selectedIndex == 4 ? clrAdmin5 : clrAdminPrimary,
          ),
          label: 'Announcement',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: clrAdmin5,
      unselectedItemColor: clrAdminPrimary,
      onTap: onItemTapped,
    );
  }
}

void navigateToScreen(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardAdmin()),
      );
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UsersDisplay()),
      );
      break;
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewListBooking()),
      );
      break;
    case 3:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FacilitiesAdmin()),
      );
      break;
    case 4:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AnnouncementsPage()),
      );
      break;
    default:
      break;
  }
}
