import 'package:utmfit/screens/user/dashboard_user.dart'; //dashboard user purposes
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: dashboardUser(), //dashboard user purposes
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