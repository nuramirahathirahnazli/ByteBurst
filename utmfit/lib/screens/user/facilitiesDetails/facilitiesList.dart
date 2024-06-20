import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/facilitiesDetails/courtDetails.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart';
import 'package:utmfit/src/constants/colors.dart';

class FacilitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facilities'),
        backgroundColor: clrUserPrimary,
        automaticallyImplyLeading: false, // Remove the back icon
      ),
      body: Container(
        color: Colors.yellow[50],
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: FacilityCard(
                      title: 'Squash Court',
                      icon: Image.asset(
                        'assets/images/squash.png',
                        width: 125,
                        height: 125,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SquashPage()),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Center(
                    child: FacilityCard(
                      title: 'Ping Pong Court',
                      icon: Image.asset(
                        'assets/images/pingpong.png',
                        width: 80,
                        height: 80,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PingPongPage()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: FacilityCard(
                  title: 'Badminton Court',
                  icon: Image.asset(
                    'assets/images/badminton.png',
                    width: 80,
                    height: 80,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BadmintonPage()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, // Adjust this as needed
        onItemTapped: (index) {
          // Handle navigation
        },
      ),
    );
  }
}

class FacilityCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onPressed;

  const FacilityCard({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
