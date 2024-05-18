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
  late TextEditingController controller;
  String email = '';
  late ForgotPassModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _model = ForgotPassModel();
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    controller.dispose();
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
            child: Stack(
              children: [
                Expanded(
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
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email)
                                    .then((value) {
                                  print("Reset Password Successfully Sent");
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
              ],
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
            controller: controller,
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
                controller.clear();
              },
            )
          ],
        ),
      );
}
