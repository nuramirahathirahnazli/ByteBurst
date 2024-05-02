import 'package:flutter/material.dart';
import 'package:utmfit/src/constants/colors.dart';

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({Key? key}) : super(key: key);

  @override
  _EditProfileUserState createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  final _formKey = GlobalKey<FormState>();
  String _name = 'Marsha Mahmud';
  String _email = 'marsha@example.com';
  String _phoneNumber = '123-456-7890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Curved background container
          Container(
            height: 180.0,
            decoration: BoxDecoration(
              color: clrUserPrimary, // Set the curved background color
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100.0),
                bottomRight: Radius.circular(100.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60.0), // Increase the vertical spacing
                Center(
                  child: Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Expanded(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            initialValue: _name,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _name = value!;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _email,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _phoneNumber,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (!RegExp(r'^\d{3}-\d{3}-\d{4}$').hasMatch(value)) {
                                return 'Please enter a valid phone number in the format xxx-xxxxxxx';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _phoneNumber = value!;
                            },
                          ),
                          const SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // Save the updated profile information
                                // and navigate back to the ProfileUser screen
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: clrUserPrimary, // Set the button color
                              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                            ),
                            child: const Text('Save Changes'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
