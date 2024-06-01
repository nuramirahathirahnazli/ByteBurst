import 'package:flutter/material.dart';
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
            color: selectedIndex == 0 ? clrAdmin4 : clrAdminPrimary,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.people,
            color: selectedIndex == 1 ? clrAdmin4 : clrAdminPrimary,
          ),
          label: 'User',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            color: selectedIndex == 2 ? clrAdmin4 : clrAdminPrimary,
          ),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.sports_tennis,
            color: selectedIndex == 3 ? clrAdmin4 : clrAdminPrimary,
          ),
          label: 'Facilities',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.announcement,
            color: selectedIndex == 4 ? clrAdmin4 : clrAdminPrimary,
          ),
          label: 'Announcement',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: clrAdmin4,
      unselectedItemColor: clrAdminPrimary,
      onTap: onItemTapped,
    );
  }
}
