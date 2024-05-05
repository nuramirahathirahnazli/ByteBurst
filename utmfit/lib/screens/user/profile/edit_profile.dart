import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/profile/profile_user.dart';
import 'package:utmfit/src/constants/colors.dart';

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({Key? key}) : super(key: key);

  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final String _profileImage = 'assets/images/profile_pic.jpg';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrUserPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileUser()),
            );
          },
        ),
        title: const Text('Edit Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage(_profileImage),
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      
                      //text field username
                      TextFormField(
                        initialValue: userData['username'],
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          filled: true,
                          fillColor: clrUser3,
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
                          userData['username'] = value!;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      
                      //text field email
                      TextFormField(
                        initialValue: userData['email'],
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: clrUser3,
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
                          userData['email'] = value!;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      
                      //text field phone number
                      TextFormField(
                        initialValue: userData['contactNumber'],
                        decoration: const InputDecoration(
                          labelText: 'Contact Number',
                          filled: true,
                          fillColor: clrUser3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your contact number';
                          }
                          if (!RegExp(r'^\d{3}-\d{7}$').hasMatch(value)) {
                            return 'Please enter a valid contact number in the format xxx-xxxxxxx';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userData['contactNumber'] = value!;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      
                      //text field matric number
                      TextFormField(
                        initialValue: userData['matricNumber'],
                        decoration: const InputDecoration(
                          labelText: 'Matriculation Number',
                          filled: true,
                          fillColor: clrUser3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your matriculation number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userData['matricNumber'] = value!;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      
                      //field user type
                      DropdownButtonFormField<String>(
                        value: userData['userType'],
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          filled: true,
                          fillColor: clrUser3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Student', child: Text('Student')),
                          DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                          DropdownMenuItem(value: 'Outsider', child: Text('Outsider')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            userData['userType'] = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 32.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _updateUserProfile(userData);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: clrUserPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _updateUserProfile(Map<String, dynamic> userData) async {
  try {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.email)
        .update(userData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfileUser()),
    ); // Navigate back to profile screen
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to update profile')),
    );
    print('Failed to update profile: $e');
  }
}


}
