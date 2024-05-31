import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/src/common_widgets/sidebar.dart';
import 'package:utmfit/src/constants/colors.dart'; // Import color constants from DashboardAdmin
import 'announcement_form_page.dart'; // Import the form page

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final CollectionReference announcementsCollection =
      FirebaseFirestore.instance.collection('announcements');

  void _navigateToFormPage(
      {String? announcementId, String? title, String? description}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnnouncementFormPage(
          announcementId: announcementId,
          initialTitle: title,
          initialDescription: description,
        ),
      ),
    );
  }

  void _deleteAnnouncement(String announcementId) async {
    await announcementsCollection.doc(announcementId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrAdmin2, // Use the same background color as DashboardAdmin
      appBar: _buildAppBar(),
      body: _buildAnnouncementsList(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Announcements'),
      backgroundColor: clrAdminPrimary, // Use the same header color as DashboardAdmin
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _navigateToFormPage(),
        ),
      ],
    );
  }

  Widget _buildAnnouncementsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: announcementsCollection.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var announcement = snapshot.data!.docs[index];
            return ListTile(
              title: Text(
                announcement['title'],
                style: TextStyle(color: Colors.white), // Adjust text color to match the design
              ),
              subtitle: Text(
                announcement['description'],
                style: TextStyle(color: Colors.white), // Adjust text color to match the design
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.white, // Adjust icon color to match the design
                    onPressed: () => _navigateToFormPage(
                      announcementId: announcement.id,
                      title: announcement['title'],
                      description: announcement['description'],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.white, // Adjust icon color to match the design
                    onPressed: () => _deleteAnnouncement(announcement.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
