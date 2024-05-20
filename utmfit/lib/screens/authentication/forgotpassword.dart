import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import the necessary colors or any other constants you have
import '../../src/constants/colors.dart';

// Import the ForgotPassModel class if needed
import '../../model/forgotpass.dart';
export '../../model/forgotpass.dart';

class ForgotPassWidget extends StatefulWidget {
  const ForgotPassWidget({Key? key}) : super(key: key);

  @override
  _ForgotPassWidgetState createState() => _ForgotPassWidgetState();
}

class _ForgotPassWidgetState extends State<ForgotPassWidget> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late ForgotPassModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _model = ForgotPassModel();
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    emailController.dispose();
    passwordController.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: clrBase,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 100),
              child: Card(
                color: clrUser3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Image.asset(
                        'assets/images/fp.png',
                        width: 240,
                        height: 240,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Text(
                        'Please Enter Your Email Address To Receive Verification Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // Adjust as needed
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          final email = await openDialog();
                          if (email == null || email.isEmpty) return;
                          final newPassword = passwordController.text;
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email)
                              .then((value) async {
                            print("Reset Password Successfully Sent");
                            // Call the function to update the password in the Users database
                            bool passwordUpdated = await checkIfEmailExistsAndUpdatePassword(email, newPassword);
                            if (passwordUpdated) {
                              print("Password updated successfully in the Users database");
                            } else {
                              print("Email not found in the Users database or password update failed");
                            }
                            Navigator.of(context).pop();
                          }).catchError((error) {
                            print("Error: $error");
                          });
                        },
                        child: Text('Send login code'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Enter Your Email'),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: 'Email'),
        controller: emailController,
      ),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(emailController.text);
            emailController.clear();
          },
        )
      ],
    ),
  );

  Future<bool> checkIfEmailExistsAndUpdatePassword(String email, String newPassword) async {
  try {
    // Query the Users collection to check if the email exists
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .get();

    // If the document exists (email is registered)
    if (userSnapshot.exists) {
      // Update the password field in the user document
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(email)
          .update({'password': newPassword});
      
      // Return true to indicate that the email exists and password updated successfully
      return true;
    } else {
      // If the email doesn't exist, return false
      return false;
    }
  } catch (error) {
    // Handle any errors that occur during the process
    print("Error checking email existence and updating password: $error");
    return false;
  }
}
}