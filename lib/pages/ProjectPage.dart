import 'package:flutter/material.dart';
import 'package:todo/models/project.dart';
import 'package:todo/services/todoService.dart'; // Import the project model
import '../services/projectService.dart';

class ProjectPage extends StatelessWidget {
  final Project project; // Project data to display
  final TodoService service = TodoService();

  ProjectPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff3d0), // Light yellow background
      body: SafeArea(
        child: SingleChildScrollView( // Added scroll view to prevent overflow
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Global padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(height: 16), // Space between back button and content

                // Project details (image, title, and description)
                Row(
                  children: [
                    // Project image
                    ClipOval(
                      child: Image.network(
                        project.photoUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error); // Error icon
                        },
                      ),
                    ),
                    const SizedBox(width: 12), // Space between image and text

                    // Project title and description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'KumbhSans-Bold',
                            ),
                          ),
                          const SizedBox(height: 4), // Space between title and description
                          Text(
                            project.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'KumbhSans-Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Space between details and section list

                // Section list
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      'tasks',
                      arguments: project.id,
                    );
                  },
                  child: _buildSection(context, '✅', 'Tasks', project.tasks.length.toString()),
                ),
                _buildSection(context, '👤', 'Members', project.members.length.toString()),
                _buildSection(context, '🗳️', 'Voting', '3'),
                _buildSection(context, '💡', 'Ideas', '3'), // New section for ideas
                _buildSection(context, '💬', 'Forum', '4'),
                _buildSection(context, '💵', 'Balance', '\$345'),
                _buildSection(context, '📦', 'Inventory', '\$0'),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProjectSettingsPage(project: project),
                    ));
                  },
                  child: _buildSection(context, '⚙️', 'Settings', ''),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each section
  Widget _buildSection(BuildContext context, String emoji, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4), // Vertical space between sections
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffe8e8e8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)), // Emoji icon
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (value.isNotEmpty) // Value (if present)
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Arrow
            ],
          ),
        ],
      ),
    );
  }
}

class ProjectSettingsPage extends StatelessWidget {
  final Project project;
  final ProjectService _projectService = ProjectService();

  ProjectSettingsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final TextEditingController titleController = TextEditingController(text: project.title);
                final TextEditingController descriptionController = TextEditingController(text: project.description);
                final TextEditingController locationController = TextEditingController(text: project.location);
                final TextEditingController businessTypeController = TextEditingController(text: project.businessType);
                final TextEditingController photoUrlController = TextEditingController(text: project.photoUrl);

                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProjectPage(
                    project: project,
                    titleController: titleController,
                    descriptionController: descriptionController,
                    locationController: locationController,
                    businessTypeController: businessTypeController,
                    photoUrlController: photoUrlController,
                  ),
                ));
              },
              child: Text('Edit Project'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await _projectService.deleteProject(project.id);
                Navigator.of(context).pop();
              },
              child: Text('Delete Project'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProjectPage extends StatelessWidget {
  final Project project;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final TextEditingController businessTypeController;
  final TextEditingController photoUrlController;
  final ProjectService _projectService = ProjectService();

  EditProjectPage({
    super.key,
    required this.project,
    required this.titleController,
    required this.descriptionController,
    required this.locationController,
    required this.businessTypeController,
    required this.photoUrlController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: businessTypeController,
                decoration: InputDecoration(labelText: 'Business Type'),
              ),
              TextField(
                controller: photoUrlController,
                decoration: InputDecoration(labelText: 'Photo URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final updatedProject = Project(
                    id: project.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    photoUrl: photoUrlController.text,
                    location: locationController.text,
                    businessType: businessTypeController.text,
                    members: project.members,
                    tasks: project.tasks,
                    metaData: project.metaData,
                  );
                  await _projectService.updateProject(project.id, updatedProject);
                  Navigator.of(context).pop();
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}