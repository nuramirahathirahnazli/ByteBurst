// Importing necessary packages
import 'package:flutter/material.dart'; // Flutter material library for UI components
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package

// Importing the ForgotPassModel class from another file and exporting it
import '../../model/forgotpass.dart';
export '../../model/forgotpass.dart';

// Defining a StatefulWidget for the ForgotPassWidget
class ForgotPassWidget extends StatefulWidget {
  const ForgotPassWidget({Key? key}) : super(key: key);

  @override
  _ForgotPassWidgetState createState() => _ForgotPassWidgetState();
}

// State class for the ForgotPassWidget
class _ForgotPassWidgetState extends State<ForgotPassWidget> {
  late TextEditingController controller; // Controller for handling text input
  String email = ''; // String to store email address
  late ForgotPassModel _model; // Instance of ForgotPassModel class

  final scaffoldKey = GlobalKey<ScaffoldState>(); // Key for accessing the Scaffold state
  final _unfocusNode = FocusNode(); // Focus node to handle focus events

  // Initialization function called when the state is first created
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(); // Initializing the controller
    _model = ForgotPassModel(); // Initializing the ForgotPassModel instance
    _model.initState(context); // Initializing the state of the model
  }

  // Function called when the state is about to be disposed
  @override
  void dispose() {
    _model.dispose(); // Disposing the model
    controller.dispose(); // Disposing the controller
    _unfocusNode.dispose(); // Disposing the focus node
    super.dispose();
  }

  // Build function to construct the UI of the widget
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode), // Handling tap to unfocus
      child: Scaffold(
        key: scaffoldKey, // Setting the key for the scaffold
        backgroundColor: Color.fromARGB(255, 247, 249, 238), // Setting background color
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigating back to the previous screen
            },
          ),
          // Customize the AppBar as needed
          // title: Text('Forgot Password'),
          // backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 100),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Color(0xAEFFFFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Image.asset(
                              'assets/images/fp.png', // Image asset path
                              width: 240,
                              height: 240,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Text(
                              'Forgot Password?', // Title text
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                            child: Text(
                              'Please Enter Your Email Address To Receive Verification Code', // Instruction text
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                final email = await openDialog(); // Opening a dialog to get email
                                if (email == null || email.isEmpty) return; // If email is empty, return
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email) // Sending reset password email
                                    .then((value) {
                                  print("Reset Password Succesfully Sent"); // Printing success message
                                  Navigator.of(context).pop(); // Closing the current screen
                                }).onError((error, stackTrace) {
                                  print("Error ${error.toString()}"); // Printing error message
                                });
                                print('Button pressed ...'); // Printing button press
                              },
                              child: Text(
                                'Sent login code', // Button text
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Color.fromARGB(
                                        255, 198, 192, 80)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(0, 0, 0, 0)),
                                minimumSize: MaterialStateProperty.all(
                                    Size(180, 50)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                                side: MaterialStateProperty.all(BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                )),
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
          ),
        ),
      ),
    );
  }

  // Function to open a dialog to get user email
  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Enter Your Email'), // Dialog title
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Email'), // Text field for email input
            controller: controller,
          ),
          actions: [
            TextButton(
              child: Text('OK'), // OK button
              onPressed: () {
                Navigator.of(context).pop(controller.text); // Closing dialog and passing email text
                controller.clear(); // Clearing the text field
              },
            )
          ],
        ),
      );
}
