import 'package:flutter/material.dart';
import 'package:todo/pages/Tasks/listTasks.dart';
import 'package:todo/models/project.dart'; 

class ProjectPage extends StatelessWidget {
  final Project project;

  const ProjectPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff3d0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          project.photoUrl,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
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
                            const SizedBox(height: 4),
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
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigate to the ListTasks screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListTasksPage(tasks: project.tasks),
                      ),
                    );
                  },
                  child: _buildSection(context, Icons.check_box, 'Tasks', project.tasks.length.toString()),
                ),
                _buildSection(context, Icons.person, 'Members', project.members.length.toString()),
                _buildSection(context, Icons.ballot, 'Voting', '3'),
                _buildSection(context, Icons.lightbulb, 'Ideas', '3'),
                _buildSection(context, Icons.forum, 'Forum', '4'),
                _buildSection(context, Icons.money, 'Balance', '\$345'),
                _buildSection(context, Icons.archive, 'Inventory', '\$0'),
                _buildSection(context, Icons.settings, 'Settings', ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, IconData icon, String title, String value) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
              Icon(icon, size: 24), // Use the icon passed in
              const SizedBox(width: 8), // Space between icon and title
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
              if (value.isNotEmpty)
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
