import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/services/todoService.dart';
import '../../models/project.dart';
import '../../services/projectService.dart';
import '../../services/userService.dart';

class Projectspage extends StatefulWidget {
  const Projectspage({super.key});

  @override
  State<Projectspage> createState() => _ProjectspageState();
}

class _ProjectspageState extends State<Projectspage> {
  final ProjectService _projectService = ProjectService();
  final TodoService _todoService = TodoService();

  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImage;
  List<String> selectedMemberIds = [];
  Project? selectedProject; // Nullable project

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Project>>(
      stream: _projectService.getAllProjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Loading state
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')), // Error state
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No projects available')), // No data state
          );
        }

        if (selectedProject == null && snapshot.data!.isNotEmpty) {
          selectedProject = snapshot.data!.first; // Initialize selectedProject with the first project
        }

        // If we have data, display the projects
        return Scaffold(
          body: Row(
            children: [
              SizedBox(
                width: 50,
                child: Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          ...snapshot.data!.map((project) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedProject = project; // Update selected project
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              width: 40,
                              height: 40,
                              child: ClipOval(
                                child: project.photoUrl.isNotEmpty
                                    ? Image.network(project.photoUrl, fit: BoxFit.cover)
                                    : const Icon(Icons.image),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 6,
                      child: IconButton(
                        onPressed: () async {
                          await openModal(context);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: 250, // Adjust the width to suit the design
                  color: Colors.amber[100], // Background color
                  child: Column(
                    children: [
                      _buildProfileSection(selectedProject!),
                      Expanded(
                        child: selectedProject == null
                            ? const Center(child: Text("Select a project"))
                            : ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            _buildMenuItem(
                              icon: Icons.check_circle_outline,
                              title: 'Tasks',
                              trailingText: selectedProject!.tasks.length.toString(),
                              onTap: () {
                                Navigator.of(context).pushNamed("tasks", arguments: selectedProject);
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.person_outline,
                              title: 'Members',
                              trailingText: selectedProject!.members.length.toString(),
                              onTap: () {
                                print(selectedProject!.members);
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.how_to_vote_outlined,
                              title: 'Voting',
                              trailingText: '3', // Example placeholder
                              onTap: () {
                                // Handle Voting tap
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.lightbulb_outline,
                              title: 'Ideas',
                              trailingText: '3', // Example placeholder
                              onTap: () {
                                // Handle Ideas tap
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.forum_outlined,
                              title: 'Forum',
                              trailingText: '4', // Example placeholder
                              onTap: () {
                                // Handle Forum tap
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.account_balance_wallet_outlined,
                              title: 'Balance',
                              trailingText: '\$345', // Example placeholder
                              onTap: () {
                                // Handle Balance tap
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.inventory_2_outlined,
                              title: 'Inventory',
                              trailingText: '\$0', // Example placeholder
                              onTap: () {
                                // Handle Inventory tap
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.settings_outlined,
                              title: 'Settings',
                              onTap: () {
                                // Handle Settings tap
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = bytes; // Update the selected image in state
      });
    } else {
      print('No image selected'); // Log if no image is selected
    }
  }

  Future<String> _uploadImage(Uint8List imageData) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User not authenticated');
      throw Exception('User is not authenticated');
    }

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('images/$fileName');

    try {
      await ref.putData(imageData, SettableMetadata(contentType: 'image/jpeg'));
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow; // Re-throw the error for further handling
    }
  }

  Future<void> openModal(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    List<String> selectedMemberIds = [];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('new Project', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _pickImage(),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.grey[300],
                      child: Text(
                        _selectedImage != null ? 'Image Selected' : 'Image',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final selectedMembers = await _selectMembers(context);
                        selectedMemberIds = selectedMembers;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.grey[300],
                        child: Center(child: Text('Members: ${selectedMemberIds.length}')),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String photoUrl = 'none';

                  if (_selectedImage != null) {
                    photoUrl = await _uploadImage(_selectedImage!);
                  }

                  await ProjectService().addProject(
                    Project(
                      id: '', // Firestore will auto-generate the ID
                      title: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                      photoUrl: photoUrl, // Use the uploaded image URL
                      location: locationController.text.trim(),
                      businessType: categoryController.text.trim(),
                      members: selectedMemberIds.map((id) => ProjectService().projectCollection.doc(id)).toList(),
                      tasks: [],
                      metaData: {},
                    ),
                  );

                  Navigator.pop(context); // Close the modal
                },
                child: const Text('Create'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(Project project) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.amber[200],
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 24,
            child: ClipOval(child: Image.network(project.photoUrl)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
               Text(
                project.description,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: trailingText != null ? Text(trailingText) : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<List<String>> _selectMembers(BuildContext context) async {
    List<String> selectedUserIds = [];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return FutureBuilder(
          future: UserService().getAllUsers(),
          builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No users available'));
            }

            final users = snapshot.data!;

            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Select Members', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final userId = user.id;
                          final userName = user['displayName'] ?? 'Unnamed';

                          return ListTile(
                            title: Text(userName),
                            trailing: Checkbox(
                              value: selectedUserIds.contains(userId),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedUserIds.add(userId);
                                  } else {
                                    selectedUserIds.remove(userId);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, selectedUserIds);
                      },
                      child: const Text('Confirm Selection'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );

    return selectedUserIds;
  }
}
