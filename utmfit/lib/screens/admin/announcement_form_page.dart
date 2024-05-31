import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementFormPage extends StatefulWidget {
  final String? announcementId;
  final String? initialTitle;
  final String? initialDescription;

  AnnouncementFormPage({this.announcementId, this.initialTitle, this.initialDescription});

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
      appBar: AppBar(
        title: Text(widget.announcementId == null ? 'Add Announcement' : 'Edit Announcement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAnnouncement,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
