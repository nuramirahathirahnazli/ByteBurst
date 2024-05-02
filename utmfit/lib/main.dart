import 'package:firebase_core/firebase_core.dart';
import 'package:utmfit/screens/user/dashboard_user.dart'; //dashboard user purposes
import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/profile/edit_profile.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: dashboardUser(), 
      home: EditProfileUser(),
    );
  }
}










//-------------------------------------------------------
//kIV UNTUK WELCOME SCREEN
// import 'package:flutter/material.dart';
// import 'package:utmfit/screens/user/welcome_screen.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: WelcomeScreen(),
//     );
//   }
// }