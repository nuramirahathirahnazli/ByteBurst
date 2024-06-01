import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/src/common_widgets/sidebar.dart';
import 'package:utmfit/src/constants/colors.dart'; // Import color constants
import 'package:utmfit/src/common_widgets/admin_bottom_navigation.dart'; // Import the new widget
import 'announcement_form_page.dart'; // Import the form page

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  late Future<List<Map<String, dynamic>>> _announcements;
  late Future<int> _totalAnnouncements;
  int _selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _announcements = fetchAnnouncements();
      _totalAnnouncements = fetchTotalAnnouncements();
    });
  }

  Future<List<Map<String, dynamic>>> fetchAnnouncements() async {
    List<Map<String, dynamic>> announcementsList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('announcements').get();
      for (var doc in snapshot.docs) {
        announcementsList.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching announcements: $e");
    }
    return announcementsList;
  }

  Future<int> fetchTotalAnnouncements() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('announcements').get();
      return snapshot.docs.length;
    } catch (e) {
      print("Error fetching total announcements: $e");
      return 0;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _navigateToFormPage({String? announcementId, String? title, String? description}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnnouncementFormPage(
          announcementId: announcementId,
          initialTitle: title,
          initialDescription: description,
          onSave: _fetchData, // Pass the callback function
        ),
      ),
    );

    if (result == true) {
      _fetchData();
    }
  }

  void _deleteAnnouncement(String announcementId) async {
    await FirebaseFirestore.instance.collection('announcements').doc(announcementId).delete();
    _fetchData();
  }

  void _showAnnouncementDetails(BuildContext context, Map<String, dynamic> announcementDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Announcement Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Title: ${announcementDetails['title'] ?? 'N/A'}'),
                Text('Description: ${announcementDetails['description'] ?? 'N/A'}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'List of Announcements',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () => _navigateToFormPage(),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Add New Announcement',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FutureBuilder<int>(
              future: _totalAnnouncements,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching total announcements'));
                } else {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Total Announcements: ${snapshot.data}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _announcements,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching announcements'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No announcements found'));
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Expanded(
                              child: Center(
                                child: Text('No.'),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Center(
                                child: Text('Title'),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Center(
                                child: Text('Action'),
                              ),
                            ),
                          ),
                        ],
                        rows: snapshot.data!.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> announcement = entry.value;
                          return DataRow(cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(Text(announcement['title'] ?? 'N/A')),
                            DataCell(
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.visibility),
                                      color: Colors.blue,
                                      onPressed: () {
                                        _showAnnouncementDetails(context, announcement);
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.orange,
                                      onPressed: () => _navigateToFormPage(
                                        announcementId: announcement['announcementId'],
                                        title: announcement['title'],
                                        description: announcement['description'],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () => _deleteAnnouncement(announcement['announcementId']),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        border: TableBorder.all(width: 1, color: Colors.grey),
                      ),
                    );
                  }
                },
              ),
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
