import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/projectService.dart';

class ProjectsListPage extends StatefulWidget {
  const ProjectsListPage({super.key});

  @override
  _ProjectsListPageState createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends State<ProjectsListPage> {
  final ProjectService _projectService = ProjectService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: StreamBuilder<List<Project>>(
        stream: _projectService.getAllProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No projects available'));
          }

          final projects = snapshot.data!;

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ListTile(
                title: Text(project.title),
                subtitle: Text(project.description),
                leading: project.photoUrl.isNotEmpty
                    ? Image.network(project.photoUrl, width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    'project',
                    arguments: project,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProjectDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController businessTypeController = TextEditingController();
    final TextEditingController photoUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Project'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: businessTypeController,
                  decoration: const InputDecoration(labelText: 'Business Type'),
                ),
                TextField(
                  controller: photoUrlController,
                  decoration: const InputDecoration(labelText: 'Photo URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Since members and tasks are now DocumentReferences, we'll keep them empty for now
                final project = Project(
                  id: '', // Firestore will generate the ID
                  title: titleController.text,
                  description: descriptionController.text,
                  photoUrl: photoUrlController.text,
                  location: locationController.text,
                  businessType: businessTypeController.text,
                  members: [], // Empty for now, assuming members will be added later
                  tasks: [],   // Empty for now, assuming tasks will be added later
                  metaData: {}, // Empty metaData
                );
                await _projectService.addProject(project);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
