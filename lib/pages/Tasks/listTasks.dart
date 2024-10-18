import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/pages/Tasks/TimePickerExample.dart';
import 'package:todo/services/projectService.dart';
import '../../models/project.dart';
import '../../models/todo.dart';
import '../../services/todoService.dart';
import 'package:flutter/cupertino.dart';


class ListTasksPage extends StatefulWidget {
  final Project project;

  const ListTasksPage({super.key, required this.project});

  @override
  State<ListTasksPage> createState() => _ListTasksPageState();
}

class _ListTasksPageState extends State<ListTasksPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TodoService _todoService = TodoService();
  final ProjectService _projectService = ProjectService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    currentUser = _auth.currentUser;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Tasks'),
            Tab(text: 'My Tasks'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllTasksTab(),
          _buildMyTasksTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTaskModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMyTasksTab() {
    return FutureBuilder<List<ToDo>>(
      future: _todoService.getTodosByProjectId(widget.project.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tasks available'));
        }

        final myTasks = snapshot.data!
            .where((todo) => todo.assignedMember?.id == currentUser?.uid)
            .toList();

        return ListView.builder(
          itemCount: myTasks.length,
          itemBuilder: (context, index) {
            final todo = myTasks[index];
            return ListTile(
              title: Text(todo.title),
              subtitle: Text(todo.description ?? ''),
              trailing: Icon(
                todo.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: todo.isDone ? Colors.green : Colors.grey,
              ),
              onTap: () => _openEditTaskModal(context, todo),
            );
          },
        );
      },
    );
  }

  Widget _buildAllTasksTab() {
    return FutureBuilder(
      future: Future.wait([...widget.project.tasks.map((e) => e.get())]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No tasks available'));
        }

        final tasks = [...snapshot.data!.map((e) => ToDo.fromFirebase(e))];

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final todo = tasks[index];
            return ListTile(
              title: Text(todo.title),
              subtitle: Text(todo.description ?? ''),
              trailing: Icon(
                todo.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: todo.isDone ? Colors.green : Colors.grey,
              ),
              onTap: () => _openEditTaskModal(context, todo),
            );
          },
        );
      },
    );
  }

  void _openEditTaskModal(BuildContext context, ToDo todo) {
    final TextEditingController titleController = TextEditingController(text: todo.title);
    final TextEditingController descriptionController = TextEditingController(text: todo.description);
    bool isDone = todo.isDone;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Edit Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: isDone,
                      onChanged: (bool? value) {
                        setState(() {
                          isDone = value ?? false;
                        });
                      },
                    ),
                    const Text('Completed')
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final updatedTitle = titleController.text.trim();
                    final updatedDescription = descriptionController.text.trim();

                    if (updatedTitle.isNotEmpty) {
                      try {
                        await _todoService.updateTodo(todo.id.toString(),todo.copyWith(
                          title: updatedTitle,
                          description: updatedDescription.isEmpty ? null : updatedDescription,
                          isDone: isDone,
                        ));
                      } catch (e) {
                        print(e);
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

void _openAddTaskModal(BuildContext context) async {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController inventoryController = TextEditingController();

  DocumentReference? selectedAssignedMember;
  DocumentReference? selectedDependency;
  DocumentSnapshot? selectedTask;

  // Fetch users from Firebase
  List<DocumentSnapshot> users = await FirebaseFirestore.instance.collection('users').get().then((snapshot) => snapshot.docs);
  // Fetch tasks for dependencies
  List<DocumentSnapshot> tasks = await FirebaseFirestore.instance.collection('todos').get().then((snapshot) => snapshot.docs);

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showDurationPicker(BuildContext context) async {
    final Duration? pickedDuration = await showModalBottomSheet<Duration>(
      context: context,
      builder: (context) {
        return DurationPicker(); 
      },
    );

    if (pickedDuration != null) {
      durationController.text = pickedDuration.inHours > 0
          ? '${pickedDuration.inHours}h ${pickedDuration.inMinutes % 60}m'
          : '${pickedDuration.inMinutes}m';
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: startDateController,
                decoration: const InputDecoration(labelText: 'Start Date'),
                readOnly: true,
                onTap: () => _selectDate(context, startDateController),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dueDateController,
                decoration: const InputDecoration(labelText: 'Due Date'),
                readOnly: true,
                onTap: () => _selectDate(context, dueDateController),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Duration'),
                readOnly: true,
                onTap: () => _showDurationPicker(context),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: inventoryController,
                decoration: const InputDecoration(labelText: 'Inventory (JSON format)'),
              ),
              const SizedBox(height: 8),

              DropdownButton<DocumentSnapshot>(
                hint: const Text('Select Assigned Member'),
                value: selectedAssignedMember != null ? users.firstWhere((user) => user.reference == selectedAssignedMember) : null,
                onChanged: (DocumentSnapshot? newUser) {
                  setState(() {
                    selectedAssignedMember = newUser?.reference;
                  });
                },
                items: users.map((DocumentSnapshot user) {
                  return DropdownMenuItem<DocumentSnapshot>(
                    value: user,
                    child: Text(user['displayName']), 
                  );
                }).toList(),
              ),

              DropdownButton<DocumentSnapshot>(
                hint: selectedTask != null ? Text(selectedTask!['title']) : const Text('Select Dependency Task'),
                value: selectedTask,
                onChanged: (DocumentSnapshot? newTask) {
                  setState(() {
                    if (newTask != null) {
                      selectedDependency = newTask.reference;
                      selectedTask = newTask;
                    } else {
                      selectedTask = null; 
                    }
                  });
                  print('Selected Dependency Task: ${selectedTask != null ? selectedTask!['title'] : 'None'}');
                },
                items: tasks.map((DocumentSnapshot task) {
                  return DropdownMenuItem<DocumentSnapshot>(
                    value: task,
                    child: Text(task['title']),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final title = titleController.text.trim();
                  final description = descriptionController.text.trim();
                  final price = double.tryParse(priceController.text.trim()) ?? 0.0;
                  final startDate = startDateController.text.trim().isEmpty ? null : DateTime.parse(startDateController.text.trim());
                  final dueDate = dueDateController.text.trim().isEmpty ? null : DateTime.parse(dueDateController.text.trim());
                  final duration = durationController.text.trim();

                  Map<String, dynamic>? inventory;
                  if (inventoryController.text.isNotEmpty) {
                    try {
                      inventory = jsonDecode(inventoryController.text);
                    } catch (e) {
                      inventory = null;
                    }
                  }

                  if (title.isNotEmpty) {
                    try {
                      await _todoService.createTodo(ToDo(
                        id: null,
                        projectId: _todoService.projectCollection.doc(widget.project.id),
                        title: title,
                        description: description.isEmpty ? null : description,
                        price: price,
                        isDone: false,
                        index: null,
                        groupId: null,
                        startDate: startDate,
                        dueDate: dueDate,
                        duration: duration.isEmpty ? null : duration,
                        inventory: inventory,
                        dependency: selectedDependency,
                        assignedMember: selectedAssignedMember,
                      ));
                    } catch (e) {
                      print(e);
                    }

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}