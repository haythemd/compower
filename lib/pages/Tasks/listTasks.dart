import 'package:flutter/material.dart';
import 'package:todo/pages/Tasks/AddTasks.dart';
import '../../models/todo.dart';

class ListTasksPage extends StatefulWidget {
  final List<ToDo> tasks;

  const ListTasksPage({Key? key, required this.tasks}) : super(key: key);

  @override
  State<ListTasksPage> createState() => _ListTasksPageState();
}

class _ListTasksPageState extends State<ListTasksPage> {
  String activeHeader = 'My Tasks';
  int? expandedTaskIndex; // Store the index of the expanded task

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('✅ Tasks'),
        backgroundColor: const Color(0xfffff3d0),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color(0xfffff3d0),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeaderButton('My Tasks'),
                  _buildHeaderButton('All Tasks'),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: widget.tasks.length,
                itemBuilder: (context, index) {
                  ToDo task = widget.tasks[index];
                  bool isExpanded = expandedTaskIndex == index; // Check if the current task is expanded

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        expandedTaskIndex = isExpanded ? null : index; // Toggle expansion
                      });
                    },
                    child: Column(
                      children: [
                        _buildTaskTile(task),
                        if (isExpanded) _buildExpandedContent(task),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskPage()), 
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: const Color(0xff4CAF50),
        ),
      ),
    );
  }

  Widget _buildHeaderButton(String title) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            activeHeader = title;
          });
        },
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            if (activeHeader == title)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.20,
                child: const Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 2,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTile(ToDo task) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: task.isDone
            ? const Icon(Icons.check_box, color: Colors.green)
            : const Icon(Icons.check_box_outline_blank, color: Colors.red),
        title: Text(task.title),
        trailing: Text('${task.price.toString()} TND'),
      ),
    );
  }

  Widget _buildExpandedContent(ToDo task) {
    return Container(
      padding: const EdgeInsets.all(12.0),
    
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Task Dependency', task.dependency ?? 'none'),
          _buildDetailRow('Assign to Member', task.assignedMember ?? 'none'),
          _buildDetailRow('Duration', '${task.duration}h'),
          _buildDetailRow('Cost', '${task.price} TND'),
          _buildDetailRow('Inventory', task.inventory?.toString() ?? 'false'),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                // Action when the Done button is pressed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4CAF50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
