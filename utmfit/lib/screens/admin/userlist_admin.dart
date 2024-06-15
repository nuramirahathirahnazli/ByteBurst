import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/src/common_widgets/sidebar.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/src/common_widgets/admin_bottom_navigation.dart'; // Import the new widget

class UsersDisplay extends StatefulWidget {
  const UsersDisplay({Key? key}) : super(key: key);

  @override
  _UsersDisplayState createState() => _UsersDisplayState();
}

class _UsersDisplayState extends State<UsersDisplay> {
  late Future<List<Map<String, dynamic>>> _users;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _users = fetchUsers();
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    List<Map<String, dynamic>> usersList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users').get();
      for (var doc in snapshot.docs) {
        usersList.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
    return usersList;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrAdminBase,
      appBar: AppBar(
        backgroundColor: clrAdminPrimary,
        elevation: 0,
        title: Row(
          children: [
            Spacer(),
            Text('Hi, Admin', style: TextStyle(color: Colors.white)),
            Spacer(),
            TextButton(
              onPressed: () {
                // Add sign out functionality here
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      drawer: sidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'List of Users',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _users,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching users'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found'));
                } else {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Total All: ${snapshot.data!.length}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(label: Text('No.')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Email')),
                          ],
                          dataRowHeight: 60,
                          rows: snapshot.data!.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> user = entry.value;
                            return DataRow(cells: [
                              DataCell(Text((index + 1).toString())),
                              DataCell(Text(user['name'] ?? 'N/A')),
                              DataCell(Text(user['email'] ?? 'N/A')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
