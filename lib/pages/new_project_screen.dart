import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/project.dart';
import 'package:todo/services/projectService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';


class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  _NewProjectScreenState createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _membersController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();

  Uint8List? _selectedImage; // To hold the selected image data

  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

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
  
  // Check if user is authenticated
  if (user == null) {
    print('User not authenticated');
    throw Exception('User is not authenticated');
  }

  // Check if the current time is before the allowed date
  DateTime currentTime = DateTime.now();
  if (currentTime.isAfter(DateTime(2024, 11, 1))) {
    print('Upload period has expired');
    throw Exception('Upload period has expired');
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


  void _addProject() async {
    String imageUrl = '';

    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    final project = Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _nameController.text,
      description: _descriptionController.text,
      photoUrl: imageUrl,
      location: _locationController.text,
      businessType: _businessTypeController.text,
      members: _membersController.text.split(',').map((member) => FirebaseFirestore.instance.doc('members/'+member.trim())).toList(),
      tasks: [], metaData: {},
    );

    await ProjectService().addProject(project);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Color(0xFFFFF3D0)),
        child: Stack(
          children: [
            Positioned(
              left: 5,
              top: 12,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'New Project',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2A2A2A),
                        fontSize: 18,
                        fontFamily: 'Kumbh Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.black),
                      onPressed: _addProject,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 79,
              child: _buildTextField(_nameController, 'Project name'),
            ),
            Positioned(
              left: 8,
              top: 150,
              child: _buildImagePicker(),
            ),
            Positioned(
              left: 8,
              top: 222,
              child: _buildTextField(_descriptionController, 'Project description'),
            ),
            Positioned(
              left: 8,
              top: 294,
              child: _buildTextField(_membersController, 'Project members'),
            ),
            Positioned(
              left: 8,
              top: 366,
              child: _buildTextField(_locationController, 'Location'),
            ),
            Positioned(
              left: 8,
              top: 438,
              child: _buildTextField(_businessTypeController, 'Type of business'),
            ),
            // Add image preview at the bottom
            if (_selectedImage != null) 
              Positioned(
                left: 8,
                bottom: 20, // Position it near the bottom
                child: Container(
                  width: MediaQuery.of(context).size.width - 16,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                    image: DecorationImage(
                      image: MemoryImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      width: MediaQuery.of(context).size.width - 16,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: GestureDetector(
        onTap: _pickImage,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _selectedImage != null ? "Image Selected" : "Pick Image",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(width: 10),
              const Icon(Icons.check_circle, color: Colors.green),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String placeholderText) {
    return Container(
      width: MediaQuery.of(context).size.width - 16,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: placeholderText,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
