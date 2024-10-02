import 'package:flutter/material.dart';
import 'package:todo/pages/new_project_screen.dart';
import 'package:todo/models/project.dart'; 
import 'package:todo/services/projectService.dart'; 
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ProjectService _projectService = ProjectService();

  String activeHeader = 'my Projects';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(color: Color(0xFFFFF3D0)),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          activeHeader = 'my Projects'; 
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          activeHeader = 'explore'; 
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
                  SizedBox(width: screenWidth * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewProjectScreen(),
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
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: StreamBuilder<List<Project>>(
                stream: _projectService.getAllProjects(), 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No projects available.'));
                  }

                  List<Project> projects = snapshot.data!;

                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          color: Colors.white,
                          child: ListTile(
                       leading: Image.network(
                              projects[index].photoUrl!, 
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                );
                              },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
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
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                            onTap: () {
                              // Handle project click
                            },
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
