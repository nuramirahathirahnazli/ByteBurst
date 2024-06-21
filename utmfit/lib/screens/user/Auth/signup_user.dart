import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utmfit/screens/user/Auth/signin_user.dart';
import 'package:utmfit/src/constants/colors.dart';

class signupScreen extends StatelessWidget {
  const signupScreen({Key? key}) : super(key: key);

  Future<void> signUp(
      BuildContext context, String email, String password) async {
    try {
      // Create the user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After creating the user, create a new document in Cloud Firestore called Users
      FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.email)
        .set({
          'username' : email.split('@')[0], // Initial username
          'email' : email,
          'password' : password,
          'contactNumber' : 'None', // Default value
          'matricNumber': 'None', // Default value
          'userType' : 'Student', // Default value
          'userRole' : 'User' // Default value, if not admin
        });

      // Navigate to the next screen after successful signup
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => loginScreen()));
    } on FirebaseAuthException catch (e) {
      // Handle signup errors here
      print('Signup error: ${e.message}');
      
      // Show error dialog or snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signup failed: ${e.message}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

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
                    colors: [clrUserPrimary, Color.fromARGB(255, 224, 207, 159)],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 120, left: 40, right: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Sign Up', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black)),
                          SizedBox(height: 8),
                          Text('Create your account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, 
                                backgroundColor: Colors.orange, // Darker orange color for better contrast
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                              ),
                              onPressed: () {
                                if (passwordController.text == confirmPasswordController.text) {
                                  signUp(context, emailController.text, passwordController.text);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Passwords do not match.'),
                                  ));
                                }
                              },
                              child: Text('SIGN UP', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account? ', style: TextStyle(color: Colors.black)),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text('Sign In', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
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
