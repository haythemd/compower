import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/services/todoService.dart';

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

  final TodoService service = TodoService();

  String? selectedTaskId;

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
                        _handleFormSubmission();
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
              child: GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    dueDateController.text = selectedDate.toLocal().toString().split(' ')[0];
                  }
                },
                child: AbsorbPointer(
                  child: _buildTextField(dueDateController, 'Due Date'),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 222,
              child: GestureDetector(
                onTap: () async {
                  // Fetch tasks from Firebase and show a dialog to select one
                  QuerySnapshot taskSnapshot = await FirebaseFirestore.instance.collection('tasks').get();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Select Task Dependency'),
                        content: Container(
                          width: double.maxFinite,
                          child: ListView(
                            children: taskSnapshot.docs.map((doc) {
                              return ListTile(
                                title: Text(doc['task_name']),
                                onTap: () {
                                  taskDependencyController.text = doc['task_name'];
                                  selectedTaskId = doc.id;
                                  Navigator.of(context).pop();
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: AbsorbPointer(
                  child: _buildTextField(taskDependencyController, 'Task dependency'),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 294,
              child: GestureDetector(
                onTap: () async {
                  // Fetch members from Firebase and show a dialog to select one
                  QuerySnapshot memberSnapshot = await FirebaseFirestore.instance.collection('members').get();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Assign to Member'),
                        content: Container(
                          width: double.maxFinite,
                          child: ListView(
                            children: memberSnapshot.docs.map((doc) {
                              return ListTile(
                                title: Text(doc['name']),
                                onTap: () {
                                  assignToMemberController.text = doc['name'];
                                  Navigator.of(context).pop();
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: AbsorbPointer(
                  child: _buildTextField(assignToMemberController, 'Assign to member'),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 366,
              child: GestureDetector(
                onTap: () async {
                  // Pick a duration using time picker
                  Duration? pickedDuration = await showDurationPicker(context);
                  if (pickedDuration != null) {
                    durationController.text = '${pickedDuration.inHours} hrs';
                  }
                },
                child: AbsorbPointer(
                  child: _buildTextField(durationController, 'Duration'),
                ),
              ),
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

  Future<Duration?> showDurationPicker(BuildContext context) async {
    return await showModalBottomSheet<Duration>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              Text(
                'Pick Duration',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, Duration(hours: 1)),
                    child: Text('1 hr'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, Duration(hours: 2)),
                    child: Text('2 hrs'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, Duration(hours: 3)),
                    child: Text('3 hrs'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _handleFormSubmission() {
    // Collect data from controllers
    final String taskName = taskNameController.text;
    final String dueDate = dueDateController.text;
    final String taskDependency = taskDependencyController.text;
    final String assignedMember = assignToMemberController.text;
    final String duration = durationController.text;
    final String cost = costController.text;
    final String inventory = inventoryController.text;

    // Validate input (basic validation)
    if (taskName.isEmpty || dueDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task name and due date are required!')),
      );
      return;
    }

    // Create a task map to be added to Firestore
    final Map<String, dynamic> newTask = {
      'task_name': taskName,
      'due_date': dueDate,
      'task_dependency': taskDependency,
      'assigned_member': assignedMember,
      'duration': duration,
      'isDone': false,
      'cost': cost,
      'inventory': inventory,
      'created_at': Timestamp.now(),
    };

    // Submit the task using the service
    service.createTodo(ToDo.fromJson(newTask)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added successfully!')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: $error')),
      );
    });
  }
}