import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'new_project_screen.dart';

class ProjectsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('projects').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No projects found.'));
          }

          // Fetching the projects from Firestore
          final projects = snapshot.data!.docs;

          print(projects[0].reference.toString());
          print(projects[0].id);
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              var project = projects[index];
              String title = project['title'];
              String description = project['description'];
              String imageUrl = project['photoUrl'];

              print(project.reference.toString());
              print(project.id);
              return GestureDetector(
                onTap: () {

                  print(project.reference.toString());
                  print(project.id);
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
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: imageUrl.isNotEmpty
                        ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 50),
                    title: Text(title),
                    subtitle: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Text(project.id, style: const TextStyle(color: Colors.amber),),
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
            MaterialPageRoute(builder: (context) => const NewProjectScreen()),
          );
        },
        child: const Icon(Icons.add),
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

  const SingleProjectPage({super.key, 
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
              child: const Icon(Icons.image, size: 100),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(description),
          ],
        ),
      ),
    );
  }
}

// Placeholder for AddNewProjectPage
class AddNewProjectPage extends StatelessWidget {
  const AddNewProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Project'),
      ),
      body: const Center(
        child: Text('Add New Project Page - Implement Form here'),
      ),
    );
  }
}
