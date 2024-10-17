import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/services/projectService.dart';
import '../../models/project.dart';
import '../../models/todo.dart';
import '../../services/todoService.dart';

class ListTasksPage extends StatefulWidget {
  final Project project;

  const ListTasksPage({Key? key, required this.project}) : super(key: key);

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
        title: Text('Tasks'),
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
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMyTasksTab() {
    return FutureBuilder<List<ToDo>>(
      future: _todoService.getTodosByProjectId(widget.project.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No tasks available'));
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
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No tasks available'));
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
      shape: RoundedRectangleBorder(
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
                Text('Edit Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 8),
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
                    Text('Completed')
                  ],
                ),
                SizedBox(height: 16),
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
                  child: Text('Confirm'),
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

    // Fetch users from Firebase
    List<DocumentSnapshot> users = await FirebaseFirestore.instance.collection('users').get().then((snapshot) => snapshot.docs);

    // Fetch tasks for dependencies

    DocumentReference? selectedAssignedMember;
    DocumentReference? selectedDependency;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
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
                Text('Add New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: startDateController,
                  decoration: InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: dueDateController,
                  decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: durationController,
                  decoration: InputDecoration(labelText: 'Duration'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: inventoryController,
                  decoration: InputDecoration(labelText: 'Inventory (JSON format)'),
                ),
                SizedBox(height: 8),

                // Assigned Member Selection
                DropdownButton<DocumentSnapshot>(
                  hint: Text('Select Assigned Member'),
                  value: null,
                  onChanged: (DocumentSnapshot? newUser) {
                    selectedAssignedMember = newUser?.reference;
                  },
                  items: users.map((DocumentSnapshot user) {
                    return DropdownMenuItem<DocumentSnapshot>(
                      value: user,
                      child: Text(user['displayName']), // Assuming the user document has a 'name' field
                    );
                  }).toList(),
                ),

                // Dependency Task Selection
                DropdownButton<DocumentSnapshot>(
                  hint: Text('Select Dependency Task'),
                  value: null,
                  onChanged: (DocumentSnapshot? task) {
                    selectedDependency = task?.reference;
                  },
                  items: users.map((DocumentSnapshot user) {
                    return DropdownMenuItem<DocumentSnapshot>(
                      value: user,
                      child: Text(user['displayName']), // Assuming the user document has a 'name' field
                    );
                  }).toList(),
                ),

                SizedBox(height: 16),
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
                  child: Text('Add Task'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
