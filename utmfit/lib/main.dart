import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart'; 
import 'package:utmfit/model/UserIdProvider.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
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
    runApp(MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserIdProvider(), // Create an instance of your ChangeNotifier class
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: loginScreen(),
      ),
    );
  }
}
