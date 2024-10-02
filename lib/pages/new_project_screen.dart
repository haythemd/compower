import 'package:flutter/material.dart';
import 'package:todo/models/project.dart';
import 'package:todo/services/projectService.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewProjectScreen extends StatefulWidget {
  @override
  _NewProjectScreenState createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _membersController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();

  File? _selectedImage; // To hold the selected image file

  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); 
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Color(0xFFFFF3D0)),
        child: Stack(
          children: [
            Positioned(
              left: 5,
              top: 12,
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
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
                      icon: Icon(Icons.check, color: Colors.black),
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
            SizedBox(width: 10),
            Icon(Icons.check_circle, color: Colors.green), 
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

  void _addProject() async {
    final project = Project(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _nameController.text,
      description: _descriptionController.text,
      photoUrl: _selectedImage?.path ?? '', 
    );

    await ProjectService().addProject(project);

    Navigator.pop(context);
  }
}
