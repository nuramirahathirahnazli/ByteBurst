// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'package:utmfit/screens/user/dashboard_user.dart';
import 'package:utmfit/screens/admin/dashboard_admin.dart';
import 'package:utmfit/screens/user/profile/edit_profile.dart';
import 'package:utmfit/screens/user/profile/profile_user.dart';
import 'package:utmfit/screens/user/booking/history_booking.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51PRy8rF2XcU0Er0ON7LqvlwzIOYHoFJ6FpckZi7xblQVQwFe8yUBPXj9gFiy4CpT6Q7VMU1FrPExJw2n7cC5j1KO005VRrltOc";
  await Stripe.instance.applySettings();
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
        debugShowCheckedModeBanner: false, home: loginScreen());
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