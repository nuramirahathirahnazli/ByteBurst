import 'package:flutter/material.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/src/constants/image_strings.dart';

class ProfileUser extends StatelessWidget{
  const ProfileUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrBase, // Set the entire background screen color
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), // Navigate back to dashboard_user screen
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
        title: Text("My Profile", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Stack(
        children: [
          // Curved background container
          Container(
            height: 280.0,
            decoration: BoxDecoration(
              color: clrUserPrimary, // Set the curved background color
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
                  width: 200, // Set the desired size
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.white, // Set the border color
                      width: 5.0, // Set the border width
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
                    child: Image(image: AssetImage(strProfileImage), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 7),
              Text(
                "Marsha Mahmud",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
              UserProfileWidget(
                title: "Edit Profile",
                icon: Icons.edit,
                onPress: () {},
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
                backgroundColor: clrUser3, // Set the desired background color
              ),
              const Divider(),
              const SizedBox(height: 10),
              UserProfileWidget(
                title: "Sign Out",
                icon: Icons.logout,
                textColor: Colors.red,
                endIcon: false,
                backgroundColor: clrUser3, // Set the desired background color
                onPress: () {},
              ),
           ],
            ),
          ),
        ],
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
    this.backgroundColor, // Add a new property for background color
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? backgroundColor; // New property for background color

  @override
  Widget build(BuildContext context) {
    
        return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0), // Add border radius here
      ),
        child: ListTile(  // Nested within Container
        onTap: onPress,
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
}