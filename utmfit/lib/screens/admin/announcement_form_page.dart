import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementFormPage extends StatelessWidget {
  final String? announcementId;
  final String? initialTitle;
  final String? initialDescription;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AnnouncementFormPage({
    Key? key,
    this.announcementId,
    this.initialTitle,
    this.initialDescription,
  }) : super(key: key) {
    if (initialTitle != null) {
      titleController.text = initialTitle!;
    }
    if (initialDescription != null) {
      descriptionController.text = initialDescription!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(announcementId == null ? 'Add Announcement' : 'Edit Announcement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(announcementId == null ? 'Add' : 'Update'),
              onPressed: () async {
                final String title = titleController.text;
                final String description = descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  if (announcementId == null) {
                    await FirebaseFirestore.instance.collection('announcements').add({
                      'title': title,
                      'description': description,
                    });
                  } else {
                    await FirebaseFirestore.instance.collection('announcements').doc(announcementId).update({
                      'title': title,
                      'description': description,
                    });
                  }

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
