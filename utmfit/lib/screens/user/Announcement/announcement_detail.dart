import 'package:flutter/material.dart';

class AnnouncementDetailPage extends StatelessWidget {
  final String title;
  final String description;

  AnnouncementDetailPage({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement Detail'),
        backgroundColor:
            Color.fromARGB(255, 255, 231, 172), // Customizing the AppBar color
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 28, // Larger font size for title
                fontWeight: FontWeight.bold,
                color:
                    Color.fromARGB(255, 66, 54, 23), // Custom color for title
              ),
            ),
            SizedBox(height: 16.0),
            Divider(
              color: Color.fromARGB(
                  255, 255, 231, 172), // Custom color for divider
              thickness: 2.0,
            ),
            SizedBox(height: 16.0),
            Text(
              description,
              style: TextStyle(
                fontSize: 18, // Slightly larger font size for description
                height: 1.5, // Increased line height for better readability
                color: Colors.grey[800], // Custom color for description text
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the floating button, e.g., sharing the announcement
          showModalBottomSheet(
            context: context,
            builder: (context) =>
                ShareSheet(title: title, description: description),
          );
        },
        child: Icon(Icons.share), // Example action: share the announcement
        backgroundColor:
            Color.fromARGB(255, 255, 231, 172), // Custom color for the FAB
      ),
    );
  }
}

class ShareSheet extends StatelessWidget {
  final String title;
  final String description;

  ShareSheet({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Share Announcement',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 66, 54, 23),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.share, color: Color.fromARGB(255, 66, 54, 23)),
                onPressed: () {
                  // Implement share functionality
                },
              ),
              IconButton(
                icon: Icon(Icons.copy, color: Color.fromARGB(255, 66, 54, 23)),
                onPressed: () {
                  // Implement copy functionality
                },
              ),
              IconButton(
                icon: Icon(Icons.mail, color: Color.fromARGB(255, 66, 54, 23)),
                onPressed: () {
                  // Implement mail functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
