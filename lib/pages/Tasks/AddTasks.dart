import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTaskPage> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController taskDependencyController = TextEditingController();
  final TextEditingController assignToMemberController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController inventoryController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    taskNameController.dispose();
    dueDateController.dispose();
    taskDependencyController.dispose();
    assignToMemberController.dispose();
    durationController.dispose();
    costController.dispose();
    inventoryController.dispose();
    super.dispose();
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
                      'New Task',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2A2A2A),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.black),
                      onPressed: () {
                        // Handle submission logic here
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 79,
              child: _buildTextField(taskNameController, 'Task name'),
            ),
            Positioned(
              left: 8,
              top: 150,
              child: _buildTextField(dueDateController, 'Due Date'),
            ),
            Positioned(
              left: 8,
              top: 222,
              child: _buildTextField(taskDependencyController, 'Task dependency'),
            ),
            Positioned(
              left: 8,
              top: 294,
              child: _buildTextField(assignToMemberController, 'Assign to member'),
            ),
            Positioned(
              left: 8,
              top: 366,
              child: _buildTextField(durationController, 'Duration'),
            ),
            Positioned(
              left: 8,
              top: 438,
              child: _buildTextField(costController, 'Cost'),
            ),
            Positioned(
              left: 8,
              top: 510,
              child: _buildTextField(inventoryController, 'Inventory?'),
            ),
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
