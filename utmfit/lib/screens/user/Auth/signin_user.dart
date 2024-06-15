// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/screens/admin/Auth/signin_admin.dart';
import 'package:utmfit/screens/admin/dashboard_admin.dart';
import 'package:utmfit/screens/user/Auth/signup_user.dart';
import 'package:utmfit/screens/authentication/forgotpassword.dart';

class loginScreen extends StatelessWidget {
  // Firebase Authentication instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  // Firestore instance
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
          MaterialPageRoute(builder: (context) => DashboardAdmin()), 
        );
      } else {
        // Show error message for non-admin users
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This is for admin sign-in only.")),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color.fromARGB(167, 255, 213, 0), Color.fromARGB(200, 255, 249, 196)],
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLoginPage()));
                              },
                              child: Text(
                                'Admin Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 40, right: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo/UTMfitLogo.png',
                            height: 200, // Adjust the height as needed
                          ),
                          SizedBox(height: 20),
                          Text('User Sign In', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black)),
                          SizedBox(height: 30),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(Icons.email, color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 20),
                          ValueListenableBuilder<bool>(
                            valueListenable: obscureText,
                            builder: (context, value, child) {
                              return TextField(
                                controller: passwordController,
                                obscureText: value,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      value ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      obscureText.value = !obscureText.value;
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(value: false, onChanged: (bool? value) {}),
                                  Text('Remember me', style: TextStyle(color: Colors.black)),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassWidget())),
                                child: Text('Forgot password?', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black, backgroundColor: Color(0xFFFFC107),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                              ),
                              onPressed: () => _signInWithEmailAndPassword(context, emailController.text, passwordController.text),
                              child: Text('LOGIN', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don’t have an account? ', style: TextStyle(color: Colors.black)),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => signupScreen())),
                                child: Text('Sign Up', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
