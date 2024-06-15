// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/screens/user/Auth/signup_user.dart';
import 'package:utmfit/screens/user/dashboard_user.dart';
import 'package:utmfit/screens/admin/dashboard_admin.dart';
import 'package:utmfit/screens/authentication/forgotpassword.dart';

class loginScreen extends StatelessWidget {
  // Firebase Authentication instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // Firestore instance

  const loginScreen({Key? key}) : super(key: key);

  Future<void> _signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      // Sign in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Check if the signed-in user is an admin
      DocumentSnapshot adminSnapshot = await _firestore.collection('admins').doc(email).get();
      if (adminSnapshot.exists) {
        // Navigate to admin dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardAdmin()), // Use your admin dashboard screen
        );
      } else {
        // Navigate to user dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => dashboardUser()),
        );
      }
    } catch (e) {
      // Handle login errors
      print("Error signing in: $e");
      // Show error dialog or toast message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to sign in. Please check your credentials."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

    return Scaffold(
      appBar: AppBar(
        title: Text('UTM FIT'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const signupScreen()),
              );
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 187, 0),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFECAA00),
                Color.fromARGB(255, 224, 207, 159),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Welcome\nSign in!',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: Colors.grey,
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 117, 117, 115),
                        ),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                    valueListenable: obscureText,
                    builder: (context, value, child) {
                      return TextField(
                        controller: passwordController,
                        obscureText: value,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              value ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              obscureText.value = !obscureText.value;
                            },
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 117, 117, 115),
                          ),
                        ),
                      );
                    },
                  ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to the Forgot Password screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPassWidget()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff281537),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    GestureDetector(
                      onTap: () {
                        _signInWithEmailAndPassword(context,
                            emailController.text, passwordController.text);
                      },
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(colors: [
                            Color(0xFFECAA00),
                            Color.fromARGB(255, 224, 207, 159),
                          ]),
                        ),
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const signupScreen()),
                        );
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Text(
                              "Sign up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
