import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  // Singleton instance
  static final TodoService _instance = TodoService._internal();
  factory TodoService() => _instance;
  TodoService._internal();

  // Firestore collection reference
  final CollectionReference _todoCollection =
  FirebaseFirestore.instance.collection('todos');

  // Create a new ToDo
  Future<void> createTodo(ToDo todo) async {
    try {
      await _todoCollection.add({
        'id': todo.id,
        'title': todo.title,
        'description': todo.description,
        'price': todo.price,
        'dueDate': todo.dueDate,
        'isDone': todo.isDone,
        'index': todo.index,
        'predecessor': todo.predecessor,
        'groupId': todo.groupId,
      });
    } catch (e) {
      print('Error creating ToDo: $e');
    }
  }

  // Read ToDos
  Future<List<ToDo>> getTodos() async {
    try {
      QuerySnapshot querySnapshot = await _todoCollection.get();
      return querySnapshot.docs.map((doc) {
        return ToDo(
          id: doc['id'],
          title: doc['title'],
          description: doc['description'],
          price: doc['price'],
          dueDate: doc['dueDate'],
          isDone: doc['isDone'],
          index: doc['index'],
          predecessor: doc['predecessor'],
          groupId: doc['groupId'],
        );
      }).toList();
    } catch (e) {
      print('Error reading ToDos: $e');
      return [];
    }
  }

  // Update an existing ToDo
  Future<void> updateTodo(String docId, ToDo updatedTodo) async {
    try {
      await _todoCollection.doc(docId).update({
        'title': updatedTodo.title,
        'description': updatedTodo.description,
        'price': updatedTodo.price,
        'dueDate': updatedTodo.dueDate,
        'isDone': updatedTodo.isDone,
        'index': updatedTodo.index,
        'predecessor': updatedTodo.predecessor,
        'groupId': updatedTodo.groupId,
      });
    } catch (e) {
      print('Error updating ToDo: $e');
    }
  }

  // Delete a ToDo
  Future<void> deleteTodo(String docId) async {
    try {
      await _todoCollection.doc(docId).delete();
    } catch (e) {
      print('Error deleting ToDo: $e');
    }
  }
}

class ToDo {
  final int id;
  final String title;
  final String description;
  final double price;
  final DateTime dueDate;
  final bool isDone;
  final int index;
  final DocumentReference predecessor;
  final int groupId;

  ToDo({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.dueDate,
    required this.isDone,
    required this.index,
    required this.predecessor,
    required this.groupId,
  });
}