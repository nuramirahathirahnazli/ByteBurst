import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart'; 
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/src/constants/image_strings.dart';
import 'package:utmfit/screens/user/profile/edit_profile.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser ({super.key});
  
  @override 
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 4; // Assuming profile is the 5th item (index 4)
    return Scaffold(
      backgroundColor: clrBase,
      appBar: AppBar(
        backgroundColor: clrUserPrimary,
        automaticallyImplyLeading: false,
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: 24, // Set the desired font size
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) => {
          // This callback is already defined in your custom navigation bar
        },
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          //get user
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return Stack(
        children: [
          // Curved background container
          Container(
            height: 280.0,
            decoration: BoxDecoration(
              color: clrUserPrimary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(180.0),
                bottomRight: Radius.circular(180.0),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 5.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 219, 219, 219).withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 13,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage(strProfileImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  userData['username'],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 40),
                UserProfileWidget(
                  title: "Edit Profile",
                  icon: Icons.edit,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileUser()),
                    );
                  },
                  backgroundColor: clrUser3,
                ),
                const Divider(),
                const SizedBox(height: 10),
                UserProfileWidget(
                  title: "Password",
                  icon: Icons.lock,
                  onPress: () {},
                  backgroundColor: clrUser3,
                ),
                const SizedBox(height: 10),
                UserProfileWidget(
                  title: "Settings",
                  icon: Icons.settings,
                  onPress: () {},
                  backgroundColor: clrUser3,
                ),
                const Divider(),
                const SizedBox(height: 10),
                UserProfileWidget(
                  title: "Sign Out",
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  backgroundColor: clrUser3,
                  onPress: () {},
                  ),
                    ],
                  ),
                ),
              ],
            );
          }
          else if (snapshot.hasError) {
            return Center(child: Text('Error${snapshot.error}'),
          );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          if (title == 'Sign Out') {
            _showSignOutDialog(context);
          } else {
            onPress();
          }
        },
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: clrUser5.withOpacity(0.1),
          ),
          child: Icon(icon, color: clrUser5),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
        trailing: endIcon ? Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(Icons.arrow_forward, size: 18.0, color: clrUser5),
        ) : null,
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const loginScreen()),
              );
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
