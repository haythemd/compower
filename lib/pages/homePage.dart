import 'package:flutter/material.dart';
import 'package:todo/pages/ProjectPage.dart';
import 'package:todo/pages/new_project_screen.dart'; // Importing the screen for creating new projects
import 'package:todo/models/project.dart'; // Importing the project model
import 'package:todo/services/projectService.dart'; // Importing the service for project management

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ProjectService _projectService = ProjectService(); // Instance of ProjectService to manage projects

  String activeHeader = 'my Projects'; // Initial header to show

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight = MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(color: Color(0xFFFFF3D0)), // Background color
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02), // Spacer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Horizontal padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First Header: My Projects
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          activeHeader = 'my Projects'; // Update active header
                        });
                      },
                      child: Column(
                        children: [
                          const Text(
                            'my Projects',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // Divider to show under the active header
                          if (activeHeader == 'my Projects')
                            Container(
                              width: screenWidth * 0.20,
                              child: const Divider(
                                color: Color(0xFFD9D9D9),
                                thickness: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Second Header: Explore
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          activeHeader = 'explore'; // Update active header
                        });
                      },
                      child: Column(
                        children: [
                          const Text(
                            'explore',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // Divider to show under the active header
                          if (activeHeader == 'explore')
                            Container(
                              width: screenWidth * 0.20,
                              child: const Divider(
                                color: Color(0xFFD9D9D9),
                                thickness: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Button to add new project
                  SizedBox(width: screenWidth * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewProjectScreen(), // Navigate to new project screen
                        ),
                      );
                    },
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Spacer
            // StreamBuilder to display projects
            Expanded(
              child: StreamBuilder<List<Project>>(
                stream: _projectService.getAllProjects(), // Get all projects stream
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // Loading indicator
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error a: ${snapshot.error}')); // Error message
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No projects available.')); // No projects message
                  }

                  List<Project> projects = snapshot.data!; // Projects data

                  // Displaying projects in a list
                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: Image.network(
                              projects[index].photoUrl, // Project image
                              width: 60,
                              height: 100,
                              
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child; // Show image if loaded
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error); // Error icon if image fails to load
                              },
                            ),
                            title: Text(
                              projects[index].title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Kumbh Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              projects[index].description,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Kumbh Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black), // Arrow icon
                            onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectPage(project: projects[index]),
              ),
            );                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
