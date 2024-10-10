import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'new_project_screen.dart';

class ProjectsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('projects').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No projects found.'));
          }

          // Fetching the projects from Firestore
          final projects = snapshot.data!.docs;

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              var project = projects[index];
              String title = project['title'];
              String description = project['description'];
              String imageUrl = project['photoUrl'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleProjectPage(
                        projectId: project.id,
                        title: title,
                        description: description,
                        imageUrl: imageUrl,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: imageUrl.isNotEmpty
                        ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.image, size: 50),
                    title: Text(title),
                    subtitle: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewProjectScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Placeholder for SingleProjectPage
class SingleProjectPage extends StatelessWidget {
  final String projectId;
  final String title;
  final String description;
  final String imageUrl;

  SingleProjectPage({
    required this.projectId,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : Container(
              height: 200,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 100),
            ),
            SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(description),
          ],
        ),
      ),
    );
  }
}

// Placeholder for AddNewProjectPage
class AddNewProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'),
      ),
      body: Center(
        child: Text('Add New Project Page - Implement Form here'),
      ),
    );
  }
}
