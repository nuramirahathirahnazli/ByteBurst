import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/src/constants/colors.dart'; // Import color constants

class AnnouncementFormPage extends StatefulWidget {
  final String? announcementId;
  final String? initialTitle;
  final String? initialDescription;
  final VoidCallback onSave;

  AnnouncementFormPage({this.announcementId, this.initialTitle, this.initialDescription, required this.onSave});

  @override
  _AnnouncementFormPageState createState() => _AnnouncementFormPageState();
}

class _AnnouncementFormPageState extends State<AnnouncementFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference announcementsCollection = FirebaseFirestore.instance.collection('announcements');

  @override
  void initState() {
    super.initState();
    if (widget.announcementId != null) {
      _titleController.text = widget.initialTitle!;
      _descriptionController.text = widget.initialDescription!;
    }
  }

  Future<void> _saveAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      if (widget.announcementId == null) {
        // Add new announcement
        await announcementsCollection.add({
          'title': _titleController.text,
          'description': _descriptionController.text,
        });
      } else {
        // Update existing announcement
        await announcementsCollection.doc(widget.announcementId).update({
          'title': _titleController.text,
          'description': _descriptionController.text,
        });
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrAdminBase,
      appBar: AppBar(
        backgroundColor: clrAdminPrimary,
        elevation: 0,
        title: Text(widget.announcementId == null ? 'Add Announcement' : 'Edit Announcement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Announcement Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _saveAnnouncement,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: clrAdmin4,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            child: Text('Save New Announcement'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
