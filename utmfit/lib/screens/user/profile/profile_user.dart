import 'package:flutter/material.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/src/constants/image_strings.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';

class ProfileUser extends StatelessWidget{
  const ProfileUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: clrBase, // Set the entire background screen color 
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to dashboard_user screen
          },
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
        title: Text("My Profile", style: Theme.of(context).textTheme.headlineMedium),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(50), //50 = size
          child: Column(
            children: [
              SizedBox(
                width : 280,
                height: 280,

                child: ClipRRect(
                  //borderRadius: BorderRadius.circular(150.0), tak jadi bulat
                  child: const Image(image: AssetImage(strProfileImage)),
                ),
              ),
              const SizedBox(height: 20),
              Text("Marsha Mahmud", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height:20),
              Text("marsha@gmail.com", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height:30),
              const Divider(),
              const SizedBox(height:10),

              //MENU
              UserProfileWidget(
                title: "Password",
                icon: Icons.lock,
                onPress: () {},
                backgroundColor: clrUser3,
                 // Set the desired background color
              ),
              const SizedBox(height:10),
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
                onPress: () {
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const loginScreen()),
              );
                },
              ),
            ],
          ),
        ),
      )
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
        borderRadius: BorderRadius.circular(10.0), // Add border radius here
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